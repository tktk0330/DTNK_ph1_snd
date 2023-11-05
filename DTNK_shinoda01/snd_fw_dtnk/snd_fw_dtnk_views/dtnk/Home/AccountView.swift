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
                        
            IconView(iconURL: myIconUrl, size: 60)

            Text(myNickname)
                .font(.custom(FontName.MP_Bl, size: 30))
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .bold()
                .padding()
        }
    }
}
