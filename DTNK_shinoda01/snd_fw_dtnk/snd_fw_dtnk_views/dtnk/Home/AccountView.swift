import SwiftUI
import Firebase
import FirebaseDatabase

struct AccountView: View {
    @State private var userName: String = ""
    @State private var iconURL: String = ""
    @State private var isEditingName: Bool = false
    @StateObject private var userListViewModel = UserListViewModel()
    
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
                .font(.system(size: 20))
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .bold()
                .padding()
                .frame(width: 120, height: 50)
                .onTapGesture {
                    isEditingName = true
                }
        }
        .environmentObject(userListViewModel)
        .sheet(isPresented: $isEditingName) {
            EditUserNameView(userName: $myNickname, isPresented: $isEditingName)
                .environmentObject(userListViewModel)
        }
    }
}

class UserListViewModel: ObservableObject {
    @Published var userList: [User] = []

    private var databaseHandle: DatabaseHandle!
    private var ref: DatabaseReference = Database.database().reference().child("users")

    init() {
        observeUserList()
    }

    private func observeUserList() {
        databaseHandle = ref.observe(.value) { [weak self] snapshot in
            var users: [User] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let user = User(snapshot: snapshot) {
                    users.append(user)
                }
            }
            self?.userList = users
        }
    }
    
    func getUserByID(currentUserID: String) -> User? {
        return userList.first { $0.userID == currentUserID }
    }
}

struct EditUserNameView: View {
    @EnvironmentObject var userListViewModel: UserListViewModel
    @Binding var userName: String
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            TextField("新しいユーザー名", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                saveUserName()
            }) {
                Text("保存")
            }
        }
        .padding()
    }

    private func saveUserName() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("ユーザーIDが取得できません")
            return
        }

        userListViewModel.saveUserName(userID: currentUserID, name: userName)
        isPresented = false
    }
}

extension UserListViewModel {
    func saveUserName(userID: String, name: String) {
        guard let user = userList.first(where: { $0.userID == userID }) else {
            print("ユーザーが見つかりません")
            return
        }

        let ref = Database.database().reference().child("users").child(user.userID)
        ref.updateChildValues(["name": name]) { (error, _) in
            if let error = error {
                print("ユーザー名の変更に失敗しました: \(error.localizedDescription)")
            } else {
                let User = self.getUserByID(currentUserID: userID)
                appState.account.loginUser = User
                print("ユーザー名を変更しました")
            }
        }
    }
}
