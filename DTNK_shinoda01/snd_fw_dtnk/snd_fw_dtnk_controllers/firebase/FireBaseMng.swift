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
     ルーム作成
     */
    func createRoom(roomName: String, creatorName: Player, completion: @escaping (String?) -> Void) {
        
        // Player →　JSON
        let myAccountJSON: [String: Any] = [
            "id": creatorName.id,
            "side": creatorName.side,
            "name": creatorName.name,
            "icon_url": creatorName.icon_url
        ]
        
        let roomID = database.reference().child("rooms").childByAutoId().key ?? ""
        let roomData: [String: Any] = [
            "roomID": roomID,
            "roomName": roomName,
            "creatorName": creatorName.name,
            "participants": [myAccountJSON]
        ]
        database.reference().child("rooms").child(roomID).setValue(roomData) { (error, _) in
            if let error = error {
                print("Failed to create room: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(roomID)
            }
        }
    }
    
    /**
     検索
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
     参加
     */
    func joinRoom(room: Room, participantName: Player, completion: @escaping (Bool) -> Void) {
        let participantData = ["participantName": participantName]
        
        let participantsRef = database.reference().child("rooms").child(room.roomID).child("participants")
        participantsRef.observeSingleEvent(of: .value) { (snapshot) in
            if var participants = snapshot.value as? [Player] {
                participants.append(participantName)
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
}
