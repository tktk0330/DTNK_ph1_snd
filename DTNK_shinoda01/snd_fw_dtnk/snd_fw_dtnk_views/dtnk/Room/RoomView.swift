/**
 ルーム
 */



import SwiftUI
import Firebase

struct RoomView: View {
    @State private var user: String = appState.account.loginUser.name
    @State private var text: String = ""
    @State private var searchtext: String = ""
    @State private var roomData = Room(roomID: "", roomName: "", creatorName: "", participants: [])
    
    
    func join() {
        let creatorName = user
        let room = roomData
        
        FirebaseManager.shared.joinRoom(room: room, participantName: creatorName) { success in
            if success {
                // 参加に成功した場合の処理
                print("参加成功")
            } else {
                // 参加に失敗した場合の処理
                print("参加失敗")
            }
        }
    }
    
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
                
                Text(roomData.participants.map { String($0) }.joined(separator: ", "))
                
                
                Button(action: {
                    
                    if text.isEmpty {
                        print("Room name cannot be empty")
                        return
                    }

                    let roomName = text
                    let creatorName = user
                    FirebaseManager.shared.createRoom(roomName: roomName, creatorName: creatorName) { roomID in
                        if let roomID = roomID {
                            // ルーム作成成功
                            print("Room created with ID: \(roomID)")
                        } else {
                            // ルーム作成失敗
                            print("Failed to create room")
                        }
                    }
                    
                }) {
                    Text("CREATE")
                        .font(.system(size: 20))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                        .padding(5)
                    
                }
                .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.60)
                
                Button(action: {
                    
                    if text.isEmpty {
                        print("Room name cannot be empty")
                        return
                    }

                    let roomName = text
                    FirebaseManager.shared.searchRoom(withRoomName: roomName) { (roomData) in
                        if let roomData = roomData {
                            self.roomData = roomData
                            print("Room found: \(roomData)")
                            // ルームが見つかった後の処理を書く
                            // 参加する
                            join()
                            
                        } else {
                            print("Room not found")
                        }
                    }
                }) {
                    Text("SEARCH")
                        .font(.system(size: 20))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                        .padding(5)
                }
                .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.70)

            }
        }
    }
}

            
struct Room {
    let roomID: String
    let roomName: String
    let creatorName: String
    var participants: [String]
}

class FirebaseManager {
    static let shared = FirebaseManager()
    private let database = Database.database()
    
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
    
    func joinRoom(room: Room, participantName: String, completion: @escaping (Bool) -> Void) {
        let participantData = ["participantName": participantName]
        
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
}

