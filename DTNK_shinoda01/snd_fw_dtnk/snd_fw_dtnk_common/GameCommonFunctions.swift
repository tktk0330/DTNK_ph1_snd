


import Foundation

struct GameCommonFunctions {
    
    // Idと一致するプレイヤーを返す
    func findPlayerById(players: [Player_f], id: String) -> Player_f? {
        return players.first(where: { $0.id == id })
    }
    
    // Idと一致するプレイヤーのsideを返す
    func findSideById(players: [Player_f], id: String) -> Int? {
        for player in players {
            if player.id == id {
                return player.side
            }
        }
        return nil
    }


}
