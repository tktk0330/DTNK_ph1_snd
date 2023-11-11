/**
 PlayUIState
 */


import SwiftUI

/**
 ゲーム開始時に設定するアイテム
 */
struct GameInfoModel {
    // 現在のゲーム数
    let gameNum: Int = 1
    //　目標ゲーム数
    let gameTarget: Int
    // ゲーム状態を示す
    var gamePhase: GamePhase = .dealcard
    var gamevsInfo: vsInfo = .vsFriend
    // deck
    let deck: [CardId]
    // table
    var table: Any = NSNull()
    // jorker
    let joker: Int
    // 参加者
    let players: [Player]
    // 現在プレイしている人
    var currentPlayerIndex: Int = 99
    // 最後にカードを出した人
    var lastPlayerIndex: Int = 99
    // どてんこした人
    var dtnkPlayer: Any =  NSNull()
    var dtnkPlayerIndex: Int = 99
    // 初期レート
    var initialRate: Int
    // 倍率
    var ascendingRate: Int = 1
    // 決定数
    var decisionScoreCards: Any = NSNull()
    // 初め出せるか通知
    var firstAnswers = Array(repeating: FirstAnswers.initial.rawValue, count: 4)
    // チャレンジプレーヤー
    var challengeAnswers = Array(repeating: ChallengeAnswer.initial.rawValue, count: 4)
    // 次のゲーム行けるか
    var nextGameAnnouns = Array(repeating: NextGameAnnouns.initial.rawValue, count: 4)
    // 勝者
    var winners: Any = NSNull()
    // 敗者
    var losers: Any = NSNull()
    // ゲームスコア（単体）
    var gameScore: Int = 0
}

/**
 次のゲームに行く時に設定するアイテム
 */
struct GameResetItem {
    // 現在のゲーム数
    var gameNum: Int = appState.gameUIState.gameNum + 1
    // ゲーム状態を示す
    var gamePhase: GamePhase = .dealcard
    // deck
    var deck: [CardId] = appState.gameUIState.deck.shuffled()
    // table
    var table: Any = NSNull()
    // playerHand
    var hand = Array(repeating: NSNull() , count: 4)
    // 現在プレイしている人
    var currentPlayerIndex: Int = 99
    // 最後にカードを出した人
    var lastPlayerIndex: Int = 99
    // どてんこした人
    var dtnkPlayer: Any =  NSNull()
    var dtnkPlayerIndex: Int = 99
    // バーストした人
    var burstPlayer: Any =  NSNull()
    var burstPlayerIndex: Int = 88
    // 倍率
    var ascendingRate: Int = 1
    // 決定数
    var decisionScoreCards: Any = NSNull()
    // 初め出せるか通知
    var firstAnswers = Array(repeating: FirstAnswers.initial.rawValue, count: 4)
    // チャレンジプレーヤー
    var challengeAnswers = Array(repeating: ChallengeAnswer.initial.rawValue, count: 4)
    // チャレンジャーの結果
    var challengers: [[Int]] = []
    // 次のゲーム行けるか
    var nextGameAnnouns = Array(repeating: NextGameAnnouns.initial.rawValue, count: 4)
    // 勝者
    var winners: Any = NSNull()
    // 敗者
    var losers: Any = NSNull()
    // ゲームスコア（単体）
    var gameScore: Int = 0
}
