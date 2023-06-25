
import Foundation
import SwiftUI

struct ScoreContoroller {
    

    func onTapScoreOK() {
        print(appState.gameUiState.gamenum)
        print(appState.gameUiState.targetgamenum)
        if appState.gameUiState.gamenum < appState.gameUiState.targetgamenum {
        // TODO: 次のゲームへの処理を行う
        appState.resultState = nil
        let duration: Double = 1.0
            DispatchQueue.main.async {
                withAnimation(.easeOut(duration: duration)) {
                    // 初期化処理
                    appState.gameUiState.gamenum += 1
                    appState.gameUiState.gamePhase = .dealcard
                    appState.gameUiState.gamePhase = .gamenum
                    appState.gameUiState.currentPlayerIndex = 99
                    appState.gameUiState.decisionCards = []
                    appState.gameUiState.lastPlayedCards = []
                    appState.gameUiState.isfirstplayer = false
                    appState.gameUiState.gamedtnk = false
                    appState.gameUiState.magunigication = 1
                    appState.gameUiState.decisionnum = 1
                    appState.gameUiState.gameScore = 1
                    appState.gameUiState.winers = []
                    appState.gameUiState.loosers = []
                    // 手札のリセット
                    appState.gameUiState.players.forEach { player in
                        player.hand.removeAll()
                    }
                    // 山札リセット
                    appState.gameUiState.deck.cards.removeAll()
                    appState.gameUiState.deck =  appState.gameUiState.deck.reset()
                    // 場リセット
                    appState.gameUiState.table.removeAll()
                    // start game
                    appState.gameUiState.dealCards(completion: { isCompleted in
                        if isCompleted {
                            appState.gameUiState.gamePhase = .countdown
                        }
                    })
                }
            }
        } else {
            self.finishGame()
        }
    }
    
    func finishGame() {
        Router().pushBasePage(pageId: .gameresult)
    }
}
