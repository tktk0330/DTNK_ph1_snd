/**
 FireBaseManager
 
 */

import SwiftUI
import Firebase
import FirebaseDatabase

class DatabaseMng {
    
    static let shared = FirebaseManager()
    private let database = Database.database()
    let databaseRef = Database.database().reference()
    
    //------------------------------------------------------------------------------------
    // Realtimedatabase
    //------------------------------------------------------------------------------------

    /**
     
     */
    func createRoom(roomName: String, creatorName: String, completion: @escaping (String?) -> Void) {
        let roomID = database.reference().child("rooms").childByAutoId().key ?? ""
        let roomData: [String: Any] = [
            "roomID": roomID,
            "roomName": roomName,
            "creatorName": creatorName,
            "participants": [creatorName]
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
     
     */
    func searchRoom(withRoomName roomName: String, completion: @escaping (Room?) -> Void) {
        let roomQuery = database.reference().child("rooms").queryOrdered(byChild: "roomName").queryEqual(toValue: roomName)
        
        roomQuery.observeSingleEvent(of: .value) { (snapshot) in
            guard let roomData = snapshot.children.allObjects.first as? DataSnapshot,
                  let roomDict = roomData.value as? [String: Any],
                  let roomID = roomDict["roomID"] as? String,
                  let roomName = roomDict["roomName"] as? String,
                  let creatorName = roomDict["creatorName"] as? String,
                  let participants = roomDict["participants"] as? [String]
            else {
                completion(nil)
                return
            }
            
            let room = Room(roomID: roomID, roomName: roomName, creatorName: creatorName, participants: participants)
            completion(room)
        }
    }
    
    /**
     
     */
    func joinRoom(room: Room, participantName: String, completion: @escaping (Bool) -> Void) {
//        let participantData = ["participantName": participantName]
        
        let participantsRef = database.reference().child("rooms").child(room.roomID).child("participants")
        participantsRef.observeSingleEvent(of: .value) { (snapshot) in
            if var participants = snapshot.value as? [String] {
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
    
    /**
     
     */
    func registAccount(accountData: accountData) {
        let userID = database.reference().child("accounts").childByAutoId().key ?? ""
        
        databaseRef.child("accounts").child(userID).setValue(accountData)

    }
    
}


struct  accountData {
    let user_id: String
    let nickname: String
    let icon_url: String
}



