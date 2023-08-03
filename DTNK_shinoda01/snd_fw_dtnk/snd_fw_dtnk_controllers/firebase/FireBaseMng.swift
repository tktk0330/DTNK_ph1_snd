/**
 FireBaseManager
 */

import SwiftUI
import Firebase
import FirebaseDatabase

class FirebaseManager {
    
    static let shared = FirebaseManager()
    private let database = Database.database()
    // json変換用
    let cjm = ConvertJSONMng()
    
    @StateObject var game: GameUIState = appState.gameUIState
    @StateObject var room: RoomState = appState.room
    let roomID = appState.room.roomData.roomID
    let gameID = appState.gameUIState.gameID

    //-------------------------------GAMEMAIN-------------------------------
    //-------------------------------GAMEMAIN-------------------------------
    //-------------------------------GAMEMAIN-------------------------------
    
    /**
     Gameの登録
     */
    func saveGameInfo(_ gameInfo: GameInfoModel, roomID: String, completion: @escaping (Bool) -> Void) {
        
        let gameID = database.reference().child("rooms").child(roomID).child("gameInfo").childByAutoId().key ?? ""
        let playersJSON = cjm.playersJSON(players: gameInfo.players)
        let deckData = gameInfo.deck.map { card -> [String: Any] in
            return ["cardID": card.rawValue]  // Cardを辞書に変換
        }
        let gameInfoDict: [String: Any] = [
            "gameID": gameID,
            "players": playersJSON,
            "deck": deckData,
            "gamePhase": GamePhase.dealcard.rawValue,
            "currentPlayerIndex": 99
            // 他のプロパティも同様に追加
        ]
        database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID).setValue(gameInfoDict) { error, _ in
            if let error = error {
                print("Failed to save game info: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    /**
     Gameの取得
     */
    func getGameInfo(from roomID: String, completion: @escaping (GameState?) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo")
        gameInfoRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let gameInfoDict = snapshot.value as? [String: [String: Any]],
                  let gameData = gameInfoDict.values.first,
                  let gameId = gameData["gameID"] as? String,
                  let deckDict = gameData["deck"] as? [[String: Int]]
            else {
                return
            }
            var cardIds: [CardId] = []
            for cardData in deckDict {
                if let cardID = cardData["cardID"], let cardEnum = CardId(rawValue: cardID) {
                    cardIds.append(cardEnum)
                }
            }
            let gameState = GameState(gameID: gameId, deck: cardIds)
            completion(gameState)
        }
    }
    
    /**
     Deckの取得（リアルタイム）
     */
    func observeDeckInfo(from roomID: String, gameID: String, completion: @escaping ([CardId]?) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        let deckRef = gameInfoRef.child("deck")
        deckRef.observe(.value) { snapshot in
            guard let deckDict = snapshot.value as? [[String: Any]] else {
                completion(nil)
                return
            }
            var cardIds: [CardId] = []
            for cardData in deckDict {
                if let cardID = cardData["cardID"] as? Int, let cardEnum = CardId(rawValue: cardID) {
                    cardIds.append(cardEnum)
                }
            }
            completion(cardIds)
        }
    }
    
    /**
     Tableの取得（リアルタイム）
     */
    func observeTableInfo(from roomID: String, gameID: String, completion: @escaping ([CardId]?) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        let deckRef = gameInfoRef.child("table")
        deckRef.observe(.value) { snapshot in
            guard let tableDict = snapshot.value as? [[String: Any]] else {
                completion(nil)
                return
            }
            var cardIds: [CardId] = []
            for cardData in tableDict {
                if let cardID = cardData["cardID"] as? Int, let cardEnum = CardId(rawValue: cardID) {
                    cardIds.append(cardEnum)
                }
            }
            completion(cardIds)
        }
    }
    
    /**
     Handの取得（リアルタイム）
     */
    func observeHandInfo(from roomID: String, gameID: String, playerIndex: String, completion: @escaping ([CardId]?) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        let playerRef = gameInfoRef.child("players").child(playerIndex)
        playerRef.observe(.value) { snapshot in
            guard let playerDict = snapshot.value as? [String: Any],
                  let playerHandDicts = playerDict["hand"] as? [[String: Any]]
            else {
                completion(nil)
                return
            }
            var playerHand: [CardId] = []
            for cardDict in playerHandDicts {
                if let cardID = cardDict["cardID"] as? Int, let card = CardId(rawValue: cardID) {
                    playerHand.append(card)
                }
            }
            completion(playerHand)
        }
    }
    
    /**
     GamePhaseの取得（リアルタイム）
     */
    func observeGamePhase(roomID: String, gameID: String, completion: @escaping (GamePhase?) -> Void) {
        let ref = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID).child("gamePhase")
        ref.observe(.value) { (snapshot) in
            guard let gamePhaseValue = snapshot.value as? Int else {
                print("Could not cast snapshot value to an integer")
                return
            }

            guard let gamePhase = GamePhase(rawValue: gamePhaseValue) else {
                print("Invalid gamePhase value: \(gamePhaseValue)")
                return
            }

            // gamePhase is the updated value.
            print("Updated gamePhase: \(gamePhase)")
            completion(gamePhase)
        }
    }
    
    /**
     currentPlayerIndexの取得（リアルタイム）
     */
    func getCurrentPlayerIndex(roomID: String, gameID: String, completion: @escaping (Int?) -> Void) {
        let ref = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID).child("currentPlayerIndex")
        ref.observe(.value) { (snapshot) in
            guard let currentplayerIndex = snapshot.value as? Int else {
                print("Could not cast snapshot value to an integer")
                return
            }
            completion(currentplayerIndex)
        }
    }
    
