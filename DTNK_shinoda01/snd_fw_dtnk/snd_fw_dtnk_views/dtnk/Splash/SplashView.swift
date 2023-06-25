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
    @StateObject private var userListViewModel = UserListViewModel()
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
                    autoAuthenticate()
                }
                SplashController().onSplashAppear()
            }
        }
    }
    
    private func autoAuthenticate() {
        Auth.auth().signInAnonymously { (result, error) in
            if let currentUser = Auth.auth().currentUser {
                // ユーザーが既にログインしている場合、ユーザー情報を表示
                let User = userListViewModel.getUserByID(currentUserID: currentUser.uid)
                appState.account.loginUser = User

                } else {
                // ユーザーがログインしていない場合、匿名認証を実行
                authenticateAnonymously()
            }
        }
    }
    
    private func authenticateAnonymously() {
        Auth.auth().signInAnonymously { (result, error) in
            if let error = error {
                print("匿名認証に失敗しました: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else {
                print("ユーザーが見つかりません")
                return
            }
            
            // 匿名認証が成功した場合、ユーザー名の初期値を設定
            if let existingUser = userListViewModel.getUserByID(currentUserID: user.uid) {
                self.userName = existingUser.name
                print(userName)
            } else {
                self.userName = "ゲスト"
                // 新規登録の場合、ユーザー情報を保存
                saveUserData(userID: user.uid)
            }
        }
    }
    
    private func saveUserData(userID: String) {
        let ref = Database.database().reference()
        let userRef = ref.child("users").child(userID)
        
        let data: [String: Any] = [
            "name": userName,
            "iconURL": iconURL
        ]
        
        userRef.setValue(data) { (error, _) in
            if let error = error {
                print("ユーザーデータの保存に失敗しました: \(error.localizedDescription)")
            } else {
                print("ユーザーデータをRealtime Databaseに保存しました")
            }
        }
    }
}
