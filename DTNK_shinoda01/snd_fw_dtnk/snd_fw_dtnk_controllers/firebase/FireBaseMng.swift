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
    var roomID: String = ""
    var gameID: String = ""
    func setIDs(roomID: String, gameID: String) {
        self.roomID = roomID
        self.gameID = gameID
    }

    //-------------------------------GAME-SET-AND-GET-------------------------------
    //-------------------------------GAME-SET-AND-GET-------------------------------
    //-------------------------------GAME-SET-AND-GET-------------------------------
    
    /**
     GameInfoのセット
     */
    func setGameInfo(gameInfo: GameInfoModel, roomID: String, completion: @escaping (String?) -> Void) {
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
            "currentPlayerIndex": 99,
            "challengeAnswer": Array(repeating: ChallengeAnswer.initial.rawValue, count: 4)
            // 他のプロパティも同様に追加
        ]
        database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID).setValue(gameInfoDict) { error, _ in
            if let error = error {
                print("Failed to save game info: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(gameID)
            }
        }
    }
    /**
     GameInfoの取得
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
     Deckのセット
     */
    func setDeck(deck: [CardId], completion: @escaping (Bool) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        let deckData = deck.map { card -> [String: Any] in
            return ["cardID": card.rawValue]  // Cardを辞書に変換
        }
        gameInfoRef.child("deck").setValue(deckData) { error, _ in
            if let error = error {
                print("Failed to update deck regeneration: \(error.localizedDescription)")
            } else {
                completion(true)
            }
        }
    }
    /**
     Deckの取得（リアルタイム）
     */
    func observeDeckInfo(completion: @escaping ([CardId]?) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        let deckRef = gameInfoRef.child("deck")
        deckRef.observe(.value) { snapshot in
            guard let deckDict = snapshot.value as? [[String: Any]] else {
                completion(nil)
                return
            }
            var cardIds: [CardId] = []
            for cardData in deckDict {
                if let cardID = cardData["cardID"] as? Int,
                    let cardEnum = CardId(rawValue: cardID) {
                    cardIds.append(cardEnum)
                }
            }
            completion(cardIds)
        }
    }
    
    /**
     Tableのセット
     */
    func setTable(table: [CardId], completion: @escaping (Bool) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        let tableData = table.map { card -> [String: Any] in
            return ["cardID": card.rawValue]  // Cardを辞書に変換
        }
        gameInfoRef.child("table").setValue(tableData) { error, _ in
            if let error = error {
                print("Failed to update table regeneration: \(error.localizedDescription)")
            } else {
                completion(true)
            }
        }
    }
    /**
     Tableの取得（リアルタイム）
     */
    func observeTableInfo(completion: @escaping ([CardId]?) -> Void) {
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
    func observeHandInfo(playerIndex: String, completion: @escaping ([CardId]?) -> Void) {
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
                if let cardID = cardDict["cardID"] as? Int,
                    let card = CardId(rawValue: cardID) {
                    playerHand.append(card)
                }
            }
            completion(playerHand)
        }
    }
    
    /**
     GamePhaseのセット
     */
    func setGamePhase(gamePhase: GamePhase, completion: @escaping (Bool) -> Void) {
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
     GamePhaseの取得（リアルタイム）
     */
    func observeGamePhase(completion: @escaping (GamePhase?) -> Void) {
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
            completion(gamePhase)
        }
    }
    
    /**
     DTNKInfoのセット　Index  Player
     */
    func setDTNKInfo(Index: Int, dtnkPlayer: Player_f, completion: @escaping (Bool) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        let playersJSON = cjm.player_fJSON(player: dtnkPlayer)
        let valuesToUpdate: [String: Any] = [
            "dtnkIndex": Index,
            "dtnkPlayer": playersJSON,
        ]
        gameInfoRef.updateChildValues(valuesToUpdate) { error, _ in
            if let error = error {
                print("Failed to update DTNK info: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    /**
     DTNKInfoの取得（リアルタイム） Index  Player
     */
    func observeDTNKInfo(completion: @escaping (Int?, Player_f?) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        let indexRef = gameInfoRef.child("dtnkIndex")
        let playerRef = gameInfoRef.child("dtnkPlayer")

        indexRef.observe(.value) { (snapshot) in
            guard let newindex = snapshot.value as? Int else {
                print("Could not cast snapshot value to an integer")
                return
            }

            playerRef.observeSingleEvent(of: .value) { (playerSnapshot) in
                guard let playerData = playerSnapshot.value as? [String: Any] else {
                    print("Could not cast snapshot value to dictionary")
                    completion(newindex, nil) // indexは有効ですが、Playerデータは無効な場合
                    return
                }
                
                if let id = playerData["id"] as? String,
                    let side = playerData["side"] as? Int,
                    let name = playerData["name"] as? String,  // 注意: "id"から"name"に変更しました
                    let icon_url = playerData["icon_url"] as? String {
                    
                    let newPlayer = Player_f(id: id, side: side, name: name, icon_url: icon_url)
                    completion(newindex, newPlayer)
                } else {
                    completion(newindex, nil)  // indexは有効ですが、Playerデータは無効な場合
                }
            }
        }
    }

    /**
     currentPlayerIndexのセット
     */
    func setCurrentPlayerIndex(currentplayerIndex: Int, completion: @escaping (Bool) -> Void) {
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
     currentPlayerIndexの取得（リアルタイム）
     */
    func observeCurrentPlayerIndex(completion: @escaping (Int?) -> Void) {
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
     lastPlayerIndexの取得（リアルタイム）
     */
    func observeLastPlayerIndex(completion: @escaping (Int?) -> Void) {
        let ref = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID).child("lastPlayerIndex")
        ref.observe(.value) { (snapshot) in
            guard let lastPlayerIndex = snapshot.value as? Int else {
                print("errore")
                return
            }
            completion(lastPlayerIndex)
        }
    }
    
    /**
     ChallengeAnserのセット
     */
    func setChallengeAnswer(index: Int, answer: ChallengeAnswer, completion: @escaping (Bool) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        gameInfoRef.child("challengeAnswer/\(index)").setValue(answer.rawValue) { error, _ in
            if let error = error {
                print("Failed: \(error.localizedDescription)")
            } else {
                completion(true)
            }
        }
    }
    /**
     ChallengeAnserの取得（リアルタイム）
     */
    func observeChallengeAnswer(completion: @escaping ([ChallengeAnswer?]) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        let challengeAnswerRef = gameInfoRef.child("challengeAnswer")
        challengeAnswerRef.observe(.value) { (snapshot) in
            guard let rawValues = snapshot.value as? [Int] else {
                print("Could not cast snapshot value to [Int]")
                return
            }
            let answers = rawValues.map { ChallengeAnswer(rawValue: $0) }
            completion(answers)
        }
    }

    /**
     勝者・敗者のセット
     */
    func setWinnersLosers(winners: [Player_f],  losers: [Player_f], completion: @escaping (Bool) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        let winnersData = cjm.players_fJSON(players: winners)
        let losersData = cjm.players_fJSON(players: losers)
        // winnersとlosersをセットする
        gameInfoRef.child("winners").setValue(winnersData) { (error, _) in
            if let error = error {
                print("Error saving winners: \(error.localizedDescription)")
                completion(false)
                return
            }
            gameInfoRef.child("losers").setValue(losersData) { (error, _) in
                if let error = error {
                    print("Error saving losers: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    /**
     勝者・敗者の取得（リアルタイム)
     */
    func observeWinnersLosers(completion: @escaping ([Player_f], [Player_f]) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        let winnersRef = gameInfoRef.child("winners")
        let losersRef = gameInfoRef.child("losers")

        var winners: [Player_f] = []
        var losers: [Player_f] = []

        winnersRef.observe(.value) { (winnersSnapshot) in
            guard let winnersDatas = winnersSnapshot.value as? [[String: Any]] else {
//                print("Error getting winnersRef")
                return
            }
            winners = winnersDatas.compactMap { data in
                guard let id = data["id"] as? String,
                      let side = data["side"] as? Int,
                      let name = data["name"] as? String,
                      let icon_url = data["icon_url"] as? String else {
                    return nil
                }
                return Player_f(id: id, side: side, name: name, icon_url: icon_url)
            }

            losersRef.observe(.value) { (losersSnapshot) in
                guard let losersDatas = losersSnapshot.value as? [[String: Any]] else {
                    // TODO: ここ通るけど取得はできてそう
//                    print("Error getting losersRef \(losersSnapshot)")
                    return
                }
                losers = losersDatas.compactMap { data in
                    guard let id = data["id"] as? String,
                          let side = data["side"] as? Int,
                          let name = data["name"] as? String,
                          let icon_url = data["icon_url"] as? String else {
                        return nil
                    }
                    return Player_f(id: id, side: side, name: name, icon_url: icon_url)
                }

                completion(winners, losers)
            }
        }
    }

    /**
     ResultItemのセット
     */
    func setPrepareFinalPhase(item: ResultItem, completion: @escaping (Bool) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        let decisionScoreCardsData = item.decisionScoreCards.map { card -> [String: Any] in
            return ["cardID": card.rawValue]  // Cardを辞書に変換
        }
        let winnersData = cjm.players_fJSON(players: item.winners)
        let losersData = cjm.players_fJSON(players: item.losers)
        let updateData: [String: Any] = [
            "winners": winnersData,
            "losers": losersData,
            "decisionScoreCards": decisionScoreCardsData,
            "ascendingRate": item.ascendingRate,
            "score": item.gameScore
        ]
        gameInfoRef.updateChildValues(updateData) { error, _ in
            if let error = error {
                print("Failed: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    /**
     ResultItemの取得（リアルタイム）
     */
    func observeDecisionScoreCards(completion: @escaping ([CardId]) -> Void) {
        let ref = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        let elementRef = ref.child("decisionScoreCards")
        elementRef.observe(.value) { (snapshot) in
            guard let cardsDict = snapshot.value as? [[String: Any]] else {
//                completion(nil)
                return
            }
            var decisionScoreCards: [CardId] = []
            for cardData in cardsDict {
                if let cardID = cardData["cardID"] as? Int,
                    let cardEnum = CardId(rawValue: cardID) {
                    decisionScoreCards.append(cardEnum)
                }
            }
            completion(decisionScoreCards)
        }
    }
    func observeResultItem(completion: @escaping (ResultItem?) -> Void) {
        let ref = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        ref.observe(.value) { (snapshot) in
            guard let data = snapshot.value as? [String: Any] else {
                // データの形式が期待通りでない場合、エラー処理を行います。
                return
            }
            guard let winnersDict = data["winners"] as? [[String: Any]],
                  let losersDict = data["losers"] as? [[String: Any]],
                  let decisionScoreCardsDict = data["decisionScoreCards"] as? [[String: Any]],
                  let ascendingRate = data["ascendingRate"] as? Int,
                  let gameScore = data["score"] as? Int else {
                completion(nil)
                return
            }
            var winners: [Player_f] = []
            var losers: [Player_f] = []

            winners = winnersDict.compactMap { data in
                guard let id = data["id"] as? String,
                      let side = data["side"] as? Int,
                      let name = data["name"] as? String,
                      let icon_url = data["icon_url"] as? String else {
                    return nil
                }
                return Player_f(id: id, side: side, name: name, icon_url: icon_url)
            }
            losers = losersDict.compactMap { data in
                guard let id = data["id"] as? String,
                      let side = data["side"] as? Int,
                      let name = data["name"] as? String,
                      let icon_url = data["icon_url"] as? String else {
                    return nil
                }
                return Player_f(id: id, side: side, name: name, icon_url: icon_url)
            }
            var decisionScoreCards: [CardId] = []
            for cardData in decisionScoreCardsDict {
                if let cardID = cardData["cardID"] as? Int,
                    let cardEnum = CardId(rawValue: cardID) {
                    decisionScoreCards.append(cardEnum)
                }
            }
            
            let result = ResultItem(winners: winners, losers: losers, decisionScoreCards: decisionScoreCards, ascendingRate: ascendingRate, gameScore: gameScore)
            completion(result)
        }
    }

    //-------------------------------GAME-ACTION-------------------------------
    //-------------------------------GAME-ACTION-------------------------------
    //-------------------------------GAME-ACTION-------------------------------
    /**
     初期カードめくり
     */
    func moveTopCardToTable(completion: @escaping (Int?) -> Void) {
        let gameInfoRef = database.reference().child("rooms").child(roomID).child("gameInfo").child(gameID)
        gameInfoRef.observeSingleEvent(of: .value) { snapshot in
            guard var gameInfo = snapshot.value as? [String: Any],
                  var deck = gameInfo["deck"] as? [[String: Int]]
            else {
                completion(nil)
                return
            }
            // デッキからカードを引く
            let drawnCard = deck.removeLast()
            let drawnCardValue = drawnCard.values.first
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
                    completion(nil)
                } else {
                    completion(drawnCardValue)
                }
            }
        }
    }

    /**
     Draw
     */
    func drawCard(playerID: String, completion: @escaping (Bool) -> Void) {
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
    func playCards(playerIndex: Int, playerID: String, baseselectedCards: [N_Card], completion: @escaping (Bool) -> Void) {
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
            // カードを最後に出した人を更新
            gameInfo["lastPlayerIndex"] = playerIndex
            
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
            "hostID": creator.id,
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

// TODO: 整理
// パラメータ調整
struct GameBase {
    let players: [Player]
}

struct GameState {
    let gameID: String
    let deck: [CardId]
}
