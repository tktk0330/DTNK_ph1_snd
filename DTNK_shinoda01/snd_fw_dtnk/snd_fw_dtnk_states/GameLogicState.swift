


import SwiftUI


/**
 ゲームState
 id :　ゲーム固有のID
 deck :　カードデッキ
 sides :　参加者【ゲーム情報】
 players :　参加者【固有情報】

 */

struct GameLogicState {
//    let id: String
    var deck: [CardId]
    var sides: [GameSide]
    
//    var gamestep: GameStep
}

/**
 GameSide
 プレイヤーの保持情報？
 ゲームで保持すべきもの
 */
struct GameSide {
    let seat: GameSeat
    var score: Int
    var hand: [Card]
    // TODO: まだまだあるはず
    // どてんこ情報とか？
}


/**
 GameSeat
 プレイヤーの番号
 */
// TODO: ４人以上でもできるように
enum GameSeat: Int {
    case s1 = 1
    case s2 = 2
    case s3 = 3
    case s4 = 4
}

/**
 GameStep
 Game状態
 */
enum GameStep: Int {
    
    case dealcard
    case main
    
}
