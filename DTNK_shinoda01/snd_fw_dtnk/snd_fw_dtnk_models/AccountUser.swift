/**
 acount
 もしコレクションなど固有の情報追加するならここ
 */

import SwiftUI
import FirebaseDatabase

struct User {
    let userID: String
    var name: String
    var iconURL: String
    var life: Int
    // Game Setting
    var gameNum: Int
    var gameJorker: Int
    var gameRate: Int
    var gameMaximum: Int
    var gameUpRate: Int
    var gameDeckMaximum: Int
    
    init(userID: String, name: String, iconURL: String, life: Int, gameNum: Int,  gameJorker: Int,  gameRate: Int,  gameMaximum: Int,  gameUpRate: Int,  gameDeckMaximum: Int) {
        self.userID = userID
        self.name = name
        self.iconURL = iconURL
        self.life = life
        self.gameNum = gameNum
        self.gameJorker = gameJorker
        self.gameRate = gameRate
        self.gameMaximum = gameMaximum
        self.gameUpRate = gameUpRate
        self.gameDeckMaximum = gameDeckMaximum
    }
}
