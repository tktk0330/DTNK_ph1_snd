/**
 FireBaseManager (ROOM)
 */

import SwiftUI
import Firebase
import FirebaseDatabase

class RoomFirebaseManager {
    
    static let shared = RoomFirebaseManager()
    private let database = Database.database()
    // json変換用
    let cjm = ConvertJSONMng()
    
    // TODO: 整理
    struct GameBase {
        let players: [Player_f]
    }

    /**
     ルーム作成
     */
    func createRoom(roomName: String, creator: Player, completion: @escaping (String?) -> Void) {
        let myAccountJSON = cjm.playerJSON(player: creator)
        let roomID = database.reference().child("rooms").childByAutoId().key ?? ""
        let roomData: [String: Any] = [
            "roomID": roomID,
            "roomName": roomName,
            "hostID": creator.id,
            "participants": [myAccountJSON],
            "matchingFlg": 0
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
     指定したルームIDのゲーム情報を検索して保存
     */
    func retrieveGameInfo(forRoom roomID: String, completion: @escaping (GameBase?) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo")
        gameInfoRef.observeSingleEvent(of: .value) { snapshot in
            guard let gameInfoDict = snapshot.value as? [String: [String: Any]],
                  let gameData = gameInfoDict.values.first,
                  let playersDict = gameData["players"] as? [[String: Any]]
            else {
                completion(nil)
                return
            }
            
            var players: [Player_f] = []
            for playerDict in playersDict {
                guard let id = playerDict["id"] as? String,
                      let side = playerDict["side"] as? Int,
                      let name = playerDict["name"] as? String,
                      let iconURL = playerDict["icon_url"] as? String
                else {
                    // 必要な情報が欠落している場合はスキップ
                    continue
                }
                
                let player = Player_f(id: id, side: side, name: name, icon_url: iconURL)
                players.append(player)
            }
            
            let gameBase = GameBase(players: players)
            completion(gameBase)
        }
    }
    
    /**
     Game開始の送信
     */
    func sendGameStartNotification(roomID: String) {
        let roomRef = database.reference().child("rooms").child(roomID)
        // ルーム内の参加者リストを取得する
        roomRef.child("participants").observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value is [[String: Any]] else {
                // 参加者データの取得に失敗した場合
                return
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
                  let hostID = roomData["hostID"] as? String,
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
            let room = Room(roomID: roomID, roomName: roomName, hostID: hostID, participants: participants)
            completion(room)
        }
    }
    
    /**
     GameStates OK
     ボタンを押したらmatchingFlgをOKにする
     */
    func updateMatchingFlg(roomID: String, value: Int, completion: @escaping (Bool) -> Void) {
        let roomRef = database.reference().child("rooms").child(roomID)
        // OK:1 Exist:2
        roomRef.child("matchingFlg").setValue(value) { error, _ in
            if let error = error {
                log("Failed to update room status: \(error.localizedDescription)", level: .error)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    /**
     matchingFlgの監視
     */
    func observeMatchingFlg(roomID: String, completion: @escaping (Int?) -> Void) {
        let ref = database.reference().child("rooms").child(roomID).child("matchingFlg")
        ref.observe(.value) { (snapshot) in
            guard let matchingFlg = snapshot.value as? Int else {
                log("error", level: .error)
                return
            }
            completion(matchingFlg)
        }
    }
        
    /**
     ルーム参加
     */
    func joinRoom(room: Room, participant: Player, completion: @escaping (Bool) -> Void) {
        
        let myAccountJSON = cjm.playerJSON(player: participant)
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
                        log("Failed to join room: \(error.localizedDescription)", level: .error)
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

    /**
     現在の参加人数を取得
     */
    func getParticipantsCount(roomID: String, completion: @escaping (Int?) -> Void) {
        let participantsRef = database.reference().child("rooms").child(roomID).child("participants")
        participantsRef.observeSingleEvent(of: .value) { snapshot in
            guard let participantsData = snapshot.value as? [[String: Any]] else {
                completion(nil)
                return
            }
            completion(participantsData.count)
        }
    }
}
