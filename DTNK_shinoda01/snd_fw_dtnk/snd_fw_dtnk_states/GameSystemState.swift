/**
マッチングして入手つする際のレスポンス?
 
 */

import SwiftUI

class GameSystemState: ObservableObject {
    var gameState: GameLogicState
    var players: [Player]
    
    
    init(
        gameState: GameLogicState,
        players: [Player]) {
            self.gameState = gameState
            self.players = players
        }
}

