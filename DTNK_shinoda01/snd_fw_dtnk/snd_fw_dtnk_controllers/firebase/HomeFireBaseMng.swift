



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
                print("Failed to update username in Firebase: \(error.localizedDescription)")
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
                print("Failed to update username in Firebase: \(error.localizedDescription)")
                completion(false)
                return
            }
            
        }
        completion(true)
    }

}

