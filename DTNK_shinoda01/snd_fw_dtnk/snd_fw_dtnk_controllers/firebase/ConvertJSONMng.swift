/**
 JSON形式に変換する
 
 */

import SwiftUI

struct ConvertJSONMng {

    // ルーム作成の際
    func playerJSON(player: Player) -> [String: Any] {
        let PlayerJSON: [String: Any] = [
            "id": player.id,
            "side": player.side,
            "name": player.name,
            "icon_url": player.icon_url
        ]
        return PlayerJSON
    }
    
    // ゲーム登録の際
    func playersJSON(players: [Player]) -> [[String: Any]] {
        var playersJSON: [[String: Any]] = []
        for player in players {
            let playerJSON: [String: Any] = [
                "id": player.id,
                "side": player.side,
                "name": player.name,
                "icon_url": player.icon_url,
                "hand": player.hand,
                "score": player.score,
                "selectedCards": player.selectedCards
            ]
            playersJSON.append(playerJSON)
        }
        return playersJSON
    }
    
    func player_fJSON(player: Player_f) -> [String: Any] {
        let playerJSON: [String: Any] = [
            "id": player.id,
            "side": player.side,
            "name": player.name,
            "icon_url": player.icon_url,
            "score": player.score,
            "rank": player.rank,
            "selectedCards": player.selectedCards
        ]
        return playerJSON
    }
    
    func players_fJSON(players: [Player_f]) -> [[String: Any]] {
        var playersJSON: [[String: Any]] = []
        for player in players {
            
            let playerJSON: [String: Any] = [
                "id": player.id,
                "side": player.side,
                "name": player.name,
                "icon_url": player.icon_url,
                //                "hand": player.hand,
                "score": player.score,
                "rank": player.rank,
                "selectedCards": player.selectedCards
            ]
            playersJSON.append(playerJSON)
        }
        return playersJSON
    }
}
