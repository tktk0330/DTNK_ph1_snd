/**
 Gameに関する処理
 */

import SwiftUI

struct GameFriendEventController {
    
    let fbm = FirebaseManager()
    let fbms = FirebaseManager.shared
    // いるかどうか
    var game: GameUIState = appState.gameUIState
    
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
        let cardIds: [CardId] = selectCrads.map { $0.id }
        
        guard checkTurn(myside: passPayerIndex) else {
            return
        }
        if game.table.isEmpty {
            log("テーブルが空です")
            return
        }
        if selectCrads.isEmpty {
            log("\(passPayerIndex): カードを選択してください")
            return
        }
        if GameBotController().checkMultipleCards(table: game.table.last!, playCard: cardIds) {
            fbms.playCards(playerIndex: passPayerIndex, playerID: playerID, baseselectedCards: selectCrads) { result in
                if result {
                    log("\(passPayerIndex): Play")
                    pass(passPayerIndex: passPayerIndex, playersCount: 4)
                    if game.gamePhase == .gamefirst || game.gamePhase == .gamefirst_sub {
                        fbms.setGamePhase(gamePhase: .main) { result in }
                    }
                    completion(true)
                }
            }
        } else {
            log("\(passPayerIndex): それらのカードは出せないです")
            return
        }
    }

    /**
     パス
     */
    func initPass(Index: Int) {
        // 初期フェーズの時(一致番最初)
        if game.firstAnswers[Index] == .initial && game.gamePhase == .gamefirst {
            game.gamePhase = .waiting
            fbms.setFirstAnswers(index: Index, answer: .pass) { result in }
            return;
        } else {
            log("\(Index): 初期回答待機中")
        }
    }
    
    func pass(passPayerIndex: Int, playersCount: Int) {
        guard checkTurn(myside: passPayerIndex) else {
            return
        }
        // 通常時
        if game.players[passPayerIndex].hand.count < Constants.burstCount {
            let nextPlayerIndex = (passPayerIndex + 1) % playersCount
            // fbに登録
            fbms.setCurrentPlayerIndex(currentplayerIndex: nextPlayerIndex) { result in
                if result {
                    game.turnFlg = 0
                }
            }
        }
        // Burstするとき
        if (game.gamePhase == .decisionrate_pre || game.gamePhase == .main) && game.players[passPayerIndex].hand.count == Constants.burstCount {
            
            fbms.setGamePhase(gamePhase: .burst) { result in }
            fbms.setBurstPlayerIndex(burstPlayerIndex: passPayerIndex) { result in }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                fbms.setGamePhase(gamePhase: .decisionrate_pre) { result in }
            }
        }
    }
    
    /**
     どてんこ時処理
     */
    func playerDtnk(Index: Int, dtnkPlayer: Player_f) {
        if !( game.gamePhase == .gamefirst || game.gamePhase == .gamefirst_sub || game.gamePhase == .main) {
            log("\(Index): まだどてんこできないです")
            return
        }
        dtnk(Index: Index, dtnkPlayer: dtnkPlayer)
    }
    
    func dtnk(Index: Int, dtnkPlayer: Player_f) {
        // dtnkは１ゲーム１人１回
        if game.dtnkFlg != 1 {
            
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
            // フロント初期化
            setGame()
        default:
            break
        }
    }
    
    /**
     次ゲーム処理
     */
    func setGame() {
        // フロント初期化アイテム
        game.counter = false     // カウンター
        game.startFlag = false   // startBtn
        game.AnnounceFlg = false // 実行中 true 非表示中　false
        game.turnFlg = 0         // 0: canDraw 1: canPass
        game.dtnkFlg = 0         // 0: no 1: dtnked
    }
}

