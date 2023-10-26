/**
 Hostのみが行う処理を記載
 */

import Foundation
import SwiftUI
import Firebase
import FirebaseDatabase

class GameObserber {
    
    var game: GameUIState = appState.gameUIState
    let fbm = FirebaseManager()
    let fbms = FirebaseManager.shared
    var hostID: String = ""
    
    // 初期化時にホストIDをセットします
    init(hostID: String) {
        self.hostID = hostID
    }
    
    /**
     自分がHostかチェックする
     */
    func checkHost() -> Bool {
        guard let currentUserId = Auth.auth().currentUser?.uid, currentUserId == hostID else {
            log("You're not authorized to use this method!")
            return false
        }
        return true
    }
    
    /**
     初期カード配布
     */
    func dealFirst(players: [Player_f], completion: @escaping (Bool) -> Void) {
        guard checkHost() else {
            return
        }
        dealToPlayers(players: players, index: 0, completion: completion)
    }
    
    private func dealToPlayers(players: [Player_f], index: Int, completion: @escaping (Bool) -> Void) {
        // All players dealt with, return true
        if index >= players.count {
            completion(true)
            return
        }
        
        let player = players[index]
        
        // Deal 2 cards
        dealCards(player: player, remaining: 2) { (success) in
            if success {
                // After the current player is done, deal to the next player
                self.dealToPlayers(players: players, index: index + 1, completion: completion)
            } else {
                // If there was an error dealing cards, call completion with false
                completion(false)
            }
        }
    }
    
    private func dealCards(player: Player_f, remaining: Int, completion: @escaping (Bool) -> Void) {
        // If no more cards to deal, return true
        if remaining <= 0 {
            completion(true)
            return
        }
        
        fbms.drawCard(playerID: player.id) { bool in
            if bool {
                // Once drawCard is done, deal the next card
                self.dealCards(player: player, remaining: remaining - 1, completion: completion)
            } else {
                // If there was an error in drawCard, call completion with false
                completion(false)
            }
        }
    }
    
    /**
     初期カードめくり
     */
    func firstCard() {
        guard checkHost() else {
            return
        }
        fbms.moveTopCardToTable() { [self] cardInt in
            if let cardId = CardId(rawValue: cardInt!) {
                // レートカードの場合
                if cardId.rate()[0] == 50 {
                    // アナウンス処理
                    let rateUpCard = cardId.imageName()
                    fbms.setRateUpCard(rateUpCard: rateUpCard) { resut in }
                } else {
                    //　決定されたらgamefirstに
                    game.gamePhase = .gamefirst
                    fbms.setGamePhase(gamePhase: .gamefirst) { result in }
                }
            } else {
            }
        }
    }
    
    /**
     チャレンジ時のカード配布
     ・どてんこの次の順番のチャレンジャーからカードを引いてく
     */
    func challengeEvent() {
        guard checkHost() else {
            return
        }
        // dtnkIndexを取得　2
        let dtnkIndex = game.dtnkPlayerIndex
        // 参加者を取得 [0,2,3]
        let challengeplayers = game.challengeAnswers.enumerated().compactMap { (index, value) -> Int? in
            return value.rawValue > 1 ? index : nil
        }
        log("Challenge参加者：　\(challengeplayers)")
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
        log("\(challengerIndex) のチャレンジです")
        // 自分がdtnkIndexだったら終了
        if challengerIndex == dtnkIndex {
            log("end challengerIndex: \(challengerIndex)  dtnkIndex: \(dtnkIndex)")
            fbms.setGamePhase(gamePhase: .decisionrate_pre) { result in }
            return
        }
        // 手札とどてんこカードを比較
        let challenger = appState.gameUIState.players[challengerIndex]
        _ = countHand(hand: challenger.hand)
        // 手札がとりえる値
        let handSumPos = GameBotController().calculatePossibleSums(cards: challenger.hand)
        // 最小値
        let minimun = GameBotController().findSmallestNumber(numbers: handSumPos)

        log("手札：\(challenger)　手札合計： \(handSumPos)")
        
        // 返せるか検査
        for sumdata in handSumPos {
            if sumdata == dtnkCardNumber {
                // リベンジ処理
                log("どてんこ返し：\(challengerIndex) → \(dtnkIndex)")
                // 処理 手札リセット
                fbms.resetHands(playerIndex: game.dtnkPlayerIndex,
                                playerID: game.players[game.dtnkPlayerIndex].id,
                                baseselectedCards: game.players[game.dtnkPlayerIndex].hand) { result in
                }
                // rate up
                let ascendingRate = game.ascendingRate * 2
                fbms.setAscendingRate(ascendingRate: ascendingRate) { result in }
                // 次の人へ
                let nextChallenger = getNextChallenger(nowIndex: challengerIndex, players: challengers)
                // dtnkIndexをrevengerに変更
                fbms.setDTNKInfo(Index: challengerIndex, dtnkPlayer: challenger) { result in }
                let revengerIndex = challengerIndex
                self.challengeIndex(challengerIndex: nextChallenger!, dtnkCardNumber: dtnkCardNumber, dtnkIndex: revengerIndex, challengers: challengers)
                return
            }
        }
        
        // 終了(最小値がダメだった場合) 次の人へ
        if (minimun > dtnkCardNumber) {
            // overしたら次の人へ
            let nextChallenger = getNextChallenger(nowIndex: challengerIndex, players: challengers)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                log("end:\(challengerIndex)  next challenger")
                // カードを引いた後の処理が終わったら再度challengeIndexを呼び出し
                self.challengeIndex(challengerIndex: nextChallenger!, dtnkCardNumber: dtnkCardNumber, dtnkIndex: dtnkIndex, challengers: challengers)
            }
            return
        }
        
