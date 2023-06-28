/**
 SplashView
 会社のロゴ的な物に変更
 
 裏で認証
 */
import SwiftUI
import Firebase
import FirebaseDatabase


struct SplashView: View {
    
    @State private var userName: String = ""
    @State private var iconURL: String = ""
    @StateObject var splash: SplashState = appState.splash
    
    init() {
        SplashController().initSplashState()
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 広告用
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                
                Text("IWM")
                    .font(.system(size: 100))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .bold()
                    .padding()
                    .opacity(splash.alpha)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.50)
                
            }
            .onAppear {
                // TODO: 時間差作らないとできない
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    startGame()
                }
                SplashController().onSplashAppear()
            }
        }
    }
    
    private func startGame() {
        if let currentUser = Auth.auth().currentUser {
            // ユーザーが既にログインしている場合、ユーザーデータを取得
            getUserData(userID: currentUser.uid) { userData in
                if let userData = userData {
                    // ユーザーデータが存在する場合、名前とアイコンのURLを使用
                    let name = userData.name
                    let iconURL = userData.iconURL
                    
                    // ゲームを開始するために名前とアイコンのURLを使用する処理を追加
                    startGameWithUserData(name: name, iconURL: iconURL)
                } else {
                    // ユーザーデータが存在しない場合、デフォルトの値を使用
                    let name = "ゲスト"
                    let iconURL = "icon-bot"
                    
                    // ゲームを開始するためにデフォルトの値を使用する処理を追加
                    startGameWithUserData(name: name, iconURL: iconURL)
                    // ユーザーデータを保存する処理を追加
                    saveUserData(userID: currentUser.uid, name: name, iconURL: iconURL)
                }
            }
        } else {
            // ユーザーがログインしていない場合、デフォルトの値を使用してゲームを開始
            let name = "ゲスト"
            let iconURL = "icon-bot"
            
            // ゲームを開始するためにデフォルトの値を使用する処理を追加
            startGameWithUserData(name: name, iconURL: iconURL)
            
            // 匿名認証を実行してユーザーを作成し、ユーザーデータを保存する処理を追加
            authenticateAnonymously { userID in
                saveUserData(userID: userID, name: name, iconURL: iconURL)
            }
        }
    }

    private func getUserData(userID: String, completion: @escaping (UserData?) -> Void) {
        let ref = Database.database().reference().child("users").child(userID)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let userData = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            let name = userData["name"] as? String ?? ""
            let iconURL = userData["iconURL"] as? String ?? ""
            
            let userDataObject = UserData(name: name, iconURL: iconURL)
            completion(userDataObject)
        }
    }

    private func saveUserData(userID: String, name: String, iconURL: String) {
        let ref = Database.database().reference().child("users").child(userID)
        
        let userData: [String: Any] = [
            "name": name,
            "iconURL": iconURL
        ]
        
        ref.setValue(userData) { (error, _) in
            if let error = error {
                print("ユーザーデータの保存に失敗しました: \(error.localizedDescription)")
            } else {
                print("ユーザーデータをFirebase Realtime Databaseに保存しました")
                getUserData(userID: userID) { userData in
                    if let userData = userData {
                        // ユーザーデータが存在する場合、名前とアイコンのURLを使用
                        let name = userData.name
                        let iconURL = userData.iconURL
                        print(name)
                        print(iconURL)
                    }
                }
            }
        }
    }

    private func authenticateAnonymously(completion: @escaping (String) -> Void) {
        Auth.auth().signInAnonymously { (result, error) in
            if let error = error {
                print("匿名認証に失敗しました: \(error.localizedDescription)")
                return
            }
            guard let userID = result?.user.uid else {
                print("ユーザーが見つかりません")
                return
            }
            completion(userID)
        }
    }

    private func startGameWithUserData(name: String, iconURL: String) {
        // ゲームを開始するためにユーザーデータを使用する処理を追加
        let userID = Auth.auth().currentUser?.uid ?? ""
        let newUser = User(userID: userID, name: name, iconURL: iconURL)
        appState.account.loginUser = newUser // loginUserに情報を格納
    }
}

struct UserData {
    let name: String
    let iconURL: String
}
