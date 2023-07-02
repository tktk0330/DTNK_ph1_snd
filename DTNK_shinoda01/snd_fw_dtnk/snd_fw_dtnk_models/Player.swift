
import SwiftUI

/**
 プレイヤー基本情報
 @ var user_id: String　固有ID
@ var name: String　名前
@ var hand: [Card]　手札
@ var icon_url: String　画像URL
@ var score: Int　ポイント
@ var dtnk: Bool　どてんこ判定
 */

class Player: Identifiable {
    let id: String
    var side: Int
    var name: String
    var hand: [Card] = []
    var icon_url: String
    var score = 0
    var dtnk: Bool
    var selectedCards: [Card] = []
    
    init(id: String, side: Int, name: String, icon_url: String) {
        self.id = id
        self.side = side
        self.name = name
        self.icon_url = icon_url
        self.score = 0
        self.dtnk = false

    }    
}
