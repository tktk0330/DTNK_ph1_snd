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

    var body: some View {
        GeometryReader { geo in
            ZStack{
                // 広告用
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                
                // back
                Button(action: {
                    Router().setBasePages(stack: [.home])
                }) {
                    Image(ImageName.Common.back.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                }
                .position(x: UIScreen.main.bounds.width * 0.10, y:  geo.size.height * 0.10)

                // title
                Text("Room")
                    .font(.custom(FontName.font01, size: 45))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.15)
                
                TextField("search room", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(5)
                    .frame(width: 300)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.30)
                
                Text(message)
                    .foregroundColor(Color.red)
                    .padding(5)
                    .frame(width: 300)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.40)

                VStack(spacing: 50) {
                    Button(action: {
                        onTapCreate()
                    }) {
                        Btnwb(btnText: "Create", btnTextSize: 30, btnWidth: 200, btnHeight: 60)
                    }
                    
                    Button(action: {
                        onTapSearch()
                    }) {
                        Btnwb(btnText: "Search", btnTextSize: 30, btnWidth: 200, btnHeight: 60)
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.60)
                
                if room.roommode == .pop {
                    JoinPopView()
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.50)
                }
            }
        }
    }
    
    /**
     作成＋参加
     挙動としては作成して検索かけて遷移
     */
    func onTapCreate() {
        if text.isEmpty {
            message = "Room name cannot be empty"
            return
        }
        let roomName = text
        let user = appState.account.loginUser
        // Player準備
        // 作成者なのでsideは1
        let myaccount = Player(id: user!.userID, side: 1, name: user!.name, icon_url: user!.iconURL)

        RoomFirebaseManager.shared.createRoom(roomName: roomName, creator: myaccount) { roomName in
            if let roomName = roomName {
                // ルーム作成成功
                print("Room created with ID: \(roomName)")
                // 検索
                RoomFirebaseManager.shared.searchRoom(withRoomName: roomName) { (roomData) in
                    if let roomData = roomData {
                        room.roomData = roomData
                        print("Room found: \(roomData)")
                        // マッチングへ
                        RoomController().moveMatchingView()
                        
                    } else {
                        message = "erroer"
                    }
                }
            } else {
                // ルーム作成失敗
                print("Failed to create room")
            }
        }
    }
    
    /**
     検索
     */
    func onTapSearch() {
        if text.isEmpty {
            message = "Room name cannot be empty"
            return
        }
        let roomName = text
        
        RoomFirebaseManager.shared.searchRoom(withRoomName: roomName) { (roomData) in
            if let roomData = roomData {
                room.roomData = roomData
                print("Room found: \(roomData)")
                // 参加可否POPへ
                RoomController().onOpenMenu()
            } else {
                message = "Room not found"
            }
        }
    }
}