    /**
     GamePhase変更
     */
    func updateGamePhase(roomID: String, gameID: String, gamePhase: GamePhase, completion: @escaping (Bool) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        gameInfoRef.child("gamePhase").setValue(gamePhase.rawValue) { error, _ in
            if let error = error {
                print("Failed to update room status: \(error.localizedDescription)")
            } else {
                completion(true)
            }
        }
    }
    
    /**
     currentPlayerIndexのセット
     */
    func setCurrentPlayerIndex(roomID: String, gameID: String, currentplayerIndex: Int, completion: @escaping (Bool) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        gameInfoRef.child("currentPlayerIndex").setValue(currentplayerIndex) { error, _ in
            if let error = error {
                print("Failed to update room status: \(error.localizedDescription)")
            } else {
                completion(true)
            }
        }
    }

    
    /**
     初期カードめくり
     */
    func moveTopCardToTable(roomID: String, gameID: String, completion: @escaping (Bool) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        gameInfoRef.observeSingleEvent(of: .value) { snapshot in
            guard var gameInfo = snapshot.value as? [String: Any],
                  var deck = gameInfo["deck"] as? [[String: Int]]
            else {
                completion(false)
                return
            }
            // デッキからカードを引く
            let drawnCard = deck.removeLast()
            // デッキの更新
            gameInfo["deck"] = deck
            // テーブルにカードを追加
            var table = gameInfo["table"] as? [[String: Int]] ?? []
            table.append(drawnCard)
            gameInfo["table"] = table
            // データの更新
            gameInfoRef.setValue(gameInfo) { error, _ in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }

    /**
     Draw
     */
    func drawCard(roomID: String, playerID: String, gameID: String, completion: @escaping (Bool) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        gameInfoRef.observeSingleEvent(of: .value) { snapshot in
            guard var gameInfo = snapshot.value as? [String: Any],
                  var deck = gameInfo["deck"] as? [[String: Int]],
                  var players = gameInfo["players"] as? [[String: Any]]
            else {
                completion(false)
                return
            }
            // デッキからカードを引く
            let drawnCard = deck.removeLast()
            // デッキの更新
            gameInfo["deck"] = deck
            // プレイヤーの手札にカードを追加
            for (index, player) in players.enumerated() {
                if let id = player["id"] as? String, id == playerID {
                    var hand = player["hand"] as? [[String: Int]] ?? []
                    hand.append(drawnCard)
                    players[index]["hand"] = hand
                    break
                }
            }
            gameInfo["players"] = players
            // データの更新
            gameInfoRef.setValue(gameInfo) { error, _ in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    func convertToDictArray(cards: [N_Card]) -> [[String: Int]] {
        return cards.map { card in
            ["cardID": card.id.rawValue]
            
        }
    }

    /**
     PlayCards
     */
    func playCards(roomID: String, playerID: String, gameID: String, baseselectedCards: [N_Card], completion: @escaping (Bool) -> Void) {
        let selectedCards = convertToDictArray(cards: baseselectedCards)
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        gameInfoRef.observeSingleEvent(of: .value) { snapshot in
            guard var gameInfo = snapshot.value as? [String: Any],
                  var players = gameInfo["players"] as? [[String: Any]]
            else {
                completion(false)
                return
            }
            // プレイヤーの手札からカードを出す
            for (index, player) in players.enumerated() {
                if let id = player["id"] as? String, id == playerID {
                    var hand = player["hand"] as? [[String: Int]] ?? []
                    
                    for selectedCard in selectedCards {
                        if let cardIndex = hand.firstIndex(where: { $0 == selectedCard }) {
                            hand.remove(at: cardIndex)
                        } else {
                            print("Selected card not found in hand!")
                            completion(false)
                            return
                        }
                    }
                    players[index]["hand"] = hand
                    break
                }
            }
            
            // テーブルにカードを追加
            var table = gameInfo["table"] as? [[String: Int]] ?? []
            table.append(contentsOf: selectedCards)
            gameInfo["table"] = table
            
            // プレイヤーのデータを更新
            gameInfo["players"] = players
            
            // データの更新
            gameInfoRef.setValue(gameInfo) { error, _ in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    //-------------------------------ROOM-------------------------------
    //-------------------------------ROOM-------------------------------
    //-------------------------------ROOM-------------------------------

    /**
     ルーム作成
     */
    func createRoom(roomName: String, creator: Player, completion: @escaping (String?) -> Void) {
                
        let myAccountJSON = cjm.playerJSON(player: creator)
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

    struct GameBase {
        let players: [Player_f]
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
//            print(room)
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
                    // stateの設定
                    self.retrieveGameInfo(forRoom: roomID) { gameBase in
                        appState.gameUIState.players = gameBase!.players
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        // 遷移
                        Router().pushBasePage(pageId: .dtnkMain_friends)
                    }
                }
            }
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

// パラメータ調整
struct GameBase {
    let players: [Player]
}

struct GameState {
    let gameID: String
    let deck: [CardId]
}
