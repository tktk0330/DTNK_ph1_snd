/**
 FireBaseManager
 */

import SwiftUI
import Firebase
import FirebaseDatabase

class FirebaseManager {
    
    static let shared = FirebaseManager()
    private let database = Database.database()
    
    
    /**
     ゲーム開始【参加者を遷移】
     */
    func moveGame() {
        
    }
    
    /**
     Gameを保存
     */
    func saveGameInfo(_ gameInfo: GameInfoModel, roomID: String, completion: @escaping (Bool) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").childByAutoId()
        let gameInfoDict: [String: Any] = [
            "property1": "1",
            "property2": "2",
            // 他のプロパティも同様に追加
        ]
        gameInfoRef.setValue(gameInfoDict) { error, _ in
            if let error = error {
                print("Failed to save game info: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
    /**
     Game開始の送信
     */
    func sendGameStartNotification(roomID: String) {
        let roomRef = database.reference().child("rooms").child(roomID)
        
        // ルーム内の参加者リストを取得する
        roomRef.child("participants").observeSingleEvent(of: .value) { snapshot in
            guard let participantsData = snapshot.value as? [[String: Any]] else {
                // 参加者データの取得に失敗した場合
                return
            }
            
            // 参加者ごとに通知を送信する
            for participantData in participantsData {
                if let playerID = participantData["id"] as? String {
//                    sendNotification(to: playerID, message: "ゲームが開始しました")
                }
            }
        }
    }


    
    /**
     Convert JSON
     */
    func playerJSON(player: Player) -> [String: Any] {
        let PlayerJSON: [String: Any] = [
            "id": player.id,
            "side": player.side,
            "name": player.name,
            "icon_url": player.icon_url
        ]
        return PlayerJSON
    }
    
    /**
     ルーム作成
     */
    func createRoom(roomName: String, creator: Player, completion: @escaping (String?) -> Void) {
                
        let myAccountJSON = playerJSON(player: creator)
        let roomID = database.reference().child("rooms").childByAutoId().key ?? ""
        let roomData: [String: Any] = [
            "roomID": roomID,
            "roomName": roomName,
            "creatorName": creator.name,
            "participants": [myAccountJSON],
            "matchingFlg": "yet"
        ]
        database.reference().child("rooms").child(roomID).setValue(roomData) { (error, _) in
            if let error = error {
                print("Failed to create room: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(roomName)
            }
        }
    }
    
    /**
     ルーム検索
     */
    func searchRoom(withRoomName roomName: String, completion: @escaping (Room?) -> Void) {
        let roomQuery = database.reference().child("rooms").queryOrdered(byChild: "roomName").queryEqual(toValue: roomName)
        
        roomQuery.observeSingleEvent(of: .value) { (snapshot) in
            guard let roomDict = snapshot.value as? [String: [String: Any]],
                  let roomData = roomDict.values.first,
                  let roomID = roomData["roomID"] as? String,
                  let roomName = roomData["roomName"] as? String,
                  let creatorName = roomData["creatorName"] as? String,
                  let participantsDict = roomData["participants"] as? [[String: Any]]
            else {
                completion(nil)
                return
            }

            var participants: [Player] = []
            for participantData in participantsDict {
                if let id = participantData["id"] as? String,
                   let side = participantData["side"] as? Int,
                   let name = participantData["name"] as? String,
                   let icon_url = participantData["icon_url"] as? String {
                    let participant = Player(id: id, side: side, name: name, icon_url: icon_url)
                    participants.append(participant)
                }
            }

            let room = Room(roomID: roomID, roomName: roomName, creatorName: creatorName, participants: participants)
            print(room)
            completion(room)
        }
    }
    
    /**
     GameStates OK
     ボタンを押したらmatchingFlgをOKにする
     */
    func updateMatchingFlg(roomID: String){
        let roomRef = database.reference().child("rooms").child(roomID)
        // ルームのmatchingFlgを「ok」に更新
        roomRef.child("matchingFlg").setValue("ok") { error, _ in
            if let error = error {
                print("Failed to update room status: \(error.localizedDescription)")
            } else {
            }
        }
    }
    
    /**
     matchingFlgの監視
     */

    func observeMatchingFlg(roomID: String) {
        let roomRef = database.reference().child("rooms").child(roomID)
        let matchingFlgRef = roomRef.child("matchingFlg")
        
        // matchingFlgの値の変更を監視
        matchingFlgRef.observe(.value) { snapshot in
            if let matchingFlg = snapshot.value as? String {
                if matchingFlg == "ok" {
                    // 遷移
                    Router().pushBasePage(pageId: .top)
                }
            }
        }
    }


    /**
     ルーム参加
     */
    func joinRoom(room: Room, participant: Player, completion: @escaping (Bool) -> Void) {
        
        let myAccountJSON = playerJSON(player: participant)
        let participantsRef = database.reference().child("rooms").child(room.roomID).child("participants")
        participantsRef.observeSingleEvent(of: .value) { (snapshot) in
            if var participants = snapshot.value as? [[String: Any]] {
                if participants.count < 4 {
                    participants.append(myAccountJSON)
                } else {
                    // 人数Over
                    completion(false)
                    return
                }
                participantsRef.setValue(participants) { (error, _) in
                    if let error = error {
                        print("Failed to join room: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            } else {
                completion(false)
            }
        }
    }
    
    /**
     ルーム退出
     */
    func leaveRoom(roomID: String, participantID: String, completion: @escaping (Bool) -> Void) {
        let roomRef = database.reference().child("rooms").child(roomID)
        
        // パートicipantとルーム情報を取得して更新する
        roomRef.observeSingleEvent(of: .value) { (snapshot) in
            guard var roomData = snapshot.value as? [String: Any],
                  var participants = roomData["participants"] as? [[String: Any]] else {
                // ルームデータが取得できない場合は処理を終了
                completion(false)
                return
            }
            
            // パートicipantを検索して削除する
            for (index, participant) in participants.enumerated() {
                if let id = participant["id"] as? String, id == participantID {
                    participants.remove(at: index)
                    break
                }
            }
            
            // 更新した参加者リストを保存する
            roomData["participants"] = participants
            roomRef.setValue(roomData) { (error, _) in
                if let error = error {
                    print("Failed to leave room: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    /**
     ルーム削除
     */
    func deleteRoom(roomID: String, completion: @escaping (Bool) -> Void) {
        let roomRef = database.reference().child("rooms").child(roomID)
        
        // ルームを削除する前に参加者を削除する
        roomRef.child("participants").removeValue { (error, _) in
            if let error = error {
                print("Failed to delete participants: \(error.localizedDescription)")
                completion(false)
            } else {
                // 参加者の削除が成功したらルーム自体を削除する
                roomRef.removeValue { (error, _) in
                    if let error = error {
                        print("Failed to delete room: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        }
    }


}
