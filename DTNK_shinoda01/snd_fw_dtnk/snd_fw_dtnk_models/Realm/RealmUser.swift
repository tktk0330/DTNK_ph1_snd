/**
 Realmの設定
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
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
