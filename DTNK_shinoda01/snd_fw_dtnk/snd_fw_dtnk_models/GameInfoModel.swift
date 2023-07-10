


import SwiftUI

struct GameInfoModel {
    
    // 参加者
    let players: [Player]
    // deck
    var deck = Deck()
    // jorker
    let joker: Int
    // table
    var table: [Card] = []
    
    // 現在プレイしている人
    var currentPlayerIndex: Int = 99
    // 最後にカードを出した人
    var lastPlayCardsPlayer: Player?
    // どてんこした人
    var dtnkPlayer: [(player: Player?, index: Int)] = [(nil, 99)]


    //　目標ゲーム数
    let targetgamenum: Int
    // 現在のゲーム数
    let game: Int = 1
    // 最初のカードを出したか
    var isfirstplayer: Bool = false
    // 出さないことを通知
    var initialAction: [Bool] = [true, true, true, true]
    
    // ゲーム状態を示す
    var gamePhase: GamePhase = .dealcard

    // 初期レート
    let rate: Int
    // 倍率
    var magunigication: Int = 1
    // 決定数
    var decisionnum: Int = 1
    
    // チャレンジプレーヤー
    var challengeplayers: [Player] = []
    // チャレンジ通知 init :0 yes :1 no :2 dtnkplayer :3

    
    // 勝者
    var winers: [Player] = []
    // 敗者
    var loosers: [Player] = []
    // ゲームスコア（単体）
    var gameScore: Int = 1
    
    

}

