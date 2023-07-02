


import SwiftUI
import Firebase
import FirebaseDatabase

class RoomState: ObservableObject {
    
    static let shared = FirebaseManager()
    let database = Database.database()
    @Published var roommode: RoomMode = .base
    @Published var roomData = Room(roomID: "", roomName: "", creatorName: "", participants: [])
    @Published var isListening = false // realtime
    @Published var error_message = ""
    
    /**
     参加
     */
    func join(user: String) {
        let info = appState.account.loginUser
        let myaccount = Player(id: info!.userID, side: 1, name: info!.name, icon_url: info!.iconURL)
        let creatorName = user
        let room = roomData
        
        FirebaseManager.shared.joinRoom(room: room, participantName: myaccount) { [self] success in
            if success {
                // 参加に成功した場合の処理
                print("参加成功")
                // Matchingへ
                appState.matching = MatchingState(seatCount: 4, message: "プレイヤーを募集しています...")
                Router().pushBasePage(pageId: .dtnkMatching)
                
            } else {
                // 参加に失敗した場合の処理
                error_message = "参加失敗"
                print("参加失敗")
            }
        }
    }
    
    func updateParticipants() {
        let roomID = roomData.roomID // 取得したいルームのIDを指定
        // データベースの参照を取得
        let roomRef = Database.database().reference().child("rooms").child(roomID)

        // 参加者のリストをリアルタイムで監視するリスナーを設定
        roomRef.child("participants").observe(.value) { snapshot in
            guard let participantsData = snapshot.value as? [String] else {
                // データが存在しない場合や型が異なる場合は処理を終了
                return
            }
            // 参加者のリストを更新
//            appState.room.roomData.participants = participantsData
        }
    }
}
