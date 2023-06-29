


import SwiftUI
import Firebase
import FirebaseDatabase

enum RoomMode: Int {
    case base = 0
    case pop = 1
}

class RoomState: ObservableObject {
    
    static let shared = FirebaseManager()
    let database = Database.database()
    @Published var roommode: RoomMode = .base
    @Published var roomData = Room(roomID: "", roomName: "", creatorName: "", participants: [])
    @Published var isListening = false // realtime
    @Published var error_message = ""
    
    func join(user: String) {
        let creatorName = user
        let room = roomData
        
        FirebaseManager.shared.joinRoom(room: room, participantName: creatorName) { [self] success in
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
        listenToRoomChanges(roomID: room.roomID)
    }
    
    func listenToRoomChanges(roomID: String) {
        let roomRef = database.reference().child("rooms").child(roomID)
        roomRef.observe(.value) { snapshot in
            guard let roomDict = snapshot.value as? [String: Any],
                  let participants = roomDict["participants"] as? [String] else {
                return
            }
            self.roomData.participants = participants
        }
        isListening = true
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
            appState.room.roomData.participants = participantsData
        }
    }

    
    
}




/**
 RoomModel
 */
struct Room {
    let roomID: String
    let roomName: String
    let creatorName: String
    var participants: [String]
}

