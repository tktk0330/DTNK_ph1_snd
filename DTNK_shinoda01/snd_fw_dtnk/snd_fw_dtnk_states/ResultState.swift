


import SwiftUI

class SubState: ObservableObject {
    let resultItem: ResultItem
    
    init(resultItem: ResultItem) {
        self.resultItem = resultItem
    }
    
}
/**
 ゲーム結果情報【単体】
 */
class ResultItem: ObservableObject {
    
    let playersRank: [Int]
    let winners: [Player_f]
    let losers: [Player_f]
    let decisionScoreCards: [CardId]
    let ascendingRate: Int
    let gameScore: Int
    
    init(
        playersRank: [Int],
        winners: [Player_f],
        losers: [Player_f],
        decisionScoreCards: [CardId],
        ascendingRate: Int,
        gameScore: Int
    ){
        self.playersRank = playersRank
        self.winners = winners
        self.losers = losers
        self.decisionScoreCards = decisionScoreCards
        self.ascendingRate = ascendingRate
        self.gameScore = gameScore
    }
}

class ResultState: ObservableObject {
    
    let gameitems: GameResultItem
    let playeritems: [PlayerResultItem]
    
    init(gameitems: GameResultItem
         , playeritems: [PlayerResultItem]
    ) {
        self.gameitems = gameitems
        self.playeritems = playeritems
    }
}

/**
 ゲーム結果情報【単体】
 */
class GameResultItem: ObservableObject {
    // Gmae共通
    let gamenum: Int
    let rate: Int
    let magunigication: Int
    let decisionnum: Int
    let gamescore: Int
    let winners: [Player]
    let loosers: [Player]
    
    init(
     gamenum: Int,
     rate: Int,
     magunigication: Int,
     decisionnum: Int,
     gamescore: Int,
     winners: [Player],
     loosers: [Player]
    ){
        self.gamenum = gamenum
        self.rate = rate
        self.magunigication = magunigication
        self.decisionnum = decisionnum
        self.gamescore = gamescore
        self.winners = winners
        self.loosers = loosers
    }
}

/**
 プレイヤー結果情報
 */
class PlayerResultItem: ObservableObject {
    
    // Player別
    let rank: Int
    let index: Int
    let iconUrl: String
    let name: String
    let score: Int
    let changed: Double
    
    init(
        rank: Int,
        index: Int,
        iconUrl: String,
        name: String,
        score: Int,
        changed: Double
    ){
        self.rank = rank
        self.index = index
        self.iconUrl = iconUrl
        self.name = name
        self.score = score
        self.changed = changed
    }

}
