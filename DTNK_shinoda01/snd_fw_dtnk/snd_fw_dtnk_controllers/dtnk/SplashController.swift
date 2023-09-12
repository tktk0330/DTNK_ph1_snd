


import SwiftUI
import Foundation
import Firebase
import FirebaseDatabase
import RealmSwift

struct SplashController {
    
    func initSplashState() {
        let splashState = SplashState()
        appState.splash = splashState
    }
    
    func onSplashAppear() {
        Task {
            print("ホーム画面へ進みます")
            // ホームへ進む
            await scaleUpSplashAsync()
            Router().setBasePages(stack: [.top], animated: false)
        }
    }
    
    // 拡大アニメーション
    func scaleUpSplash(completion: @escaping () -> Void) {
        let delaySec: Double = 2
        let durationSec: Double = 0.5
        let endWidth = UIScreen.main.bounds.width * 8
        let endAlpha: Double = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySec) {
            withAnimation(.easeIn(duration: durationSec)) {
                appState.splash.width = endWidth
                appState.splash.alpha = endAlpha
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + durationSec) {
                completion()
            }
        }
    }
    
    // 拡大アニメーション の async ラップ
    func scaleUpSplashAsync() async {
        await withCheckedContinuation { continuation in
            scaleUpSplash {
                continuation.resume()
            }
        }
    }
    
    // ユーザー認証
    func setupUserData() {
        if let currentUser = Auth.auth().currentUser {
            let realm = try! Realm()
            if let user = realm.object(ofType: RealmUser.self, forPrimaryKey: currentUser.uid) {
                log("既存ユーザー：User ID: \(user.id), Name: \(user.name), Icon URL: \(user.iconURL)")
                DispatchQueue.main.async {
                    let newUser = User(userID: user.id, name: user.name, iconURL: user.iconURL)
                    appState.account.loginUser = newUser // loginUserに情報を格納
                }
            } else {
                print("Realm error?")
                // Realtime Databaseからユーザーデータを取得
                let ref = Database.database().reference().child("users").child(currentUser.uid)

                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? NSDictionary {
                        let newUser = RealmUser()
                        newUser.id = currentUser.uid
                        newUser.name = value["name"] as? String ?? "ゲスト"
                        newUser.iconURL = value["iconURL"] as? String ?? "icon-bot5"
                        // 取得したデータをRealmに登録
                        try! realm.write {
                            realm.add(newUser)
                        }
                        fetchUserData(userId: currentUser.uid)

                    } else {
                        print("User data does not exist")
                    }
                }) { (error) in
                    print("Error fetching data: \(error)")
                }
            }

        } else {
            log("新規登録")
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    print("Failed to sign in: \(error)")
                    return
                }
                guard let user = result?.user else { return }
                
                let newUser = RealmUser()
                newUser.id = user.uid
                newUser.name = "ゲスト"
                newUser.iconURL = "icon-bot5"
                
                let realm = try! Realm()
                try! realm.write {
                    realm.add(newUser)
                }
                
                // ユーザーデータを Realtime Database にも保存
                let ref = Database.database().reference().child("users").child(user.uid)
                ref.setValue(["name": "ゲスト", "iconURL": "icon-bot5"])
                fetchUserData(userId: user.uid)
            }
        }
    }
    
    // ログイン情報格納
    func fetchUserData(userId: String) {
        let realm = try! Realm()
        if let user = realm.object(ofType: RealmUser.self, forPrimaryKey: userId) {
            DispatchQueue.main.async {
                let newUser = User(userID: user.id, name: user.name, iconURL: user.iconURL)
                appState.account.loginUser = newUser // loginUserに情報を格納
            }
        } else {
            // User does not exist in the Realm, handle appropriately.
        }
    }
}

