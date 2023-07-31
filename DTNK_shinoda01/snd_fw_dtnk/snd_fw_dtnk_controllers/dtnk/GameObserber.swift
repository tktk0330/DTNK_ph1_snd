



import Foundation

struct GameObserber {
    
    let fbm = FirebaseManager()

    /**
     初期カード配布
     */
    func dealFirst(roomID: String, players: [Player_f], gameID: String, completion: @escaping (Bool) -> Void) {
        dealToPlayers(roomID: roomID, players: players, gameID: gameID, index: 0, completion: completion)
    }

    private func dealToPlayers(roomID: String, players: [Player_f], gameID: String, index: Int, completion: @escaping (Bool) -> Void) {
        // All players dealt with, return true
        if index >= players.count {
            completion(true)
            return
        }
        
        let player = players[index]

        // Deal 2 cards
        dealCards(roomID: roomID, player: player, gameID: gameID, remaining: 2) { (success) in
            if success {
                // After the current player is done, deal to the next player
                self.dealToPlayers(roomID: roomID, players: players, gameID: gameID, index: index + 1, completion: completion)
            } else {
                // If there was an error dealing cards, call completion with false
                completion(false)
            }
        }
    }

    private func dealCards(roomID: String, player: Player_f, gameID: String, remaining: Int, completion: @escaping (Bool) -> Void) {
        // If no more cards to deal, return true
        if remaining <= 0 {
            completion(true)
            return
        }

        fbm.drawCard(roomID: roomID, playerID: player.id, gameID: gameID) { bool in
            if bool {
                // Once drawCard is done, deal the next card
                self.dealCards(roomID: roomID, player: player, gameID: gameID, remaining: remaining - 1, completion: completion)
            } else {
                // If there was an error in drawCard, call completion with false
                completion(false)
            }
        }
    }
    
    
}
