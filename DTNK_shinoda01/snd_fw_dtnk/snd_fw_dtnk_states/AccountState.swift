


import SwiftUI

class AccountState: ObservableObject {
    // ログイン中のユーザー
    @Published var loginUser: User!
    // ログアウト済みのユーザー
    @Published var logoutUserIDList: [String]
    
    init(loginUser: User? = nil,
         logoutUserIDList: [String] = []) {
        self.loginUser = loginUser
        self.logoutUserIDList = logoutUserIDList
    }

}

