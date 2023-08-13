//
//  RoomFireBaseMng.swift
//  DTNK_shinoda01
//
//  Created by Takuma Shinoda on 2023/08/05.
//

import SwiftUI
import Firebase
import FirebaseDatabase

class RoomFirebaseManager {
    
    static let shared = RoomFirebaseManager()
    private let database = Database.database()
    // json変換用
    let cjm = ConvertJSONMng()
    
    
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

}
