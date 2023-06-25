/**
 中心的
 */



import Foundation
import SwiftUI

class GameEventController {

    func play(gamenum: Int, rate: Int, jorker: Int) {
        /**
         オブジェクト　接続などを設定？
         */
        
        // TODO: ゲーム設定　まとめる　場所も考える？
        appState.gameUiState.targetgamenum = gamenum
        appState.gameUiState.rate = rate
        appState.gameUiState.jorker = jorker
        // matchingへ
        appState.matching = MatchingState(seatCount: 4, message: "プレイヤーを募集しています...")
        Router().pushBasePage(pageId: .dtnkMatching)

    }
    
}

extension GameEventController {
    
    func onRecieve(announce: Int) {
        let type = announce
        switch type {
        case 1:
            print("")
        default:
            // test
//            ScoreContoroller().startXXX(scoreList: <#T##[GameScore]#>)
            print("")
        }
    }
}

