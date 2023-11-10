/**
 
 
 */

import SwiftUI

// Bot Friend共通
struct GameMainController {
    
    func initFunction() {
        BgmMng.shared.playSound(bgmName: SoundName.BGM.game_main.rawValue)
    }
    
    func setMode(mode: GameMode) {
        appState.gameUIState.gameMode = mode
    }
    
    func exitRoom(info: vsInfo) {
        
        BgmMng.shared.stopSound()
        Router().pushBasePage(pageId: .home)
        self.setMode(mode: .base)

        // 退出処理
        if info == .vsBot {
            // gameUIStateの初期化
            appState.matching = nil
            appState.gameUIState.resetItem()
        } else {
            // 退出アナウンス
            RoomFirebaseManager().updateMatchingFlg(roomID: appState.room.roomData.roomID, value: 2) { result in
                if result {
                    // gameUIStateの初期化
                    appState.matching = nil
                    appState.gameUIState.resetItem()
                    // 削除
                    appState.gameUIState.deleteGamedate()

                }
            }
        }
    }
    
    func exitRoomParticipate() {
        Router().pushBasePage(pageId: .home)
        self.setMode(mode: .base)
        // gameUIStateの初期化
        appState.matching = nil
        appState.gameUIState.resetItem()
    }
    
    // 強制パス処理
    func timeLimitAction() {
        if appState.gameUIState.gamevsInfo == .vsBot {
                        
        } else {
            if appState.gameUIState.turnFlg == 0 {
                
                GameFriendEventController().draw(playerID: appState.gameUIState.players[appState.gameUIState.myside].id,
                                                 playerIndex: appState.gameUIState.myside)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    GameFriendEventController().pass(passPayerIndex: appState.gameUIState.myside,
                                                     playersCount: appState.gameUIState.players.count)
                }

            } else {
                GameFriendEventController().pass(passPayerIndex: appState.gameUIState.myside,
                                                 playersCount: appState.gameUIState.players.count)
            }
        }
    }
    
    // チャレンジモード関連以外か
    func judgeChallenge(gamePase: GamePhase) -> Bool {
        switch gamePase {
        case .startChallenge, .challenge, .endChallenge, .revengeInMain, .revengeInChallenge, .q_challenge, .noChallenge, .decisionrate_pre, .decisionrate:
            return false
        default:
            return true
        }
    }

    // Challengeに参加できるか
    func judgeChallengeJoin(myside: Int, playerAllCards: [CardId], table: [CardId]) -> Int {
        var result = Constants.ngCode

        // tableが空だったらだめ
        if table.isEmpty {
            return Constants.ngCode
        }
        // 手札がとりえる値
        let possibleSum = GameBotController().calculatePossibleSums(cards: playerAllCards)
        for sum in possibleSum {
            if sum == table.last!.number() {
                return Constants.dtnkCode
            } else if sum < table.last!.number() {
                result = Constants.challengeCode
            }
        }
        return result
    }
    
    // playerにスコア払出し
    func updateScores(with winners: [Player_f], losers: [Player_f], gameScore: Int) {
        
        for winner in winners {
            if let index = appState.gameUIState.players.firstIndex(where: { $0.id == winner.id }) {
                appState.gameUIState.players[index].score += gameScore * losers.count
            }
        }
        
        for loser in losers {
            if let index = appState.gameUIState.players.firstIndex(where: { $0.id == loser.id }) {
                appState.gameUIState.players[index].score -= gameScore * winners.count
            }
        }
    }
    
    
    //------------------------------------CHALLENGE
    //------------------------------------CHALLENGE
    
    func getNextChallenger(nowIndex: Int, participants: [[Int]]) -> Int? {
        // 現在のプレイヤーの番号を見つけます。
        guard let targetIndex = participants.firstIndex(where: { $0[0] == nowIndex }) else {
            return nil
        }

        // 次のプレイヤーを探します。
        var nextIndex = targetIndex
        repeat {
            // 次のインデックスを計算（リングバッファのように処理）
            nextIndex = (nextIndex + 1) % participants.count

            // フラグが0のプレイヤーを見つけたら返す
            if participants[nextIndex][1] == 0 {
                return participants[nextIndex][0]
            }
        } while nextIndex != targetIndex // 全プレイヤーをチェックし終わるまでループ

        // 全プレイヤーのフラグが0でなければnilを返す
        return nil
    }

    // OverしたらFlgを立てる
    func updateParticipantFlag(Index: Int, challengers: [[Int]]) -> [[Int]] {
        var updateChallengers = challengers
        for (index, challenger) in challengers.enumerated() {
            if challenger[0] == Index {
                updateChallengers[index][1] = 1
                break
            }
        }
        return updateChallengers
    }
    
    // OverしてるかCheck
    func checkIfParticipantFlagIsOne(Index: Int, challengers: [[Int]]) -> Bool {
        for challenger in challengers {
            if challenger[0] == Index {
                return challenger[1] == 1
            }
        }
        return false
    }


}

