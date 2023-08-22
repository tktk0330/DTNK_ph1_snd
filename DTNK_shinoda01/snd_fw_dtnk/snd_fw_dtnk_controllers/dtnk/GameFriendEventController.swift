/**
 Gameに関する処理
 */


import SwiftUI

struct GameFriendEventController {
    
    let fbm = FirebaseManager()
    let fbms = FirebaseManager.shared
    
    /**
     自分のターンかチェックする
     */
    func checkTurn(myside: Int) -> Bool {
        guard myside == appState.gameUIState.currentPlayerIndex || appState.gameUIState.currentPlayerIndex == 99 else {
            print("not your turn!")
            return false
        }
        return true
    }
    
    /**
     どてんこできるか（自分の出したカードではないか）
     */
    func checDtnk(myside: Int) -> Bool {
        guard myside != appState.gameUIState.lastPlayerIndex || appState.gameUIState.currentPlayerIndex == 99 else {
            print("can not dtnk!")
            return false
        }
        return true
    }
    
    /**
     引く
     */
    func draw(playerID: String, playerIndex: Int) {
        guard checkTurn(myside: playerIndex) else {
            return
        }
        appState.gameUIState.turnFlg = 1

        fbms.drawCard(playerID: playerID) { result in
            if result {
                print("Draw")
            } else {
                print("draw失敗")
                appState.gameUIState.turnFlg = 0
            }
        }
    }

    /**
     出す
     */
    func play(playerID: String, selectCrads: [N_Card], passPayerIndex: Int, completion: @escaping (Bool) -> Void) {
        guard checkTurn(myside: passPayerIndex) else {
            return
        }
        fbms.playCards(playerIndex: passPayerIndex, playerID: playerID, baseselectedCards: selectCrads) { result in
            if result {
                print("Play")
                pass(passPayerIndex: passPayerIndex, playersCount: 4)
                completion(true)
            }
        }
    }

    /**
     パス
     */
    func pass(passPayerIndex: Int, playersCount: Int) {
        guard checkTurn(myside: passPayerIndex) else {
            return
        }
        
        // seletcardsを初期化
        // currentIndexを次の人に変える
        let nextPlayerIndex = (passPayerIndex + 1) % playersCount
        // fbに登録
        fbms.setCurrentPlayerIndex(currentplayerIndex: nextPlayerIndex) { result in
            if result {
                appState.gameUIState.turnFlg = 0
            }
        }
    }
    
    /**
     どてんこ時処理
     */
    func dtnk(Index: Int, dtnkPlayer: Player_f) {
        guard checDtnk(myside: Index) else {
            return
        }

        // TODO: 音バイブ
        fbms.setGamePhase(gamePhase: .dtnk) { result in }
        fbms.setDTNKInfo(Index: Index, dtnkPlayer: dtnkPlayer) { result in }
        
        // TODO: ロジック修正？
        // アニメーションが終わったら参加可否を問う
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // 可否
            fbms.setGamePhase(gamePhase: .q_challenge) { result in }
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

