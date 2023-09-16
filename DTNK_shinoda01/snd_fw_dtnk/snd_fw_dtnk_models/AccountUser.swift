/**
 Acount
 */

import SwiftUI

struct User {
    let userID: String
    var name: String
    var iconURL: String
    // Life
    var life: Int // ライフ数
    var lifeTime: Int // 回復中ライフの残り時間
    var lastUpdated: Date // 時刻
    // Game Setting
    var gameNum: Int
    var gameJorker: Int
    var gameRate: Int
    var gameMaximum: Int
    var gameUpRate: Int
    var gameDeckMaximum: Int
    
    init(userID: String, name: String, iconURL: String, life: Int, lifeTime: Int, lastUpdated: Date, gameNum: Int,  gameJorker: Int,  gameRate: Int,  gameMaximum: Int,  gameUpRate: Int,  gameDeckMaximum: Int) {
        self.userID = userID
        self.name = name
        self.iconURL = iconURL
        self.life = life
        self.lifeTime = lifeTime
        self.lastUpdated = lastUpdated
        self.gameNum = gameNum
        self.gameJorker = gameJorker
        self.gameRate = gameRate
        self.gameMaximum = gameMaximum
        self.gameUpRate = gameUpRate
        self.gameDeckMaximum = gameDeckMaximum
    }
}
