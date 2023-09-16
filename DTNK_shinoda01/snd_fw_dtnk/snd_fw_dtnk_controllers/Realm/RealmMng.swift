/**
 Realm
 */

import SwiftUI
import RealmSwift

class RealmMng {
    
    // ユーザーネーム変更
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
    
    // Icon変更
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
    
    // ゲーム設定変更
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
            log("Error updating Realm: \(error)", level: .error)
            completion(false)
        }
    }
    
    // Options設定
    func updateOptionRealm(item: String, value: Bool) {
        let realm = try! Realm()
        if let user = realm.object(ofType: RealmUser.self, forPrimaryKey: appState.account.loginUser.userID) {
            try! realm.write {
                user.setValue(value, forKey: item)
            }
        } else {
            log("Error updating Option", level: .error)
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
            return true
        } else {
            return false
        }
    }
    
    // ライフ回復
    func recoverLifeRealm() {
        
        try! Realm().write {
            user.currentLives += 1
            user.lastUpdated = Date() // 更新時刻も保存
        }
    }
    
    // 次のライフが回復するまでの残り時間（秒）を返す関数
    func timeUntilNextLifeRecovery() -> TimeInterval {
        let elapsedTime = Date().timeIntervalSince(user.lastUpdated)
        let remainingTimeForNextLife = 300 - (elapsedTime.truncatingRemainder(dividingBy: 300))
        return remainingTimeForNextLife
    }
}

class LifeMng {
    // ライフ情報登録
    func setLifeInfo() {
        let realm = try! Realm()
        if let user = realm.object(ofType: RealmUser.self, forPrimaryKey: appState.account.loginUser.userID) {
            try! realm.write {
                user.currentLives = appState.account.loginUser.life // 溜まってるライフ
                user.lifeTime = appState.account.loginUser.lifeTime // 回復中の残り秒数
                user.lastUpdated = Date() // 時間
                log("Home退出　ライフ：\(appState.account.loginUser.life)　回復中の残り時間：\(appState.account.loginUser.lifeTime)")
            }
        }
    }
    
    // ライフ情報取得
    func getLifeInfo() {
        let realm = try! Realm()
        if let user = realm.object(ofType: RealmUser.self, forPrimaryKey: appState.account.loginUser.userID) {
            appState.account.loginUser.life = user.currentLives
            appState.account.loginUser.lifeTime = user.lifeTime
            appState.account.loginUser.lastUpdated = user.lastUpdated
            log("Home入室　ライフ：\(appState.account.loginUser.life)　回復中の残り時間：\(appState.account.loginUser.lifeTime)")
        }
    }
}

