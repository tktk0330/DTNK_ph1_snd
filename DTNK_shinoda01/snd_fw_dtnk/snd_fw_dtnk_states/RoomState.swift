


import SwiftUI
import Firebase
import FirebaseDatabase

class RoomState: ObservableObject {
    
    static let shared = FirebaseManager()
    let database = Database.database()
    @Published var roommode: RoomMode = .base
    @Published var roomData = Room(roomID: "", roomName: "", creatorName: "", participants: [])
    @Published var error_message = ""
    @Published var startFlg = false // realtime

        
    /**
     参加
     */
    func join(user: User) {
        
        let room = roomData
        let side = room.participants.count + 1
        let myaccount = Player(id: user.userID, side: side, name: user.name, icon_url: user.iconURL)
        
        FirebaseManager.shared.joinRoom(room: room, participant: myaccount) { [self] success in
            if success {
                // 参加に成功した場合の処理
                print("参加成功")
                // Matchingへ
                RoomController().moveMatchingView()
            } else {
                // 参加に失敗した場合の処理
                error_message = "参加失敗"
                print("参加失敗")
            }
        }
    }

    func updateParticipants(roomID: String) {
        // 取得したいルームのIDを指定
        let roomID = roomID
        // データベースの参照を取得
        let roomRef = Database.database().reference().child("rooms").child(roomID)

        // 参加者のリストをリアルタイムで監視するリスナーを設定
        roomRef.child("participants").observe(.value) { [self] snapshot in
            guard let participantsData = snapshot.value as? [[String: Any]] else {
                // データが存在しない場合や型が異なる場合は処理を終了
                return
            }
            // 参加者のリストを更新
            // JSON → Player
            var participants: [Player] = []
            for participantData in participantsData {
                if let id = participantData["id"] as? String,
                   let side = participantData["side"] as? Int,
                   let name = participantData["name"] as? String,
                   let icon_url = participantData["icon_url"] as? String {
                    let participant = Player(id: id, side: side, name: name, icon_url: icon_url)
                    participants.append(participant)
                }
            }
            appState.room.roomData.participants = participants
            if participants.count == 4 {
                // start ok
                startFlg = true
            }
        }
    }
}
