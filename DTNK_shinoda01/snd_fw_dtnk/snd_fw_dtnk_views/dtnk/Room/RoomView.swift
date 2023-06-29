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
                
                // title
                Text("ROOM")
                    .font(.system(size: 45))
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

                HStack(spacing: 50) {
                    Button(action: {
                        onTapCreate()
                    }) {
                        Text("CREATE")
                            .font(.system(size: 20))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .bold()
                            .padding()
                            .frame(width: 120, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 3)
                            )
                    }
                    
                    Button(action: {
                        onTapSearch()
                    }) {
                        Text("SEARCH")
                            .font(.system(size: 20))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .bold()
                            .padding()
                            .frame(width: 120, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 3)
                            )
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.50)
                
                if room.roommode == .pop {
                    JoinPopView()
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.50)
                }
            }
        }
    }
    func onTapCreate() {
        if text.isEmpty {
            message = "Room name cannot be empty"
            print("Room name cannot be empty")
            return
        }
        
        let roomName = text
        let creatorName = user
        FirebaseManager.shared.createRoom(roomName: roomName, creatorName: creatorName) { roomID in
            if let roomID = roomID {
                // ルーム作成成功
                print("Room created with ID: \(roomID)")
                // 参加してマッチングへ
//                room.join(user: user)
            } else {
                // ルーム作成失敗
                print("Failed to create room")
            }
        }
    }
    
    func onTapSearch() {
        if text.isEmpty {
            message = "Room name cannot be empty"
            print("Room name cannot be empty")
            return
        }
        let roomName = text
        FirebaseManager.shared.searchRoom(withRoomName: roomName) { (roomData) in
            if let roomData = roomData {
                room.roomData = roomData
                print("Room found: \(roomData)")
                // ルームが見つかった後の処理を書く
                // 参加する
                RoomController().onOpenMenu()
            } else {
                print("Room not found")
                message = "Room not found"
            }
        }
    }
}
