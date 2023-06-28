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
    var editedName: String // 編集用のプロパティ
    var editedIconURL: String // 編集用のプロパティ
    
    init(userID: String, name: String, iconURL: String) {
        self.userID = userID
        self.name = name
        self.iconURL = iconURL
        self.editedName = name // 初期値は現在の名前
        self.editedIconURL = iconURL // 初期値は現在のアイコンのURL
    }
}
