


import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase
import RealmSwift
import GoogleMobileAds

// TODO: できればRealmなどは別で書きたい
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        FirebaseApp.configure()
        
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    // Do nothing.
                }
            })
        Realm.Configuration.defaultConfiguration = config
        
        // TODO: 正式に記載
        // ユーザ認証
        authUser()
        startFunction()
        
        return true
    }
        
    func applicationWillResignActive(_ application: UIApplication) {
        // アプリがバックグラウンドに移行するときのカスタム処理

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // アプリが完全に終了する前のカスタム処理
    }

    // アプリ起動時に実行
    private func startFunction() {
        if let currentUser = Auth.auth().currentUser {
            // Realmからユーザーデータを取得
            let realm = try! Realm()
            if let user = realm.object(ofType: RealmUser.self, forPrimaryKey: currentUser.uid) {
                
                // life計算
                let item = GameCommonFunctions().calcuLife(life: user.currentLives, lifeTime: user.lifeTime, lastUpdated: user.lastUpdated)
                appState.account.loginUser.life = item.0
                appState.account.loginUser.lifeTime = item.1
                appState.account.loginUser.lastUpdated = item.2
                
                try! realm.write {
                    user.currentLives = item.0
                    user.lifeTime = item.1
                    user.lastUpdated = item.2
                }
            }
        }
    }
    
    private func authUser() {
        if let currentUser = Auth.auth().currentUser {
            // Realmからユーザーデータを取得
            let realm = try! Realm()
            if let user = realm.object(ofType: RealmUser.self, forPrimaryKey: currentUser.uid) {
                
                let newUser = User(userID: user.id,
                                   name: user.name,
                                   iconURL: user.iconURL,
                                   life: user.currentLives,
                                   lifeTime: user.lifeTime,
                                   lastUpdated: user.lastUpdated,
                                   gameNum: user.gameNum,
                                   gameJorker: user.gameJorker,
                                   gameRate: user.gameRate,
                                   gameMaximum: user.gameMaximum,
                                   gameUpRate: user.gameUpRate,
                                   gameDeckMaximum: user.gameDeckMaximum,
                                   se: user.se,
                                   sound: user.sound,
                                   vibration: user.vibration)
                appState.account.loginUser = newUser
                log("\(newUser)")
            } else {
                // realmから取得できなかった時
                // Realtime Databaseからユーザーデータを取得
                let ref = Database.database().reference().child("users").child(currentUser.uid)
                
                ref.observeSingleEvent(of: .value, with: { [self] (snapshot) in
                    if let value = snapshot.value as? NSDictionary {
                        let newUser = RealmUser()
                        newUser.id = currentUser.uid
                        newUser.name = value["name"] as? String ?? "ゲスト"
                        newUser.iconURL = value["iconURL"] as? String ?? "icon-bot5"
                        newUser.currentLives = value["life"] as? Int ?? 5
                        newUser.lifeTime = value["lifetime"] as? Int ?? 0
                        if let lastupdateTimestamp = value["lastupdate"] as? Int {
                            let lastupdate = Date(timeIntervalSince1970: TimeInterval(lastupdateTimestamp)) // UNIX timestampからDateに変換
                            newUser.lastUpdated = lastupdate
                        }
                        // 取得したデータをRealmに登録
                        try! realm.write {
                            realm.add(newUser)
                        }
                        fetchUserData(userId: currentUser.uid)
                        
                    } else {
                        log("User data does not exist")
                    }
                }) { (error) in
                    log("Error fetching data: \(error)")
                }
            }
        } else {
            log("新規登録")
            Auth.auth().signInAnonymously { [self] (result, error) in
                if let error = error {
                    log("Failed to sign in: \(error)", level: .error)
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
                let newUser = User(
                    userID: user.id,
                    name: user.name,
                    iconURL: user.iconURL,
                    life: user.currentLives,
                    lifeTime: user.lifeTime,
                    lastUpdated: user.lastUpdated,
                    gameNum: user.gameNum,
                    gameJorker: user.gameJorker,
                    gameRate: user.gameRate,
                    gameMaximum: user.gameMaximum,
                    gameUpRate: user.gameUpRate,
                    gameDeckMaximum: user.gameDeckMaximum,
                    se: user.se,
                    sound: user.sound,
                    vibration: user.vibration)
                appState.account.loginUser = newUser // loginUserに情報を格納
            }
        } else {
            // User does not exist in the Realm, handle appropriately.
        }
    }
    // アプリ終了時に実行(不具合起きやすい)
    private func endFunction() {
        
    }
}
