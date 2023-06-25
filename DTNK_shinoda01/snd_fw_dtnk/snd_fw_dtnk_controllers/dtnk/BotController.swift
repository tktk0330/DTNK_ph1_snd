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
     Botどてんこ実行
     */
    func BotDtnkAct(tabelelastcard: Card, hand: [Card]) -> Bool {
        
        if GameMainController().sameSum(card: hand, tablelast: tabelelastcard) {
            // どてんこ実行
            return true
        } else {
            return false
        }
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
    
    
    func getMatchingCards(numbers: [Int], hand: [Card]) -> [Card] {
        let matchingCards = hand.filter { card in
            return numbers.contains(card.number)
        }
        return matchingCards
    }
    
    
    /**
     出せるカードの配列を返す
     @Index : Int　Pyaler Index
     return [Card]
     */
    // TODO: Botの性能向上　おかしな挙動はこの場所の可能性大
    func playableCards(bot: Player, mytable: [Card]) -> [[Card]] {
        
//        print("テーブル \(mytable.last!)")

        var botSelectCards: [[Card]] = []
        var arrays: [[Int]] = []
        for i in 0..<bot.hand.count {
            arrays.append(bot.hand[i].cardid.value())
        }
        
        let calculator = CombinationsCalculator(arrays: arrays, target: mytable.last!.number)
        calculator.calculateCombinations()
        
        // 複数枚で出す（合計が一緒）
        if !calculator.cardsList.isEmpty {
            let randomList = calculator.cardsList.randomElement()!
            let matchingCards = getMatchingCards(numbers: randomList, hand: bot.hand)
            botSelectCards.append(matchingCards)
//            print("合計 \(matchingCards)")
        }
        
        // 単品
        var singleCards: [[Card]] = []
        var i = 0
        for card in bot.hand {
            if card.number == mytable.last!.number || card.suit == mytable.last!.suit {
                singleCards.append([card])
                i += 1
//                print("単品　\(card)")
            }
        }
        botSelectCards.append(contentsOf: singleCards)

//        print("候補数　\(botSelectCards.count)")
//        for i in 0..<botSelectCards.count {
//            print("候補　\(botSelectCards[i])")
//        }
        
        return botSelectCards
    }
    
    
    /**
     出せるカードの配列を返す
     @Index : Int　Pyaler Index
     return [Card]
     */
    func playableCard(bot: Player, mytable: [Card]) -> [Card] {
        // 単品
        if let lastCard = mytable.last {
            let playableCard = bot.hand.filter { card in
                return card.suit == lastCard.suit || card.number == lastCard.number
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
    let arrays: [[Int]]
    let target: Int
    var cardsList: [[Int]] = []
    

    init(arrays: [[Int]], target: Int) {
        self.arrays = arrays
        self.target = target
    }

    func calculateCombinations() {
        if !arrays.isEmpty {
            for count in 1...arrays.count {
                //            print("Combination count: \(count)\n")
                calculateCombinationsHelper(selected: [], startIndex: 0, count: count)
            }
        }
    }

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
