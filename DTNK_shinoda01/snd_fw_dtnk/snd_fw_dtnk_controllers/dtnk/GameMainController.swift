//
//  GameMainController.swift
//  Dtnk-ver002
//
//  Created by Takuma Shinoda on 2023/05/30.
//

import SwiftUI

struct GameMainController {
    

    /**
     
     */
    func resetHands(players: [Player]) {
        // 手札のリセット
        players.forEach { player in
            player.hand.removeAll()
        }
    }
    
    /**
     
     */
    func Announce(text: String) {
        AnnounceLabel(text){
            print("end")
        }
    }

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

    /**
     バーストアクション
     */
    func Burst(Index: Int) {
        // Burstview
        // 勝敗決定
        // チャレンジなし レート画面
        
        
    }
    
//**********************************************************************************
// About Player card Action
//**********************************************************************************

    /**
     カードの組み合わせが有効かどうかをチェックする
     */
    func isValid(_ cards: [Card], tablelast: Card) -> Bool {
        // 一枚
        if cards.count == 1 {
            // 同じマーク 同じ数字 Jokerを出す　であればOK
            if sameSuit(card: cards, tablelast: tablelast) || sameNum(card: cards, tablelast: tablelast ) || cards[0].cardid.number() == 0 {
                return true
            }
            return false
        }
        // 複数枚
        if cards.count > 1 {
            // 先頭同じマーク＋後続同数字
            if sameSuit(card: cards, tablelast: tablelast) && sameHandNum(card: cards) {
                return true
            }
            // 全部場と同じ数字
            else if sameNum(card: cards, tablelast: tablelast) {
                return true
            }
            // 合計が同じ
            else if sameSum(card: cards, tablelast: tablelast) {
                return true
            }
            return false
        }
        return false
    }
    
    /**
     マークが同じか
     */
    func sameSuit(card: [Card], tablelast: Card) -> Bool {
        // 先頭マーク同じもしくは先頭Jorker
        if(card[0].suit == tablelast.suit) || (card[0].cardid.number() == 0) {
            return true
        }
        return false
    }
    
    
    /**
     手札数字が全て同じか
     */
    func sameHandNum(card: [Card]) -> Bool {
        
        var targetnum = 0
        // 選択されたカードでJorker以外のものを一つ設定する
        for i in card {
            if i.suit != .all {
                targetnum = i.cardid.number()
            }
        }
        
        // targetnumに変化がなければ全てJorker
        if targetnum == 0 {
            // all jorker
            return true
        }
        
        for i in 0..<card.count-1 {
            if card[i].cardid.number() != targetnum && card[i].suit != .all {
                return false
            }
        }
        return true
    }

    /**
     数字が場と同じか
     */
    func sameNum(card: [Card], tablelast: Card) -> Bool {
        
        for i in 0..<card.count {
            if(card[i].cardid.number() != tablelast.cardid.number()){
                // Joker is OK
                if card[i].suit == .all{
                    continue
                }
                return false
            }
        }
        return true
    }
    
    /**
     合計が同じか
     */
    func sameSum(card: [Card], tablelast: Card) -> Bool {
        
        var arrays: [[Int]] = []
        for i in 0..<card.count {
            arrays.append(card[i].cardid.value())
        }
        
        var combinations: [[Int]] = [[]]
        for array in arrays {
            var temp: [[Int]] = []
            for value in array {
                for combination in combinations {
                    var newCombination = combination
                    newCombination.append(value)
                    temp.append(newCombination)
                }
            }
            combinations = temp
        }

        for combination in combinations {
            
            var sum = 0
            
            for i in 0..<combination.count{
                sum += combination[i]
            }
            
            if sum == tablelast.number {
                return true
            }
        }
        return false
    }

        
    
    
    
}

