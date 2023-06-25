/**
 acount
 もしコレクションなど固有の情報追加するならここ
 */

import SwiftUI
import FirebaseDatabase

struct User {
    let userID: String
    let name: String
    let iconURL: String

    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
              let name = dict["name"] as? String,
              let iconURL = dict["iconURL"] as? String
        else {
            return nil
        }

        self.userID = snapshot.key
        self.name = name
        self.iconURL = iconURL
    }
}
