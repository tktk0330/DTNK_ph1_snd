/**
 Realm
 */

import RealmSwift
import Foundation


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
    
    /**
     ゲーム設定変更
     */
    func updateGameSettingRealm(userId: String, item: String, value: Int, completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            if let user = realm.object(ofType: RealmUser.self, forPrimaryKey: userId) {
                try realm.write {
                    user.setValue(value, forKey: item)
                }
                completion(true)
            } else {
                completion(false)
            }
        } catch {
            print("Error updating Realm: \(error)")
            completion(false)
        }
    }
}

class LifeManager {
    private var user: RealmUser!
    

    init(user: RealmUser) {
        self.user = user
    }

    // ゲーム開始時のライフ消費
    func consumeLifeForGame() -> Bool {

        if user.currentLives > 0 {
            try! Realm().write {
                user.currentLives -= 1
                user.lastUpdated = Date() // 更新時刻も保存
            }
            appState.account.loginUser.life = user.currentLives
            return true
        } else {
            return false
        }
    }
    
    // 次のライフが回復するまでの残り時間（秒）を返す関数
    func timeUntilNextLifeRecovery() -> TimeInterval {
        let elapsedTime = Date().timeIntervalSince(user.lastUpdated)
        let remainingTimeForNextLife = 300 - (elapsedTime.truncatingRemainder(dividingBy: 300))
        return remainingTimeForNextLife
    }

}