        // 最小の方が小さい場合
        if (minimun < dtnkCardNumber) {
            // チャンスあり 一枚引く
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                fbms.drawCard(playerID: challenger.id) { result in
                    log("challenger \(challenger.side-1) draw")
                    // カードを引いた後の処理が終わったら再度challengeIndexを呼び出し
                    self.challengeIndex(challengerIndex: challengerIndex, dtnkCardNumber: dtnkCardNumber, dtnkIndex: dtnkIndex, challengers: challengers)
                }
            }
        }
    }
    
    /**
     誰も出せなかった場合
     */
    func firstAnswers() {
        guard checkHost() else {
            return
        }
        // TODO: ランダムにしたい
        // Hostから始める
        let index = GameCommonFunctions().findSideById(players: game.players, id: hostID)
        
        fbms.setCurrentPlayerIndex(currentplayerIndex: index! - 1) { [self] result in
            if result {
                // mainに移る
                fbms.setGamePhase(gamePhase: .main) { result in }
            }
        }
    }
    
    /**
     challengeAnswersが揃ったらchallengeに移す
     */
    func challengeAnswers() {
        guard checkHost() else {
            return
        }
        print("act")
        // challengeに移す
        fbms.setGamePhase(gamePhase: .challenge) { result in }
    }
    /**
     nextGameAnnounceが揃ったら次のゲームへ
     */
    func nextGameAnnounce() {
        guard checkHost() else {
            return
        }
        // 事前処理
        for player in game.players {
            game.deck.append(contentsOf: player.hand)
            player.hand.removeAll()
        }
        game.deck.append(contentsOf: game.table)
        game.table.removeAll()
        
        let Item = GameResetItem()
        fbms.resetGame(item: Item) { result in }
    }
    
    /**
     デッキの再生成
     */
    func regenerateDeck(table: [CardId]) {
        guard checkHost() else {
            return
        }
        var table = table
        let newDeck = Array(table.prefix(table.count - 1)).shuffled()
        table.removeSubrange(0..<table.count - 1) // tableの最後のカード以外を削除
        let newTable = table
        // deck更新
        fbms.setDeck(deck: newDeck) { result in }
        // table
        fbms.setTable(table: newTable) { result in }
    }
    
    /**
     最終画面に向けた準備
     */
    func preparationFinalPhase() {
        guard checkHost() else {
            return
        }
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
        
        fbms.setPrepareFinalPhase(item: item) { [self] result in
            if result {
                fbms.setGamePhase(gamePhase: .decisionrate) { result in }
            }
        }
        
    }
    
    /**
     勝敗を決める
     */
    func decideWinnersLosers(completion: @escaping (Bool) -> Void) {
        guard checkHost() else {
            return
        }
        // 勝者・敗者の初期化
        game.winners.removeAll()
        game.losers.removeAll()
        // 勝者・敗者を決める
        if game.currentPlayerIndex == Constants.stnkCode || game.lastPlayerIndex == Constants.stnkCode {
            // しょてんこの場合
            let winner = game.players[game.dtnkPlayerIndex]
            game.winners.append(winner)
            let losers = game.players.enumerated().compactMap { index, player in
                index != game.dtnkPlayerIndex ? player : nil
            }
            game.losers.append(contentsOf: losers)
            
        } else if game.burstPlayerIndex != Constants.burstCode  {
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
        guard checkHost() else {
            return
        }
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
    
    // ゲームデータ削除
    func deleteGamedata(completion: @escaping (Bool) -> Void) {
        guard checkHost() else {
            return
        }
        fbms.deleteGamedata(roomID: appState.room.roomData.roomID) { result in
            if result {
                completion(true)
            }
        }
    }
}
