


import SwiftUI
import RealmSwift

class RealmUser: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var iconURL: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
