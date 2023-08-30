/**
 vsBotの関数
 
 */

import SwiftUI

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
        
        var time = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
            // 出せる時
            if !playCards.isEmpty {
                playCards.shuffle()
                let random = Int.random(in: 0..<100)
                
                if random < 70  {
                    log("\(Index): ① 出せるからすぐ出す")
                    // ① 出せるからすぐ出す
                    game.table.append(contentsOf: playCards.first!)
                    game.players[Index].hand.removeAll(where: { playCards.first!.contains($0)})
                    game.lastPlayerIndex = Index
                    totable(card: playCards.first!)
                    tohands(Index: Index)
                    time += Int(0.3)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                        // 次のターンへ
                        pass(Index: Index)
                        completion(true)
                    }
                } else if random < 90 {
                    log("\(Index): ② 出せるけど引いて出す")

                    time += 1
                    // ② 出せるけど引いて出す
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                        drawCard(Index: Index)
                    }
                    time += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                        game.table.append(contentsOf: playCards.first!)
                        game.players[Index].hand.removeAll(where: { playCards.first!.contains($0) })
                        game.lastPlayerIndex = Index
                        totable(card: playCards.first!)
                        tohands(Index: Index)
                    }
                    time += Int(0.3)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                        // 次のターンへ
                        pass(Index: Index)
                        completion(true)
                    }

                    
                } else {
                    log("\(Index): ③ 出せるけど引くそして出さない")
                    // ③ 出せるけど引くそして出さない
                    time += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                        drawCard(Index: Index)
                    }
                    time += Int(0.3)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                        // 次のターンへ
                        pass(Index: Index)
                        completion(true)
                    }
                }
                
            } else {
                // 出せない時
                time += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
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
                            // ④ 出せないので引く、出せるので出す
                            log("\(Index): ④ 出せないので引く、出せるので出す")
                            time += 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                                game.table.append(contentsOf: playCards.first!)
                                game.players[Index].hand.removeAll(where: { playCards.first!.contains($0) })
                                game.lastPlayerIndex = Index
                                totable(card: playCards.first!)
                                tohands(Index: Index)
                            }
                            time += Int(0.3)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                                // 次のターンへ
                                pass(Index: Index)
                                completion(true)
                            }

                            
                        } else {
                            // ⑤ 出せないので引く、出せるけどパス
                            log("\(Index): ⑤ 出せないので引く、出せるけどパス")
                            time += Int(0.3)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                                // 次のターンへ
                                pass(Index: Index)
                                completion(true)
                            }
                        }
                        
                    } else {
                        // ⑥ 出せないので引く、出せないのでパス
                        log("\(Index): ⑥ 出せないので引く、出せないのでパス")
                        time += Int(0.3)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                            // 次のターンへ
                            pass(Index: Index)
                            completion(true)
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
                game.firstAnswers[number] = .pass

//                // 出せるか判断
//                var initCards = BotInitCard(table: game.table.last!, hand: player.hand)
//                if !initCards.isEmpty {
//                    initCards.shuffle()
//                    if shouldBreakLoop || !(game.gamePhase == .gamefirst) {
//                        log("\(number): 誰かが出しました")
//                        return
//                    }
//                    let card = initCards.first!
//                    game.table.append(card)
//                    player.hand.removeAll { $0 == card }
//                    game.lastPlayerIndex = number
//                    totable(card: card)
//                    tohands(Index: number)
//                    shouldBreakLoop = true
//                    moveToMain(Index: number)
//                } else {
//                    log("\(number): 最初に出せるカードがないです")
//                    game.firstAnswers[number] = .pass
//                }
            }
            time += 1
        }
    }
    /**
     Botがどてんこできるか
     */
    func checkBotHand(Index: Int, player: Player_f) {
        // dtnkできるか
        let resultFirst = dtnkJudge(myside: Index, playerAllCards: player.hand, table: game.table)
        if resultFirst == Constants.dtnkCode {
            // ランダムで数秒待ってどてんこ
            let random = Int.random(in: 0..<5)
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(random)) { [self] in
                let resultSecond = dtnkJudge(myside: Index, playerAllCards: player.hand, table: game.table)
                if resultSecond  == Constants.dtnkCode {
                    // TODO: Bot Dtnk
                    dtnk(Index: Index)
                    log("\(player.name) dtnk")
                } else {
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
        let table = game.table.last!
        // Botplayer
        let numbers = [1, 2, 3]
        var ans: ChallengeAnswer = .nochallenge
        
        for number in numbers {
            let bot = game.players[number]
            let botHand = calculatePossibleSums(cards: bot.hand)
            for hand in botHand {
                if hand < table.number() {
                    ans = .challenge
                }
            }
            game.challengeAnswers[number] = ans
        }
    }
    
    /**
     次のゲームへ
     */
    func moveNextGame() {
        let Item = GameResetItem()
        game.preparationNewGame(resetItem: Item) { [self] result in
            if result {
                todeck(card: game.deck)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            game.gamePhase = .dealcard
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
        print(appState.gameUIState.deck.count)
        let drawnCard = game.deck.removeLast()
        game.table.append(drawnCard)
        totable(card: drawnCard)
        game.rateUpCard = nil
        if drawnCard.rate()[0] == 50 {
            game.rateUpCard = drawnCard.imageName()
            //TODO: レートあげる
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
        // 次のIndexを決める 3
        let nextChallenger = getNextChallenger(nowIndex: dtnkIndex, players: challengeplayers)
        let dtnkCardNumber = game.table.last?.number()
        // 手札とどてんこカードを比較して、行動する 3
        challengeIndex(challengerIndex: nextChallenger!, dtnkCardNumber: dtnkCardNumber!, dtnkIndex: dtnkIndex, challengers: challengeplayers)
    }
    
    // 次のプレイヤーを返す
    func getNextChallenger(nowIndex: Int, players: [Int]) -> Int? {
        // targetのインデックスを見つけます。
        guard let targetIndex = players.firstIndex(of: nowIndex) else {
            return nil
        }
        // 次のインデックスを計算します。
        let nextIndex = (targetIndex + 1) % players.count
        // 新しいインデックスのプレイヤーを返します。
        return players[nextIndex]
    }
    
    // 手札の合計を返す
    func countHand(hand: [CardId]) -> Int {
        var sum = 0
        for card in hand {
            sum += card.number()
        }
        return sum
    }
    
    // 指定したIndexがどてんこカードより大きくなるまで引く
    func challengeIndex(challengerIndex: Int, dtnkCardNumber: Int, dtnkIndex: Int, challengers: [Int]) {
        // 自分がdtnkIndexだったら終了
        if challengerIndex == dtnkIndex {
            print("end challengerIndex: \(challengerIndex)  dtnkIndex: \(dtnkIndex)")
            game.gamePhase = .decisionrate_pre
            return
        }
        // 手札とどてんこカードを比較
        let challenger = appState.gameUIState.players[challengerIndex]
        let handSum = countHand(hand: challenger.hand)
        
        // TODO: jokerを考慮させる
        // チャンスがあれば引く
        if (dtnkCardNumber - handSum) > 0 {
            // チャンスあり 一枚引く
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                drawCard(Index: challengerIndex)
                // カードを引いた後の処理が終わったら再度challengeIndexを呼び出し
                self.challengeIndex(challengerIndex: challengerIndex, dtnkCardNumber: dtnkCardNumber, dtnkIndex: dtnkIndex, challengers: challengers)
            }
            // loop
        } else if (dtnkCardNumber - handSum) == 0 {
            // リベンジ成功 animation
            print("revenge")
            // 処理
            appState.gameUIState.players[dtnkIndex].hand.removeAll()
            // Viewも

            // 次の人へ
            let nextChallenger = getNextChallenger(nowIndex: challengerIndex, players: challengers)
//            print("\(nextChallenger!) : \(dtnkCardNumber) : \(challengerIndex) : \(challengers)")
            // dtnkIndexをrevengerに変更
            let revengerIndex = challengerIndex
            self.challengeIndex(challengerIndex: nextChallenger!, dtnkCardNumber: dtnkCardNumber, dtnkIndex: revengerIndex, challengers: challengers)
            return

        } else {
            // overしたら次の人へ
            let nextChallenger = getNextChallenger(nowIndex: challengerIndex, players: challengers)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                print("next challenger")
                // カードを引いた後の処理が終わったら再度challengeIndexを呼び出し
                self.challengeIndex(challengerIndex: nextChallenger!, dtnkCardNumber: dtnkCardNumber, dtnkIndex: dtnkIndex, challengers: challengers)
            }
            return
        }
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
        if game.currentPlayerIndex == 99 {
            // しょてんこの場合

        } else if game.burstPlayerIndex != -1 {
            // バーストの場合
            
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
        //deckに戻す　一番上だけ残す
        let lastCard = game.table.last!
        var remainingCards = Array(game.table.dropLast())
        remainingCards.shuffle()
        game.deck.append(contentsOf: remainingCards)
        game.table = [lastCard]
        
        // view
        todeck(card: game.deck)
        totable(card: game.table)
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
        
        // 自分にはどてんこできない　：リベンジ可能として出す？
        if game.lastPlayerIndex == myside {
            return result
        }
        // しょてんこ可能として返す
        if game.currentPlayerIndex == Constants.stnkCode {
            return Constants.stnkCode
        }

        // 通常どてんこ可能として返す
        result = Constants.dtnkCode

        return result
    }
    
    /**
     カードを出す
     */
    func playCards(Index: Int, cards: [CardId]) {
        let cardsToPlay = cards
        
        if game.table.isEmpty {
            log("テーブルが空です")
            return
        }
        if cardsToPlay.isEmpty {
            log("\(Index): カードを選択してください")
            return
        }
        if game.currentPlayerIndex != Index && game.currentPlayerIndex != 99 {
            log("\(Index): あなたのターンではないです")
            return
        }
        if checkMultipleCards(table: game.table.last!, playCard: cards) {
            game.table.append(contentsOf: cards)
            game.players[Index].hand.removeAll(where: { cardsToPlay.contains($0) })
            game.lastPlayerIndex = Index
            totable(card: cards)
            tohands(Index: Index)
            game.players[Index].selectedCards = []
        } else {
            log("\(Index): それらのカードは出せないです")
            return
        }
        // 次への処理
        pass(Index: Index)
    }
    
    /**
     カードを引く 判定入れるために分割
     */
    func playerDrawCard(Index: Int) {
        if !(game.gamePhase == .main && game.currentPlayerIndex == Index) {
            log("\(Index): あなたのターンではないです")
            return
        }
        drawCard(Index: Index)
    }
    
    func drawCard(Index: Int) {
        if Index == game.myside {
            game.turnFlg = 1
        }
        let drawnCard = game.deck.removeLast()
        game.players[Index].hand.append(drawnCard)
        tohands(Index: Index)
        // deck再生成
        if game.deck.count < 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                regenerationDeck()
            }
        }
    }
    
    /*
     パスする
     */
    func pass(Index: Int) {
        game.gamePhase = .main
        
        if game.players[Index].hand.count < Constants.burstCount {
            game.currentPlayerIndex = (Index + 1) % game.players.count
            
            if Index == game.myside {
                game.turnFlg = 0
            }
            
        } else {
            // Burstするとき
            game.gamePhase = .burst
            game.burstPlayer = game.players[Index]
            game.burstPlayerIndex = Index
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 ) { [self] in
                game.gamePhase = .decisionrate_pre
            }
        }
    }
    
    /**
     どてんこ
     */
    func dtnk(Index: Int) {
        // バイブ　音声
        game.gamePhase = .dtnk
        // 処理
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
    
    // カードが出せるか：単体
    func checkSingleCard(table: CardId, playCard: CardId) -> Bool {
        
        return playCard.number() == table.number() || playCard.suit() == table.suit() || playCard.suit() == .all
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
        // テーブルと全部同じ数字
        var same: Bool = false
        let sameResult = areAllCardIdsTheSame(cards: playCard)
        if sameResult {
            same = checkSingleCard(table: table, playCard: playCard.first!)
        }
        return sum || same
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
        return Array(sums).sorted().filter { $0 < 13 }
    }

    // カードが全て同じカードかどうか
    func areAllCardIdsTheSame(cards: [CardId]) -> Bool {
        guard !cards.isEmpty else { return false }  // 空の配列はfalseとする
        let firstValue = cards[0].number()
        
        for card in cards {
            if card.number() != firstValue && card.suit() == .all {
                return false
            }
        }
        return true
    }
    
    //**********************************************************************************
    // Card Animation
    //**********************************************************************************
    
    func todeck(card: [CardId]) {
        for carddata in card {
            if let index = game.cardUI.firstIndex(where: { $0.id.rawValue == carddata.id }) {
                var newCard = game.cardUI.remove(at: index)
                newCard.location = .deck
                game.cardUI.append(newCard)
            }
        }
    }
    
    func totable(card: CardId) {
        if let index = game.cardUI.firstIndex(where: { $0.id.rawValue == card.id }) {
            var newCard = game.cardUI.remove(at: index)
            newCard.location = .table
            game.cardUI.append(newCard)
        }
    }

    func totable(card: [CardId]) {
        for carddata in card {
            if let index = game.cardUI.firstIndex(where: { $0.id.rawValue == carddata.id }) {
                var newCard = game.cardUI.remove(at: index)
                newCard.location = .table
                game.cardUI.append(newCard)
            }
        }
    }
    
    func tohands(Index: Int) {
        let hand = game.players[Index].hand
        var i = 0
        for newhandcard in hand {
            // まず新しい手札を配列から見つけ出し
            if let index = game.cardUI.firstIndex(where: { $0.id.rawValue == newhandcard.id }) {
                var newCard = game.cardUI.remove(at: index)
                // 新しい位置を設定
                newCard.location = .hand(playerIndex: Index, cardIndex: i)
                i += 1;
                // 新しい手札を一番最後に追加
                game.cardUI.append(newCard)
            }
        }
    }
}

// TODO: 問題なくなったら消す
struct GameMainController {
    
//**********************************************************************************
// GamePhase Event
//**********************************************************************************

    /**
     チャレンジモードへ
     */
    func moveChallengeEvent(challengeFlag: [Int]) -> GamePhase? {
        var gamePhase: GamePhase = .challenge
        // チャレンジするかしないか、全員が判断したら
        let compCallenge = challengeFlag.allSatisfy { $0 > 0 }
        if compCallenge {
            // TODO: 現状全パターンチャレンジへ行く　Flg値・ロジック変更必要？
            //　一人もチャレンジしない場合、結果画面へ
            let check = challengeFlag.allSatisfy { $0 == 2 }
            if check {
                gamePhase = .decisionrate_pre
            }
            // チャレンジャーがいる場合移動
            else {
                gamePhase = .challenge
            }
            return gamePhase
        }
        return nil
    }
}

