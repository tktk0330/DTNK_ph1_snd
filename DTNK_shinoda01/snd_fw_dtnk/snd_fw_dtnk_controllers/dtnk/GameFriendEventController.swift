/**
 Gameに関する処理
 */


import SwiftUI

struct GameFriendEventController {
    
    let fbm = FirebaseManager()
    let fbms = FirebaseManager.shared
    
    func play(playerID: String, selectCrads: [N_Card], passPayerIndex: Int, completion: @escaping (Bool) -> Void) {
        fbms.playCards(playerIndex: passPayerIndex, playerID: playerID, baseselectedCards: selectCrads) { result in
            if result {
                print("Play")
                pass(passPayerIndex: passPayerIndex, playersCount: 4)
                completion(true)
            }
        }
    }

    func pass(passPayerIndex: Int, playersCount: Int) {
        
        // seletcardsを初期化
        // currentIndexを次の人に変える
        let nextPlayerIndex = (passPayerIndex + 1) % playersCount
        // fbに登録
        fbms.setCurrentPlayerIndex(currentplayerIndex: nextPlayerIndex) { result in
        }
    }
    
    func dtnk(Index: Int, dtnkPlayer: Player_f) {
        // 音　バイブ

        fbms.setDTNKInfo(Index: Index, dtnkPlayer: dtnkPlayer) { result in
            if result {
                // fbに登録
                fbms.setGamePhase(gamePhase: .dtnk) { result in
                }
            }
        }
        // アニメーションが終わったら参加可否を問う
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // 可否
            fbms.setGamePhase(gamePhase: .q_challenge) { result in
            }
        }
    }
    
    /**
     challengeするかしないかを報告
     */
    func moveChallenge(index: Int, ans: ChallengeAnswer) {
        fbms.setChallengeAnswer(index: index, answer: ans) { result in }
    }
    /**
     準備ができているかを報告
     */
    func moveNextGame(index: Int, ans: NextGameAnnouns) {
        fbms.setNextGameAnnouns(index: index, answer: ans) { result in}
    }
    
    /**
     次の画面へ
     */
    func onTapOKButton(gamePhase: GamePhase) {
        switch gamePhase {
        case .result:
            // スコア確定→途中結果
            appState.gameUIState.gamePhase = gamePhase
        case .waiting:
            // 途中結果→新ゲーム
            appState.gameUIState.gamePhase = gamePhase
//            setGame()
        default:
            break

        }
    }
    
    func setGame() {
        // 初期化処理
        appState.gameUIState.gamenum += 1
        appState.gameUIState.gamePhase = .dealcard
        appState.gameUIState.currentPlayerIndex = 99
        appState.gameUIState.lastPlayerIndex = 99
        appState.gameUIState.dtnkPlayer = nil
        appState.gameUIState.dtnkPlayerIndex = 99
        appState.gameUIState.challengeAnswers = []
        appState.gameUIState.winners = []
        appState.gameUIState.losers = []
        appState.gameUIState.decisionScoreCards = []
        appState.gameUIState.ascendingRate = 1
        appState.gameUIState.gameScore = 1
        appState.gameUIState.counter = false
        // 山札リセット
        appState.gameUIState.deck.removeAll()
        let deck = GameRule.initialDeck.shuffled
        // 場リセット
        appState.gameUIState.table.removeAll()
        // 手札リセット
        appState.gameUIState.players.forEach { player in
            player.hand.removeAll()
        }
        
    }
}

