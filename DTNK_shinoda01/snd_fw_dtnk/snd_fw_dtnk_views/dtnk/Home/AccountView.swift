/**
 ユーザー情報表示
 */


import SwiftUI
import Firebase
import FirebaseDatabase

struct AccountView: View {
    @State var myNickname = appState.account.loginUser.name
    @State var myIconUrl = appState.account.loginUser.iconURL
    
    var body: some View {
        HStack {
            
            Image(myIconUrl)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
          
            Text(myNickname)
                .font(.custom(FontName.font01, size: 30))
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .bold()
                .padding()
            
            // ここでは編集させない
//            Button(action: {
//                guard let loginUser = appState.account.loginUser else { return }
//                // 編集された名前とアイコンのURLを保存
//                saveUserData(userID: loginUser.userID, name: loginUser.editedName, iconURL: loginUser.editedIconURL)
//            }) {
//                Text("保存")
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
            
        }
    }
    /**
     編集保存
     */
    // TODO: 移動
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
                // 編集された名前とアイコンのURLを反映
                appState.account.loginUser?.name = name
                appState.account.loginUser?.iconURL = iconURL
            }
        }
    }
}
