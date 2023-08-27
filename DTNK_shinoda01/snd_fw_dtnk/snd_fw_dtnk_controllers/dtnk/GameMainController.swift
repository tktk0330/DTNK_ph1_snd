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
                    print("① 出せるからすぐ出す")
                    // ① 出せるからすぐ出す
                    game.table.append(contentsOf: playCards.first!)
                    game.players[Index].hand.removeAll(where: { playCards.first!.contains($0) })
                    totable(card: playCards.first!)
                    tohands(Index: Index)
                    time += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                        // 次のターンへ
                        pass(Index: Index)
                        completion(true)
                    }
                } else if random < 90 {
                    print("② 出せるけど引いて出す")

                    time += 1
                    // ② 出せるけど引いて出す
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                        drawCard(Index: Index)
                    }
                    time += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                        game.table.append(contentsOf: playCards.first!)
                        game.players[Index].hand.removeAll(where: { playCards.first!.contains($0) })
                        totable(card: playCards.first!)
                        tohands(Index: Index)
                    }
                    time += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                        // 次のターンへ
                        pass(Index: Index)
                        completion(true)
                    }

                    
                } else {
                    print("③ 出せるけど引くそして出さない")
                    // ③ 出せるけど引くそして出さない
                    time += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                        drawCard(Index: Index)
                    }
                    time += 1
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
                            print("④ 出せないので引く、出せるので出す")
                            time += 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                                game.table.append(contentsOf: playCards.first!)
                                game.players[Index].hand.removeAll(where: { playCards.first!.contains($0) })
                                totable(card: playCards.first!)
                                tohands(Index: Index)
                            }
                            time += 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                                // 次のターンへ
                                pass(Index: Index)
                                completion(true)
                            }

                            
                        } else {
                            // ⑤ 出せないので引く、出せるけどパス
                            print("⑤ 出せないので引く、出せるけどパス")
                            time += 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                                // 次のターンへ
                                pass(Index: Index)
                                completion(true)
                            }
                        }
                        
                    } else {
                        // ⑥ 出せないので引く、出せないのでパス
                        print("⑥ 出せないので引く、出せないのでパス")
                        time += 1
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

        var time = 1
        for number in numbers {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(time)) { [self] in
                                
                let player = game.players[number]
                // 出せるか判断
                var initCards = BotInitCard(table: game.table.last!, hand: player.hand)
                if !initCards.isEmpty {
                    initCards.shuffle()
                    if shouldBreakLoop || !(game.gamePhase == .gamefirst) {
                        return
                    }
                    let card = initCards.first!
                    game.table.append(card)
                    player.hand.removeAll { $0 == card }
                    totable(card: card)
                    tohands(Index: number)
                    
                    shouldBreakLoop = true
                    moveToMain(Index: number)
                } else {
                    print("\(player.name) 最初に出せるカードがないです")
                    // TODO: 処理
                }
            }
            time += 1
        }
    }
    
    //**********************************************************************************
    // GamePhase Event
    //**********************************************************************************

    
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

    // メインに向けた処理
    func moveToMain(Index: Int) {
        game.gamePhase = .main
        pass(Index: Index)
    }
    
    /**
     どてんこ
     どてんこプレイヤーの設定
     */
    func dtnkevent(Index: Int) {
//        Vibration().vib01()
//        let generator = UINotificationFeedbackGenerator()
//        @State var isVibrationOn = false
//        generator.notificationOccurred(.success)
//
//        gamedtnk = true
//        dtnkPlayer = players[Index]
//        dtnkPlayerIndex = Index
//        gamePhase = .dtnk
//        challengeFlag[Index] = 3
        print("Bot \(Index) DOTENKO")
    }



    //**********************************************************************************
    // Player Action
    //**********************************************************************************

    /**
     どてんこできるか
     */
    func dtnkJudge(playerAllCards: [CardId], table: [CardId]) -> Bool {
        var dtnkjudge = false
//        if game.gamePhase == .gamefirst || game.gamePhase == .gamefirst_sub || game.gamePhase == .main {
//            if !table.isEmpty {
//                dtnkjudge = GameMainController().sameSum(card: playerAllCards, tablelast: table.last!)
//            }
//        }
        return dtnkjudge
    }
    
    /**
     カードを出す
     */
    func playCards(Index: Int, cards: [CardId]) {
        let cardsToPlay = cards
        if cardsToPlay.isEmpty {
            print("カードを選択してください")
            return
        }
        if game.currentPlayerIndex != Index && game.currentPlayerIndex != 99 {
            print("自分のターンではないです")
            return
        }
        if checkMultipleCards(table: game.table.last!, playCard: cards) {
            game.table.append(contentsOf: cards)
            game.players[Index].hand.removeAll(where: { cardsToPlay.contains($0) })
            totable(card: cards)
            tohands(Index: Index)
            game.players[Index].selectedCards = []

        } else {
            print("それらのカードは出せないです")
        }
        // 次への処理
        pass(Index: Index)
    }
    
    /**
     カードを引く
     */
    func drawCard(Index: Int) {
        let drawnCard = game.deck.removeLast()
        game.players[Index].hand.append(drawnCard)
        tohands(Index: Index)
        
        // deck再生成
    }
    
    /*
     パスする
     */
    func pass(Index: Int) {
        game.currentPlayerIndex = (Index + 1) % game.players.count
        
        // Burstするとき
        //            burstPlayer = players[currentPlayerIndex]
        //            currentPlayerIndex = burstPlayerIndex
        //            self.gamePhase = .burst
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 ) {
        //                self.gamePhase = .decisionrate_pre
        //            }

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
            if card.number() != firstValue {
                return false
            }
        }
        return true
    }
    
    //**********************************************************************************
    // Card Animation
    //**********************************************************************************
    
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

