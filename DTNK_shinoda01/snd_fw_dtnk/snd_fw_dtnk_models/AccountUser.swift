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
    

    
    init(userID: String, name: String, iconURL: String, life: Int) {
        self.userID = userID
        self.name = name
        self.iconURL = iconURL
        self.life = life
    }
}
