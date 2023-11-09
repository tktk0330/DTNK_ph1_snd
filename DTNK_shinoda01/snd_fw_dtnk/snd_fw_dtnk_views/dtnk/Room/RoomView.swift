/**
 ルームView
 */

import SwiftUI
import Firebase
import FirebaseDatabase

struct RoomView: View {
    
    @StateObject var room: RoomState = appState.room
    @State private var user: String = appState.account.loginUser.name
    @State private var text: String = ""
    @State private var message: String = ""
    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            ZStack{
                
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                    }

                // back
                BackButton(backPage: .home, geo: geo, keyboardHeight: keyboardHeight)

                // title
                Text("Room")
                    .font(.custom(FontName.font01, size: 45))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.15 + keyboardHeight)
                
                TextField("search room", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(5)
                    .frame(width: 300)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.30 + keyboardHeight)
                
                Text(message)
                    .foregroundColor(Color.red)
                    .padding(5)
                    .frame(width: 300)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.40 + keyboardHeight)

                VStack(spacing: 50) {
                    if room.type == .create {
                        Button(action: {
                            onTapCreate()
                        }) {
                            Btnwb(btnText: "Create", btnTextSize: 30, btnWidth: 200, btnHeight: 60)
                        }
                        .buttonStyle(PressBtn())
                    } else if room.type == .participate {
                        
                        Button(action: {
                            onTapSearch()
                        }) {
                            Btnwb(btnText: "Search", btnTextSize: 30, btnWidth: 200, btnHeight: 60)
                        }
                        .buttonStyle(PressBtn())
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.60 + keyboardHeight)
                
                if room.roommode == .pop {
                    JoinPopView()
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.50)
                }
                
                if room.roommode == .waiting {
                    WaitingLoadingView()
                }
            }
        }
        .onAppear {
            // キーボード対応
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notif in
                let value = notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let height = value.height
                keyboardHeight = height / 10
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                keyboardHeight = 0
            }
        }
    }
    
    /**
     作成＋参加
     挙動としては作成して検索かけて遷移
     */
    func onTapCreate() {
        
        guard validateText(text) else {
            return // バリデーションエラーがある場合は処理を終了
        }
        room.roommode = .waiting

        let roomName = text
        let user = appState.account.loginUser
        // Player準備：作成者なのでsideは1
        let myaccount = Player(id: user!.userID, side: 1, name: user!.name, icon_url: user!.iconURL)

        // ルーム作成
        RoomFirebaseManager.shared.createRoom(roomName: roomName, creator: myaccount) { roomName in
            if let roomName = roomName {
                log("Room created with ID: \(roomName)")
                // 検索
                RoomFirebaseManager.shared.searchRoom(withRoomName: roomName) { (roomData) in
                    if let roomData = roomData {
                        room.roomData = roomData
                        log("Room found: \(roomData)")
                        // マッチングへ
                        GameEventController().moveMatchingView(vsInfo: 02)
                        
                        // 画面初期化
                        room.roommode = .base
                    } else {
                        message = "erroer"
                    }
                }
            } else {
                // ルーム作成失敗
                log("Failed to create room", level: .error)
            }
        }
    }
    
    /**
     検索
     */
    func onTapSearch() {
        
        guard validateText(text) else {
            return // バリデーションエラーがある場合は処理を終了
        }

        room.roommode = .waiting

        let roomName = text
        
        RoomFirebaseManager.shared.searchRoom(withRoomName: roomName) { (roomData) in
            if let roomData = roomData {
                room.roomData = roomData
                log("Room found: \(roomData)")
                // 参加可否POPへ
                RoomController().onOpenMenu()
            } else {
                message = "ルームが見つかりません"
                room.roommode = .base
            }
        }
    }
    
    // キーボードを隠す
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // バリデーションチェック
    private func validateText(_ text: String) -> Bool {
        if text.isEmpty {
            self.message = "ルーム名を入れてください"
            return false
        }
        // 許可される文字セットを定義: 英数字、ひらがな、カタカナ、漢字
        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "ぁ-んァ-ン一-龥"))
        if text.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            // 文字列に許可されていない記号が含まれている場合
            self.message = "ルーム名に不正な文字が含まれています"
            return false
        }
        if text.count > 10 {
            self.message = "ルーム名は10文字以下で入力してください"
            return false
        }
        
        // ここでエラーをクリアします
        self.message = ""
        return true
    }

}
