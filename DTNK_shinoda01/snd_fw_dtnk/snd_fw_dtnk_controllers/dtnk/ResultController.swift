
import SwiftUI

struct ResultController {
    
//    @ObservedObject var game = GameUiState()
    @StateObject var game: GameUiState = appState.gameUiState


    
    // ゲーム終了時諸々精算
    func endEvent(lastdeck: Card, winners: [Player], loosers: [Player], rate: Int, magunigication: Int){

        //　ポイント
        let score = rate * magunigication * lastdeck.cardid.number()
        
        if winners.count == 1 && loosers.count == 1 {
            // 普通のどてんこの場合
            //　勝者
            let winner = winners[0]
            winner.score += score
            //　敗者
            let looser = loosers[0]
            looser.score -= score
        } else {
            // ショテンコ　バーストの場合
            //　勝者
            for i in 0..<winners.count{
                winners[i].score += score
            }
            //　敗者
            for i in 0..<loosers.count{
                loosers[i].score -= score
            }
        }
    }
    
    
    
}

