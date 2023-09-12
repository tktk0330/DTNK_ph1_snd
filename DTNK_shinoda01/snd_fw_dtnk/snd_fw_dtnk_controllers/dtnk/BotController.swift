/**
 BotAction
 */

import Foundation
import SwiftUI

struct BotController {
    
    /**
     Botチャレンジ可否
     
     return Int(challengeFlag)　１：チャレンジ　２：NG　３：どてんこした人です　99：返し
     */
    func CheckBotChallenge(bot: Player, Index: Int, table: [Card], dtnkPlayerIndex: Int) -> Int {
        let dtnkcard = table.last!.number
        let handsum = CalculateHandTotal(hand: bot.hand)
        var challengeFlag = 0
        
        if dtnkPlayerIndex != Index {
            // Revenge
            if handsum == dtnkcard {
                // 何秒か考えてどてんこ
                challengeFlag = 99
                // チャレンジできる
            } else if handsum < dtnkcard {
                challengeFlag = 1
                // 無理
            } else {
                challengeFlag = 2
            }
        } else {
            challengeFlag = 3
        }
        
        return challengeFlag
    }
    
    /**
     Botどてんこ実行判定
     */
    func BotDtnkAct(tabelelastcard: CardId, hand: [CardId]) -> Bool {
        
        print("bot dtnk judge \(hand)")
        return false
//        if GameMainController().sameSum(card: hand, tablelast: tabelelastcard) {
//            // どてんこ実行
//            return true
//        } else {
//            return false
//        }
    }
    
    /**
     手札の合計計算
     */
    func CalculateHandTotal(hand: [Card]) -> Int {
        var sum = 0
        for i in 0..<hand.count {
            sum += hand[i].cardid.number()
        }
        return sum
    }
    
    
    func getMatchingCards(numbers: [Int], hand: [CardId]) -> [CardId] {
        let matchingCards = hand.filter { card in
            return numbers.contains(card.number())
        }
        return matchingCards
    }
    
    
    /**
     出せるカードの配列を返す
     @Index : Int　Pyaler Index
     return [Card]
     */
    // TODO: Botの性能向上　おかしな挙動はこの場所の可能性大
    func playableCards(bot: Player_f, tablecard: CardId) -> [[CardId]] {
        // 出せるパターン
        var botSelectCards: [[CardId]] = []
        
        // valueで格納し直す　jorker考慮のため
        var arrays: [[Int]] = [] // [[8], [10], [-1, 0, 1]]
        for i in 0..<bot.hand.count {
            arrays.append(bot.hand[i].value())
        }
        
        let calculator = CombinationsCalculator(arrays: arrays, target: tablecard.number())
        calculator.calculateCombinations()
        // 複数枚で出す（合計が一緒）
        if !calculator.cardsList.isEmpty {
            let randomList = calculator.cardsList.randomElement()!
            let matchingCards = getMatchingCards(numbers: randomList, hand: bot.hand)
            botSelectCards.append(matchingCards)
//            print("合計 \(matchingCards)")
        }
        
        // 単品　数字かスーとが一緒であればOK
        var singleCards: [[CardId]] = []
        var i = 0
        for card in bot.hand {
            if card.number() == tablecard.number() || card.suit() == tablecard.suit() {
                singleCards.append([card])
                i += 1
//                print("単品　\(card)")
            }
        }
        botSelectCards.append(contentsOf: singleCards)

        return botSelectCards
    }
    
    
    /**
     出せるカードの配列を返す
     @Index : Int　Pyaler Index
     return [Card]
     */
    func playableCard(bot: Player_f, mytable: [CardId]) -> [CardId] {
        // 単品
        if let lastCard = mytable.last {
            let playableCard = bot.hand.filter { card in
                return card.suit() == lastCard.suit() || card.number() == lastCard.number()
            }
            return playableCard
        } else {
            return []
        }
    }

}

/**
 手札の組み合わせ全通り
 */
class CombinationsCalculator {
    let arrays: [[Int]] // 手札
    let target: Int // テーブル数字
    var cardsList: [[Int]] = []
    

    init(arrays: [[Int]], target: Int) {
        self.arrays = arrays
        self.target = target
    }

    func calculateCombinations() {
        if !arrays.isEmpty {
            for count in 1...arrays.count {
                calculateCombinationsHelper(selected: [], startIndex: 0, count: count)
            }
        }
    }
    // カードがとりえる値を算出 合計が一緒のものはリストに追加
    private func calculateCombinationsHelper(selected: [Int], startIndex: Int, count: Int) {
        if selected.count == count {
            let sum = selected.reduce(0, +)
//            print("Selected elements: \(selected)")
//            print("Sum: \(sum)\n")
            // 選択合計
            if sum == target {
                cardsList.append(selected)
            }
        }
        for i in startIndex..<arrays.count {
            let currentArray = arrays[i]
            for value in currentArray {
                var newSelected = selected
                newSelected.append(value)
                calculateCombinationsHelper(selected: newSelected, startIndex: i + 1, count: count)
            }
        }
    }
}
