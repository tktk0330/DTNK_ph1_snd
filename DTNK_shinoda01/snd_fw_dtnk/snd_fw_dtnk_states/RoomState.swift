


import SwiftUI
import Firebase
import FirebaseDatabase

class RoomState: ObservableObject {
    
    @Published var roommode: RoomMode = .base
    @Published var roomData = Room(roomID: "", roomName: "", hostID: "", participants: [])
    @Published var error_message = ""
    @Published var type: RoomType = .base
    @Published var startFlg = false // realtime

    /**
     参加
     */
    func join(user: User) {
        
        roommode = .waiting
        
        let room = roomData
        var side = 0
        // side（何番目の参加か）の取得
        RoomFirebaseManager().getParticipantsCount(roomID: roomData.roomID) { [self] count in
            if count != nil {
                side = count! + 1
                let myaccount = Player(id: user.userID, side: side, name: user.name, icon_url: user.iconURL)
                RoomFirebaseManager.shared.joinRoom(room: room, participant: myaccount) { [self] success in
                    if success {
                        // 参加に成功した場合の処理
                        log("参加成功")
                        // Matchingへ
                        GameEventController().moveMatchingView(vsInfo: 02)
                        
                        roommode = .base

                    } else {
                        roommode = .pop
                        // 参加に失敗した場合の処理
                        error_message = "参加失敗"
                        log("参加失敗", level: .warning)
                    }
                }
            } else {
                roommode = .pop
                log("error count", level: .warning)
            }
        }
    }

    /**
     参加者の更新
     */
    func updateParticipants(roomID: String) {

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
            appState.matching.players = participants
            
            
            if participants.count == 1 {
                // start ok
                startFlg = true
            }
        }
        
        // マッチングしたらゲームへ
        RoomFirebaseManager.shared.observeMatchingFlg(roomID: roomID) { result in
            if result == 1 {
                // stateの設定
                RoomFirebaseManager().retrieveGameInfo(forRoom: roomID) { gameBase in
                    appState.gameUIState.players = gameBase!.players
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    // 遷移
                    Router().pushBasePage(pageId: .dtnkMain_friends)
                    appState.room.roommode = .base
                }
            }
        }
    }
}
