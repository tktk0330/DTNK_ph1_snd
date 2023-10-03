/**
 新Bot対戦画面
 */

import SwiftUI

struct GameBotView: View {
    
    @StateObject var game: GameUIState = appState.gameUIState
    var myside: Int = 0
    
    var body: some View {
        GeometryReader { geo in
            
            TargetPlayerPositionView(game: game, geo: geo)
            CardPoolView(game: game, myside: myside, geo: geo, selectedCards: $game.players[myside].selectedCards)
            ScoreBarView(game: game, myside: myside, geo: geo)
            OtherPlayerIconsView(game: game, myside: myside, geo: geo)
            PlayerCardsCountView(game: game, myside: myside, geo: geo)
            GameButtonView(game: game, myside: myside, geo: geo)
            Header(game: game, geo: geo)
            GameEventView(game: game, myside: myside, geo: geo)
            Group {
                // レートアップアナウンス
                if game.rateUpCard != nil {
                    RateUpAnnounce(cardImage: game.rateUpCard!) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            GameBotController().firstCard()
                        }
                    }
                    .id(game.rateUpCard)
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height / 2)
                }
                // revenge
                if !game.revengerIndex.isEmpty {
                    RevengeAnnounce() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            GameBotController().revenge()
                        }
                    }
                    .id(game.revengerIndex)
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height / 2)
                }
                // デッキ再生成
                if game.regenerationDeckFlg == 1 {
                    RegenerationDeck() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            game.regenerationDeckFlg = 0
                        }
                    }
                    .id(game.regenerationDeckFlg)
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height / 2)
                }
                // スコア
                if game.gamePhase == .decisionrate {
                    DecisionScoreView()
                }

            }
            GameHelpGroupView(game: game, geo: geo)

        }
        .gameBackground()
        .onAppear {
            game.myside = self.myside
            game.gamePhase = .dealcard
            GameMainController().initFunction()
        }
    }
}
