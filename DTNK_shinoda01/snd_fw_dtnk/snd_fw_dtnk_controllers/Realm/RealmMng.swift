/**
 Realm
 */

import RealmSwift


class RealmMng {
    
    
    /**
     ユーザーネーム変更
     */
    func updateUsernameInRealm(userId: String, newUsername: String, completion: @escaping (Bool) -> Void) {
        let realm = try! Realm()
        if let user = realm.object(ofType: RealmUser.self, forPrimaryKey: userId) {
            try! realm.write {
                user.name = newUsername
                completion(true)
            }
        } else {
            completion(false)
        }
    }
    
    /**
     Icon変更
     */
    func updateIconInRealm(userId: String, iconURL: String, completion: @escaping (Bool) -> Void) {
        let realm = try! Realm()
        if let user = realm.object(ofType: RealmUser.self, forPrimaryKey: userId) {
            try! realm.write {
                user.iconURL = iconURL
                completion(true)
            }
        } else {
            completion(false)
        }
    }

}
