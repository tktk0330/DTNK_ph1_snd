/**
 Realmの設定（初期値）
 */

import SwiftUI
import RealmSwift

class RealmUser: Object {
    // UserInfo
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var iconURL: String = ""
    // LifeInfo
    @objc dynamic var currentLives: Int = 5
    @objc dynamic var lastUpdated: Date = Date()
    // GameSetteingInfo
    @objc dynamic var gameNum: Int = 5
    @objc dynamic var gameJorker: Int = 2
    @objc dynamic var gameRate: Int = 100
    @objc dynamic var gameMaximum: Int = 0
    @objc dynamic var gameUpRate: Int = 0
    @objc dynamic var gameDeckMaximum: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
