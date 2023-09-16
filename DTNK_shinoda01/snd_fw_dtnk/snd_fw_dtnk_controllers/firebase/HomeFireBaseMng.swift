


import SwiftUI
import FirebaseAuth
import FirebaseDatabase

class HomeFireBaseMng {
    
    /**
     ユーザーネーム変更
     */
    func upDateUserName(newUsername: String, completion: @escaping (Bool) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser else {
            completion(false)
            return
        }
        
        // Firebaseのデータベースにユーザーネームを更新
        let ref = Database.database().reference().child("users").child(currentUser.uid)
        ref.updateChildValues(["name": newUsername]) { (error, _) in
            if let error = error {
                log("Failed to update username in Firebase: \(error.localizedDescription)", level: .error)
                completion(false)
                return
            }
            
            
        }
        completion(true)
    }
    
    /**
     アイコン変更
     */
    func upDateIcon(iconURL: String, completion: @escaping (Bool) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser else {
            completion(false)
            return
        }
        
        // Firebaseのデータベースにユーザーネームを更新
        let ref = Database.database().reference().child("users").child(currentUser.uid)
        ref.updateChildValues(["iconURL": iconURL]) { (error, _) in
            if let error = error {
                log("Failed to update username in Firebase: \(error.localizedDescription)", level: .error)
                completion(false)
                return
            }
            
        }
        completion(true)
    }

    // ライフ情報の登録
    func setLifeInfo(completion: @escaping (Bool) -> Void) {
                
        guard let currentUser = Auth.auth().currentUser else {
            completion(false)
            return
        }
        
        let life = appState.account.loginUser.life
        let lifeTime = appState.account.loginUser.lifeTime
        let lastUpdated = appState.account.loginUser.lastUpdated
        let ref = Database.database().reference().child("users").child(currentUser.uid)

        let userValues: [String: Any] = [
            "life": life,
            "lifetime": lifeTime,
            "lastupdate": Int(lastUpdated.timeIntervalSince1970)  // DateをUNIX timestampに変換
        ]
        
        ref.updateChildValues(userValues) { (error, _) in
            if let error = error {
                log("Error updating data: \(error.localizedDescription)", level: .error)
            } else {
                completion(true)
            }
        }
    }
    
    // ライフ情報の取得
    func getLifeInfo(completion: @escaping (Bool) -> Void) {
        
//        guard let currentUser = Auth.auth().currentUser else {
//            completion(false)
//            return
//        }
//
//        let ref = Database.database().reference().child("users").child(currentUser.uid)
//
//        ref.observeSingleEvent(of: .value) { (snapshot) in
//            guard let userData = snapshot.value as? [String: Any] else {
//                log("Error fetching user data", level: .error)
//                return
//            }
//
//            let life = userData["life"] as? Int
//            let lifetime = userData["lifetime"] as? Int
//            if let lastupdateTimestamp = userData["lastupdate"] as? Int {
//                let lastupdate = Date(timeIntervalSince1970: TimeInterval(lastupdateTimestamp)) // UNIX timestampからDateに変換
//
////                appState.account.loginUser.life
////                appState.account.loginUser.lifeTime
////                appState.account.loginUser.lastUpdated
//
//                completion(true)
//            } else {
//                completion(false)
//            }
//        }
    }
}

