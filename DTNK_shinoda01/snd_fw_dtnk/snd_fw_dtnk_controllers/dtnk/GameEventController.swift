/**
 中心的
 */

import Foundation
import SwiftUI

class BattleSelectController {
    
    func onTapPlay(gamenum: Int, rate: Int, jorker: Int)  {
        let eventController = GameEventController()
        eventController.play(gamenum: gamenum, rate: rate, jorker: jorker)
    }
}

struct GameEventController {
    
    /**
     vsBot　マッチングに進む
     */
    func play(gamenum: Int, rate: Int, jorker: Int) {
        // TODO: ゲーム設定　まとめる　場所も考える？
        appState.gameUIState.gameTarget = gamenum
        appState.gameUIState.initialRate = rate
        appState.gameUIState.jorker = jorker
        // Matchingへ
        moveMatchingView(vsInfo: 01)
    }
    
    /**
     vsFriend　マッチングに進む
     */
    func moveMatchingView(vsInfo: Int) {
        // Matchingへ
        appState.matching = MatchingState(seatCount: 4, message: "プレイヤーを募集しています...", vsInfo: vsInfo)
        Router().pushBasePage(pageId: .dtnkMatching)
    }
}
