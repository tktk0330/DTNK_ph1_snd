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
                
                // Challenge関連
                // 開始
                if game.gamePhase == .startChallenge {
                    ChallengeActionAnnounce(text: "Challenge ZONE\nStart") {
                        // チャレンジへ
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            game.gamePhase = .challenge
                        }
                    }
                    .position(x: Constants.scrWidth * 0.50, y:  geo.size.height / 2)
                }
                // Challenger
                if game.showChallengeAnnounce == true {
                    ChallengeActionAnnounce(text: game.announceText) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            game.showChallengeAnnounce = false
                        }
                    }
                    .position(x: Constants.scrWidth * 0.50, y:  geo.size.height / 2)
                }
                // Over
                
                // どてんこ返し(in challenge)
                if game.revengerIndex != nil {
                    GifViewCloser(gifName: GifName.Game.revengeInChallenge.rawValue) {
                        GameBotController().revenge()
                    }
                    .scaleEffect(0.7)
                    .position(x: Constants.scrWidth * 0.50, y:  geo.size.height / 2)
                }
                // 終了
                if game.gamePhase == .endChallenge  {
                    ChallengeActionAnnounce(text: "Challenge ZONE\nEnd") {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            // 最終結果へ
                            game.gamePhase = .decisionrate_pre
                        }
                    }
                    .position(x: Constants.scrWidth * 0.50, y:  geo.size.height / 2)
                }
                // 誰もチャレンジしない
                if game.gamePhase == .noChallenge  {
                    ChallengeActionAnnounce(text: "No\nChallenge ZONE", textColor: .dtnkLightRed) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            // 最終結果へ
                            game.gamePhase = .decisionrate_pre
                        }
                    }
                    .position(x: Constants.scrWidth * 0.50, y:  geo.size.height / 2)
                }
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