class GameBotController {
    
    var game: GameUIState = appState.gameUIState

    //**********************************************************************************
    // Bot Action
    //**********************************************************************************
        
    /**
     Bot操作　Main
     ① 出せるからすぐ出す
     ② 出せるけど引いて出す
     ③ 出せるけど引くそして出さない
     ④ 出せないので引く、出せるので出す
     ⑤ 出せないので引く、出せるけどパス
     ⑥ 出せないので引く、出せないのでパス
     */
    // TODO: 綺麗にする
    func botAction(Index: Int, completion: @escaping (Bool) -> Void) {
        
        guard judgeInGame() else {
            completion(false)
            return
        }
        
        // 手札全パターン
        let allPatern = generateAllCombinations(cards: game.players[Index].hand)
        var playCards: [[CardId]] = []
        
        // 出せるパターンに格納
        for cards in allPatern {
            let result = checkMultipleCards(table: game.table.last!, playCard: cards)
            if result {
                playCards.append(cards)
            }
        }
        
        // 自分のターンになって考える時間
        let time01: Double = 0.8
        // カードを引く前に考える時間
        let time02: Double = 0.8
        // カードを出すまでに考える時間
        let time03: Double = 0.8
        //　パスするまでに考える時間
        let time04: Double = 0.8
        
        
        // どてんこできるか
        let dtnkJudge = dtnkJudge(myside: Index, playerAllCards: game.players[Index].hand, table: game.table)
        
        if dtnkJudge == Constants.dtnkCode && game.lastPlayerIndex != Index {
            // 自分のターンになって次の処理をするまでの時間
            DispatchQueue.main.asyncAfter(deadline: .now() + time01) { [self] in
                // どてんこ
                dtnk(Index: Index)
                completion(true)
                return
            }
        } else {
            // 自分のターンになって次の処理をするまでの時間
            DispatchQueue.main.asyncAfter(deadline: .now() + time01) { [self] in
                // 出せる時
                if !playCards.isEmpty {
                    playCards.shuffle()
                    let random = Int.random(in: 0..<100)
                    
                    if random < 70  {
                        guard judgeInGame() else {
                            completion(false)
                            return
                        }
                        log("\(Index): ① 出せるからすぐ出す", level: .debug)
                        log("\( playCards.first!)")
                        game.table.append(contentsOf: playCards.first!)
                        game.players[Index].hand.removeAll(where: { playCards.first!.contains($0)})
                        game.lastPlayerIndex = Index
                        DispatchQueue.main.async { [self] in
                            totable(card: playCards.first!)
                            tohands(Index: Index)
                        }
                        //　パスするまでの時間
                        DispatchQueue.main.asyncAfter(deadline: .now() + time04) { [self] in
                            guard judgeInGame() else {
                                completion(false)
                                return
                            }
                            // 次のターンへ
                            pass(Index: Index)
                            completion(true)
                        }
                    } else if random < 90 {
                        guard judgeInGame() else {
                            completion(false)
                            return
                        }
                        log("\(Index): ② 出せるけど引いて出す", level: .debug)
                        // ② 出せるけど引いて出す
                        // カードを引く前に考える時間
                        DispatchQueue.main.asyncAfter(deadline: .now() + time02) { [self] in
                            guard judgeInGame() else {
                                completion(false)
                                return
                            }
                            drawCard(Index: Index)
                        }
                        // カードを出すまでに考える時間
                        DispatchQueue.main.asyncAfter(deadline: .now() + time03 + 0.3) { [self] in
                            guard judgeInGame() else {
                                completion(false)
                                return
                            }
                            log("\( playCards.first!)")
                            game.table.append(contentsOf: playCards.first!)
                            game.players[Index].hand.removeAll(where: { playCards.first!.contains($0) })
                            game.lastPlayerIndex = Index
                            DispatchQueue.main.async { [self] in
                                totable(card: playCards.first!)
                                tohands(Index: Index)
                            }
                        }
                        //　パスするまでの時間
                        DispatchQueue.main.asyncAfter(deadline: .now() + time04 + 0.5) { [self] in
                            guard judgeInGame() else {
                                completion(false)
                                return
                            }
                            // 次のターンへ
                            pass(Index: Index)
                            completion(true)
                        }
                    } else {
                        guard judgeInGame() else {
                            completion(false)
                            return
                        }
                        log("\(Index): ③ 出せるけど引くそして出さない", level: .debug)
                        // カードを引く前に考える時間
                        DispatchQueue.main.asyncAfter(deadline: .now() + time02) { [self] in
                            guard judgeInGame() else {
                                completion(false)
                                return
                            }
                            drawCard(Index: Index)
                        }
                        //　パスするまでの時間
                        DispatchQueue.main.asyncAfter(deadline: .now() + time04 + 0.3) { [self] in
                            guard judgeInGame() else {
                                completion(false)
                                return
                            }
                            // 次のターンへ
                            pass(Index: Index)
                            completion(true)
                        }
                    }
                    
                } else {
                    // 出せない時
                    // カードを引く前に考える時間
                    DispatchQueue.main.asyncAfter(deadline: .now() + time02) { [self] in
                        guard judgeInGame() else {
                            completion(false)
                            return
                        }
                        drawCard(Index: Index)
                        
                        let allPatern = generateAllCombinations(cards: game.players[Index].hand)
                        for cards in allPatern {
                            let result = checkMultipleCards(table: game.table.last!, playCard: cards)
                            if result {
                                playCards.append(cards)
                            }
                        }
                        
                        // 出せる時
                        if !playCards.isEmpty {
                            playCards.shuffle()
                            let random = Int.random(in: 0..<100)
                            if random < 80 {
                                guard judgeInGame() else {
                                    completion(false)
                                    return
                                }
                                log("\(Index): ④ 出せないので引く、出せるので出す", level: .debug)
                                // カードを出すまでに考える時間
                                DispatchQueue.main.asyncAfter(deadline: .now() + time03) { [self] in
                                    guard judgeInGame() else {
                                        completion(false)
                                        return
                                    }
                                    log("\( playCards.first!)")
                                    game.table.append(contentsOf: playCards.first!)
                                    game.players[Index].hand.removeAll(where: { playCards.first!.contains($0) })
                                    game.lastPlayerIndex = Index
                                    DispatchQueue.main.async { [self] in
                                        totable(card: playCards.first!)
                                        tohands(Index: Index)
                                    }
                                }
                                //　パスするまでの時間
                                DispatchQueue.main.asyncAfter(deadline: .now() + time04) { [self] in
                                    guard judgeInGame() else {
                                        completion(false)
                                        return
                                    }
                                    // 次のターンへ
                                    pass(Index: Index)
                                    completion(true)
                                }
                                
                            } else {
                                log("\(Index): ⑤ 出せないので引く、出せるけどパス", level: .debug)
                                //　パスするまでの時間
                                DispatchQueue.main.asyncAfter(deadline: .now() + time04) { [self] in
                                    guard judgeInGame() else {
                                        completion(false)
                                        return
                                    }
                                    // 次のターンへ
                                    pass(Index: Index)
                                    completion(true)
                                }
                            }
                            
                        } else {
                            log("\(Index): ⑥ 出せないので引く、出せないのでパス", level: .debug)
                            //　パスするまでの時間
                            DispatchQueue.main.asyncAfter(deadline: .now() + time04) { [self] in
                                guard judgeInGame() else {
                                    completion(false)
                                    return
                                }
                                // 次のターンへ
                                pass(Index: Index)
                                completion(true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 最初に出せるカード
    func BotInitCard(table: CardId, hand: [CardId]) -> [CardId] {
        let matchingCards = hand.filter { card in
            return card.suit() == table.suit() || card.number() == table.number()
        }
        return matchingCards
    }
    
    /**
     Botが最初のカードを出せるか調査
     */
    func BotGameInit() {
        // Botplayer
        var numbers = [1, 2, 3]
        numbers.shuffle()
        var shouldBreakLoop = false // 共有フラグ
        var time = 1 // 初期カード待ち時間
        for number in numbers {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                let player = game.players[number]
                // 出せるか判断
                guard let lastTableCard = game.table.last else {
                    log("BotGameInit No cards on the table.", level: .error)
                    return
                }
                
                var initCards = BotInitCard(table: game.table.last!, hand: player.hand)
                if !initCards.isEmpty {
                    initCards.shuffle()
                    if shouldBreakLoop || !(game.gamePhase == .gamefirst || game.gamePhase == .waiting) {
                        log("\(number): 誰かが出しました")
                        return
                    }
                    shouldBreakLoop = true
                    let card = initCards.first!
                    game.table.append(card)
                    player.hand.removeAll { $0 == card }
                    game.lastPlayerIndex = number
                    totable(card: card)
                    tohands(Index: number)
                    moveToMain(Index: number)
                } else {
                    log("\(number): 最初に出せるカードがないです")
                    game.firstAnswers[number] = .pass
                }
            }
            time += 1
        }
    }
    /**
     Botがどてんこできるか
     */
    func checkBotHand(Index: Int, player: Player_f) {
        
        if game.lastPlayerIndex == Index  {
            log("\(Index): 自分にはどてんこできません")
            return
        }
        
        // dtnkできるか
        let resultFirst = dtnkJudge(myside: Index, playerAllCards: player.hand, table: game.table)
        if resultFirst == Constants.dtnkCode && game.lastPlayerIndex != Index {
            // ランダムで数秒待ってどてんこ
            let random = Int.random(in: 0..<3)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(random)) { [self] in
                let resultSecond = dtnkJudge(myside: Index, playerAllCards: player.hand, table: game.table)
                if resultSecond  == Constants.dtnkCode && game.lastPlayerIndex != Index {
                    dtnk(Index: Index)
                    log("\(Index): dtnk")
                } else {
                    log("\(Index): やっぱりどてんこできません")
                    return
                }
            }
        } else {
            return
        }
    }
    
    //**********************************************************************************
    // GamePhase Event
    //**********************************************************************************
    /**
     Botがチャレンジするかどうか
     */
    func moveChallengeBot() {
        
        // 初期化
        game.challengeAnswers = Array(repeating: ChallengeAnswer.initial, count: 4)
        let table = game.table.last!
        // Botplayer
        let numbers = [1, 2, 3]
        
        // 各numberを1秒間隔で処理する
        for (index, number) in numbers.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) + 1) { [self] in
                var ans: ChallengeAnswer = .nochallenge
                
                if game.dtnkFlg[number] == 1 {
                    // dtnkしていればチャレンジ
                    ans = .challenge
                } else if number == game.dtnkPlayerIndex {
                    // dtnkerだったらチャレンジ必須
                    ans = .challenge
                } else {
                    // その他
                    let bot = game.players[number]
                    let botHand = calculatePossibleSums(cards: bot.hand)
                    for hand in botHand {
                        if hand == table.number() {
                            // どてんこ返し
                            self.revengeFirst(Index: number)
                            return
                        } else if hand < table.number() {
                            // チャレンジする
                            ans = .challenge
                        }
                    }
                }
                game.challengeAnswers[number] = ans
            }
        }
    }

    /**
     ゲーム中でなかったら処理しない
     */
    func judgeInGame() -> Bool {
        
        if game.gamePhase != .gamefirst_sub && game.gamePhase != .main {
            return false
        }
        return true
    }
    
    /**
     次のゲームへ
     */
    func moveNextGame() {
        
        if game.gameNum == game.gameTarget {
            Router().setBasePages(stack: [.gameresult])
        } else {
            game.gamePhase = .waiting
            let Item = GameResetItem()
            game.preparationNewGame(resetItem: Item) { [self] result in
                if result {
                    todeck(card: game.deck)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                game.gamePhase = .dealcard
            }
        }
    }
    
    //**********************************************************************************
    // Host Action
    //**********************************************************************************
    /**
     カードを配る
     */
    func dealCards(completion: @escaping (Bool) -> Void) {
        for j in 0..<game.players.count * 2 {
            let side = j % game.players.count
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(j) * 0.2)) { [self] in
                let drawnCard = game.deck.removeLast()
                game.players[side].hand.append(drawnCard)
                tohands(Index: side)
            }
        }
        completion(true)
    }
    
    /**
     最初のカードを配置する + 特定数字だったらレート上げる
     */
    func firstCard() {
        let drawnCard = game.deck.removeLast()
        game.table.append(drawnCard)
        totable(card: drawnCard)
        game.rateUpCard = nil
        if drawnCard.rate()[0] == 50 {
            game.rateUpCard = drawnCard.imageName()
            game.ascendingRate = game.ascendingRate * 2
        } else {
            game.gamePhase = .gamefirst
        }
    }

    // メインに向けた処理　いらんかも
    func moveToMain(Index: Int) {
        game.gamePhase = .main
        pass(Index: Index)
    }
    
    func endFlip() {
        // X秒後にratefirst
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            game.gamePhase = .main
        }
    }
    
    /**
     チャレンジ時のカード配布
     ・どてんこの次の順番のチャレンジャーからカードを引いてく
     */
    func challengeEvent() {
        // dtnkIndexを取得　2
        let dtnkIndex = game.dtnkPlayerIndex
        // 参加者を取得 [0,2,3]
        let challengeplayers = game.challengeAnswers.enumerated().compactMap { (index, value) -> Int? in
            return value.rawValue > 1 ? index : nil
        }
        // 初回0をSet
        if game.challengers == [] {
            // ChallengeFlgのSet(Overしたら1にする)[[0,0],[2,0],[3,0]]
            game.challengers = challengeplayers.map { [$0, 0] }
        }
        // 次のIndexを決める 3
        let nextChallenger = GameMainController().getNextChallenger(nowIndex: dtnkIndex, participants: game.challengers)
        let dtnkCardNumber = game.table.last?.number()
        // 手札とどてんこカードを比較して、行動する 3
        if let challenger = nextChallenger, let cardNumber = dtnkCardNumber {
            game.triggerAnnouncement(text: "\(game.players[challenger].name)\nのChallenge")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.challengeIndex(challengerIndex: challenger, dtnkCardNumber: cardNumber, dtnkIndex: dtnkIndex, challengers: challengeplayers)
            }
        } else {
            log("challengeEvent", level: .error)
        }
    }
        
