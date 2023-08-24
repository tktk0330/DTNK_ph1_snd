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
        default:
            break

        }
    }
}

