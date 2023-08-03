


import SwiftUI

struct GameFriendEventController {
    
    let fbm = FirebaseManager()

    
    func pass(passPayerIndex: Int, playersCount: Int) {
        
        // seletcardsを初期化
        // currentIndexを次の人に変える
        let nextPlayerIndex = (passPayerIndex + 1) % playersCount
        // fbに登録
        fbm.setCurrentPlayerIndex(
            roomID: appState.room.roomData.roomID,
            gameID: appState.gameUIState.gameID,
            currentplayerIndex: nextPlayerIndex) { result in
        }
    }
}