    // 手札の合計を返す
    func countHand(hand: [CardId]) -> Int {
        var sum = 0
        for card in hand {
            sum += card.number()
        }
        return sum
    }
    
    // 最小の数字を返す
    func findSmallestNumber(numbers: [Int]) -> Int {
        guard let smallestNumber = numbers.min() else {
            return 0 // 配列が空の場合などに適切なデフォルト値を返す
        }
        return smallestNumber
    }
    
    // 指定したIndexがどてんこカードより大きくなるまで引く
    func challengeIndex(challengerIndex: Int, dtnkCardNumber: Int, dtnkIndex: Int, challengers: [Int]) {
        // 自分がdtnkIndexだったら終了
        if challengerIndex == dtnkIndex {
            log("end challengerIndex: \(challengerIndex)  dtnkIndex: \(dtnkIndex)")
            game.gamePhase = .endChallenge
            return
        }
        // 手札とどてんこカードを比較
        let challenger = appState.gameUIState.players[challengerIndex]
        // 手札がとりえる値
        let handSum = calculatePossibleSums(cards: challenger.hand)
        // 最小値
        let minimun = findSmallestNumber(numbers: handSum)
        
        // 返せるか検査
        for value in handSum {
            // 一つでも引っかかればどてんこ返し成功
            if value == dtnkCardNumber {
                // リベンジ処理
                log("どてんこ返し：\(challengerIndex) → \(dtnkIndex)")
                game.revengerIndex = challengerIndex
                // 手札処理
                DispatchQueue.main.async { [self] in
                    todeck(card: game.players[dtnkIndex].hand)
                    appState.gameUIState.players[dtnkIndex].hand.removeAll()
                    tohands(Index: dtnkIndex)
                }
                return
            }
        }
        
        // 終了(最小値がダメだった場合)
        if (minimun > dtnkCardNumber) {
            log("\(challengerIndex): のチャレンジ　　オーバーした")
            // Flg ON
            game.challengers = GameMainController().updateParticipantFlag(Index: challengerIndex, challengers: game.challengers)
            // overしたら次の人へ
            let nextChallenger = GameMainController().getNextChallenger(nowIndex: challengerIndex, participants: game.challengers)
            
            // 次がdtnkIndexだったら終了
            if nextChallenger == dtnkIndex {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                    game.gamePhase = .endChallenge
                }
                return
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                    log("next challenger")
                    log("\(nextChallenger!): のチャレンジ")
                    // nextChallengerAnnounce
                    game.triggerAnnouncement(text: "\(game.players[nextChallenger!].name)\nのChallenge")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                        // カードを引いた後の処理が終わったら再度challengeIndexを呼び出し
                        self.challengeIndex(challengerIndex: nextChallenger!, dtnkCardNumber: dtnkCardNumber, dtnkIndex: dtnkIndex, challengers: challengers)
                    }
                }
                return
            }
        }
        
        // 最小の方が小さい場合
        if (minimun < dtnkCardNumber) {
            log("\(challengerIndex): のチャレンジ　　可能性あるので引く")
            // チャンスあり 一枚引く
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                drawCard(Index: challengerIndex)
                // カードを引いた後の処理が終わったら再度challengeIndexを呼び出し
                self.challengeIndex(challengerIndex: challengerIndex, dtnkCardNumber: dtnkCardNumber, dtnkIndex: dtnkIndex, challengers: challengers)
                return
            }
        }
    }
    
    
    // どてんこ返し
    func revenge() {
        // 倍にして勝敗逆に
        let revengerdIndex = game.dtnkPlayerIndex
        game.ascendingRate += game.ascendingRate
        game.dtnkPlayerIndex = game.revengerIndex!
        game.dtnkPlayer = game.players[game.revengerIndex!]
        game.lastPlayerIndex = revengerdIndex
        // 空にする
        game.revengerIndex = nil
        challengeEvent()
    }
    
    /**
     最終画面に向けた準備
     */
    func preparationFinalPhase() {
        // 勝敗の決定
        decideWinnersLosers() { result in }
        // スコア決定
        decideScore() { result in }
        // スコア移動
        let rank = scoreCalculate()
        // FB登録
        let item = ResultItem(
            playersRank: rank,
            winners: game.winners,
            losers: game.losers,
            decisionScoreCards: game.decisionScoreCards,
            ascendingRate: game.ascendingRate,
            gameScore: game.gameScore)
        
        appState.subState = SubState(resultItem: item)
        // 順位格納
        for i in 0...3 {
            game.players[i].rank = item.playersRank[i]
        }
        game.gameScore = item.gameScore
        game.gamePhase = .decisionrate
    }
    
    /**
     勝敗を決める
     */
    func decideWinnersLosers(completion: @escaping (Bool) -> Void) {
        // 勝者・敗者の初期化
        game.winners.removeAll()
        game.losers.removeAll()
        // 勝者・敗者を決める
        if game.lastPlayerIndex == Constants.stnkCode {
            // しょてんこの場合
            let winner = game.players[game.dtnkPlayerIndex]
            game.winners.append(winner)
            let losers = game.players.enumerated().compactMap { index, player in
                index != game.dtnkPlayerIndex ? player : nil
            }
            game.losers.append(contentsOf: losers)

        } else if game.burstPlayerIndex != Constants.burstCode {
            // バーストの場合
            let winers = game.players.enumerated().compactMap { index, player in
                index != game.burstPlayerIndex ? player : nil
            }
            game.winners.append(contentsOf: winers)
            let loser = game.players[game.burstPlayerIndex]
            game.losers.append(loser)
            
        } else {
            // 通常時
            let winer = game.players[game.dtnkPlayerIndex]
            game.winners.append(winer)
            let loser = game.players[game.lastPlayerIndex]
            game.losers.append(loser)
        }
    }
    
    /**
     スコア決定の処理（裏のカードの確認）
     */
    func decideScore(completion: @escaping (Bool) -> Void) {
        // 山札の裏からカードを一枚引く
        var cards: [CardId] = []
        var keepDrawing = true
        
        while keepDrawing {
            if let card = game.deck.popLast() {
                cards.append(card)
                switch card.rate()[1] {
                // 黒３：勝敗逆転＋引く
                case 20:
                    let quick = game.winners
                    game.winners = game.losers
                    game.losers = quick
                    keepDrawing = true
                // ダイヤ３：３０
                case 30:
                    keepDrawing = false
                    // 1,2,jorker：倍＋引く
                case 50:
                    game.ascendingRate *= 2
                    keepDrawing = true
                    // その他普通の数字は終了
                default:
                    keepDrawing = false
                }
            }
        }
        game.decisionScoreCards = cards
        // score計算
        game.gameScore = game.initialRate * game.ascendingRate * (game.decisionScoreCards.last?.rate()[1])!
    }
    /**
     スコア移動
     */
    func scoreCalculate() -> [Int] {
        // Score移動
        for winner in game.winners {
            winner.score += game.gameScore * game.losers.count
        }
        for loser in game.losers {
            loser.score -= game.gameScore * game.winners.count
        }
        log("\(game.winners[0].score)")
        // rank計算
        return calculateRanks(players: game.players)
    }
    
    // 順位決定
    func calculateRanks(players: [Player_f]) -> [Int] {
        let sortedPlayers = players.sorted(by: { $0.score > $1.score })
        
        var ranks: [Int] = Array(repeating: 0, count: sortedPlayers.count)
        
        for (index, player) in sortedPlayers.enumerated() {
            if index == 0 {
                ranks[index] = 1
            } else if player.score == sortedPlayers[index - 1].score {
                ranks[index] = ranks[index - 1]
            } else {
                ranks[index] = index + 1
            }
        }
        // 元のplayersの順番で順位を抽出
        var orderedRanks: [Int] = []
        for player in players {
            if let index = sortedPlayers.firstIndex(where: { $0.id == player.id }) {
                orderedRanks.append(ranks[index])
            }
        }
        return orderedRanks
    }

    /**
     カードを再生成する
     */
    
    func regenerationDeck() {
        DispatchQueue.main.async { [self] in
            // アナウンス
            game.regenerationDeckFlg = 1
            //deckに戻す　一番上だけ残す
            if let lastCard = game.table.last {
                var remainingCards = Array(game.table.dropLast())
                remainingCards.shuffle()
                game.deck.append(contentsOf: remainingCards)
                game.table = [lastCard]
                // view
                todeck(card: game.deck)
                totable(card: game.table)
            } else {
                // エラーハンドリング、例えばエラーメッセージの表示など
                log("regenerationDeck ", level: .error)
            }
        }
    }

    //**********************************************************************************
    // Player Action
    //**********************************************************************************
    /**
     challengeするかしないかを報告
     */
    func moveChallenge(Index: Int, ans: ChallengeAnswer) {
        game.challengeAnswers[Index] = ans
    }

    /**
     どてんこできるか
     手札合計が一致していればどてんこ可能
     自分が出したカードに対してだったらリベンジ可能
     ？？？だったらしょてんこ可能
     */
    func dtnkJudge(myside: Int, playerAllCards: [CardId], table: [CardId]) -> Int {
        var dtnkjudge = false
        var result = Constants.ngCode
        
        // tableが空だったらだめ
        if table.isEmpty {
            return result
        }
        // 手札がとりえる値
        let possibleSum = calculatePossibleSums(cards: playerAllCards)
        for sum in possibleSum {
            if sum == table.last!.number() {
                dtnkjudge = true
            }
        }
        // どてんこできない
        if !dtnkjudge {
            return result
        }
        // 自分にはどてんこできない
        if game.gamePhase != .q_challenge && game.lastPlayerIndex == myside {
            return result
        }
        // しょてんこ可能として返す
        if game.lastPlayerIndex == Constants.stnkCode {
            return Constants.stnkCode
        }
        // 通常どてんこ可能として返す
        result = Constants.dtnkCode

        return result
    }
    
    /**
     カードを出す
     */
    func playCards(Index: Int, cards: [CardId], completion: @escaping (Bool, String?) -> Void) {
        log("card: \(cards)", level: .info)
        let cardsToPlay = cards
        
        if game.table.isEmpty {
            completion(false, "テーブルが空です")
            return
        }
        if cardsToPlay.isEmpty {
            completion(false, "カードを選択してください")
            return
        }
        if game.currentPlayerIndex != Index && game.currentPlayerIndex != 99 {
            completion(false, "あなたのターンではないです")
            return
        }
        if game.gamePhase == .ratefirst {
            completion(false, "初期配置中です")
            return
        }
        
        if checkMultipleCards(table: game.table.last!, playCard: cards) {
            if game.gamePhase != .main {
                game.gamePhase = .main
            }
            game.table.append(contentsOf: cards)
            game.players[Index].hand.removeAll(where: { cardsToPlay.contains($0) })
            game.lastPlayerIndex = Index
            totable(card: cards)
            tohands(Index: Index)
            game.players[Index].selectedCards = []
        } else {
            completion(false, "それらのカードは出せないです")
            return
        }
        // 次への処理
        pass(Index: Index)
        completion(true, nil)
    }
    
    /**
     カードを引く 判定入れるために分割
     */
    func playerDrawCard(Index: Int) {
        if !((game.gamePhase == .gamefirst_sub || game.gamePhase == .main) && game.currentPlayerIndex == Index) {
            log("\(Index): あなたのターンではないです")
            return
        }
        drawCard(Index: Index)
    }
    
    func drawCard(Index: Int) {
        if Index == game.myside {
            game.turnFlg = 1
        }
        
        if let drawnCard = game.deck.popLast() {
            game.players[Index].hand.append(drawnCard)
            tohands(Index: Index)
            // deck再生成
            if game.deck.count < 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                    regenerationDeck()
                }
            }

        } else {
            log("drawCard Can't remove last element from an empty collection", level: .error)
        }
    }
    
    
    /*
     パスする
     */
    func initPass(Index: Int) {
        // 初期フェーズの時(一致番最初)
        if game.firstAnswers[Index] == .initial && game.gamePhase == .gamefirst {
            game.gamePhase = .waiting
            game.firstAnswers[Index] = .pass
            return;
        } else {
            log("")
        }
    }
    
    func pass(Index: Int) {
        // 通常時
        if game.players[Index].hand.count < Constants.burstCount {
            game.currentPlayerIndex = (Index + 1) % game.players.count
            if Index == game.myside {
                game.turnFlg = 0
            }
        }
        // Burstするとき
        if (game.gamePhase == .gamefirst_sub || game.gamePhase == .main) && game.players[Index].hand.count == Constants.burstCount {
            game.gamePhase = .burst
            game.burstPlayer = game.players[Index]
            game.burstPlayerIndex = Index
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { [self] in
                game.gamePhase = .decisionrate_pre
            }
        }
    }
    
    /**
     どてんこ
     */
    func playerDtnk(Index: Int) {
        if !( game.gamePhase == .gamefirst || game.gamePhase == .gamefirst_sub || game.gamePhase == .main) {
            log("\(Index): まだどてんこできないです")
            return
        }
        dtnk(Index: Index)
    }
    
    func dtnk(Index: Int) {
        // dtnk/即時返しは１ゲーム１人１回
        if game.dtnkFlg[Index] != 1 {
            // Vib & SE
            SoundMng.shared.dtnkSound()

            DispatchQueue.main.async { [self] in
                game.gamePhase = .dtnk
                game.dtnkFlg[Index] = 1
                // 処理
                game.dtnkPlayerIndex = Index
                game.dtnkPlayer = game.players[Index]
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    DispatchQueue.main.async { [self] in
                        game.gamePhase = .q_challenge
                    }
                }
            }
        } else {
            log("\(Index): どてんこ済みです")
        }
    }
    
    
    // TODO: 下記２種リファクタリング
    // どてんこ返し in main
    func revengeFirst(Index: Int) {
        // dtnk/即時返しは１ゲーム１人１回
        if game.dtnkFlg[Index] != 1 {
            game.dtnkFlg[Index] = 1
            log("\(Index): どてんこ返し")
            // Vib & SE
            SoundMng.shared.playSound(soundName: SoundName.SE.revengeInMain.rawValue)
            game.gamePhase = .revengeInMain
            
            // やられた人の手札リセット
            todeck(card: game.players[game.dtnkPlayerIndex].hand)
            appState.gameUIState.players[game.dtnkPlayerIndex].hand.removeAll()
            tohands(Index: game.dtnkPlayerIndex)
            
            // 入れ替え
            let quickIndex = game.dtnkPlayerIndex
            _ = game.dtnkPlayer
            game.lastPlayerIndex = quickIndex
            game.dtnkPlayerIndex = Index
            game.dtnkPlayer = game.players[Index]
            game.ascendingRate = game.ascendingRate * 2
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [self] in
                game.gamePhase = .q_challenge
            }
        } else {
            log("\(Index): どてんこ済みです")
        }
    }

    // どてんこ返し in challenge
    func revenge(Index: Int) {
        // Vib & SE
        game.gamePhase = .revengeInChallenge
        // 入れ替え
        let quickIndex = game.dtnkPlayerIndex
        _ = game.dtnkPlayer
        game.lastPlayerIndex = quickIndex
        game.dtnkPlayerIndex = Index
        game.dtnkPlayer = game.players[Index]
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
            game.gamePhase = .q_challenge
        }
    }

    //**********************************************************************************
    // Card Check
    //**********************************************************************************

    // 手札の全ての組み合わせを返す
    func generateAllCombinations(cards: [CardId]) -> [[CardId]] {
        guard !cards.isEmpty else { return [[]] }
        
        var result: [[CardId]] = []
        
        let first = cards.first!
        let subArray = Array(cards.dropFirst())
        
        let withoutFirst = generateAllCombinations(cards: subArray)
        let withFirst = withoutFirst.map { [first] + $0 }
        
        result += withFirst + withoutFirst
        
        return result
    }
    
    // 複数出す場合の先頭がテーブルと一致しているか
    func checkTopCard(table: CardId, playCard: CardId) -> Bool {
        // 同じ数字　同じスート　どちらかがJorker
        return playCard.number() == table.number() || playCard.suit() == table.suit() || playCard.suit() == .all || table.suit() == .all
    }
    
    // カードが出せるか：単品
    func checkSingleCard(table: CardId, playCard: CardId) -> Bool {
        // 同じ数字　同じスート　どちらかがJorker
        return playCard.number() == table.number() || playCard.suit() == table.suit() || table.suit() == .all
    }
    
    // カードが出せるか：複数
    func checkMultipleCards(table: CardId, playCard: [CardId]) -> Bool {
        // 合計が一緒
        var sum: Bool = false
        let sumResult = calculatePossibleSums(cards: playCard)
        for sumdata in sumResult {
            if sumdata == table.number() {
                sum = true
            }
        }
        var single: Bool = false
        var same: Bool = false
        if playCard.count == 1 {
            // if single
            single = checkSingleCard(table: table, playCard: playCard.first!)
            
        } else {
            // 手札が全部同じ数字かどうか
            let sameResult = areAllCardIdsTheSame(cards: playCard)
            // テーブルと同じ数字または同じスート
            if sameResult {
                same = checkTopCard(table: table, playCard: playCard.first!)
            }
        }
        
        return sum || same || single
    }
    
    // 手札の合計計算 [[2] [3] [-1 0 1]]  ->  [4 5 6]
    func calculatePossibleSums(cards: [CardId]) -> [Int] {
        var sums: Set<Int> = [0] // 初期値
        for card in cards {
            var newSums: Set<Int> = []
            
            for cardValue in card.value() {
                for sum in sums {
                    newSums.insert(sum + cardValue)
                }
            }
            sums = newSums
        }
        return Array(sums).sorted()
    }

    // カードが全て同じカードかどうか
    func areAllCardIdsTheSame(cards: [CardId]) -> Bool {
        // 空の配列はfalseとする
        guard !cards.isEmpty else { return false }
        // Jorkerでない数字要素取得
        let firstNonZeroIndex = cards.firstIndex(where: { $0.number() != 100 }) ?? 0
        // Jorkerでない数字と他の手札が一致するか
        let firstValue = cards[firstNonZeroIndex].number()
        // 先頭がJorkerではない
        for card in cards {
            if card.number() != firstValue && card.suit() != .all {
                return false
            }
        }
        return true
    }
    
    //**********************************************************************************
    // Card Animation
    //**********************************************************************************
    
    func todeck(card: [CardId]) {
        DispatchQueue.main.async { [self] in
            for carddata in card {
                if let index = game.cardUI.firstIndex(where: { $0.id.rawValue == carddata.id }) {
                    var newCard = game.cardUI.remove(at: index)
                    newCard.location = .deck
                    game.cardUI.append(newCard)
                }
            }
        }
    }

    func totable(card: CardId) {
        DispatchQueue.main.async { [self] in
            if let index = game.cardUI.firstIndex(where: { $0.id.rawValue == card.id }) {
                var newCard = game.cardUI.remove(at: index)
                newCard.location = .table
                game.cardUI.append(newCard)
            }
        }
    }
    

    func totable(card: [CardId]) {
        DispatchQueue.main.async { [self] in
            for carddata in card {
                if let index = game.cardUI.firstIndex(where: { $0.id.rawValue == carddata.id }) {
                    var newCard = game.cardUI.remove(at: index)
                    newCard.location = .table
                    game.cardUI.append(newCard)
                }
            }
        }
    }
    
    func tohands(Index: Int) {
        DispatchQueue.main.async { [self] in
        let hand = game.players[Index].hand
        var i = 0
            for newhandcard in hand {
                if let index = game.cardUI.firstIndex(where: { $0.id.rawValue == newhandcard.id }) {
                    var newCard = game.cardUI.remove(at: index)
                    newCard.location = .hand(playerIndex: Index, cardIndex: i)
                    i += 1;
                    game.cardUI.append(newCard)
                }
            }
        }
    }
}
