/**
 新Bot対戦画面
 */

import SwiftUI

struct GameBotView: View {
    @StateObject var game: GameUIState = appState.gameUIState
    var myside: Int = 0
    
    var body: some View {
        GeometryReader { geo in
            // ForcusAnimation
            if game.currentPlayerIndex != 99 && (game.gamePhase == .main) {
                TargetPlayerView()
                    .position(x: TargetPlayerView().focusPosition(side: game.currentPlayerIndex).x,
                              y: geo.size.height * TargetPlayerView().focusPosition(side: game.currentPlayerIndex).y)
                    .animation(.easeInOut(duration: 0.5), value: game.currentPlayerIndex)
            }
            
            // Card Pool
            HStack() {
                ZStack {
                    ForEach(Array(game.cardUI.enumerated()), id: \.1.id) { index, card in
                        N_CardView(card: card, location: card.location, selectedCards: $game.players[myside].selectedCards)
                            .animation(.easeInOut(duration: 0.3))
                    }
                }
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
            
            
            // ScoreBar
            Group {
                Text(String(game.players[myside].score))
                    .modifier(PlayerScoreModifier())
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.58)
                
                Text(String(game.players[(myside + 1) % game.players.count].score))
                    .modifier(PlayerScoreModifier())
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.60)
                    .rotationEffect(Angle(degrees: 90))
                
                Text(String(game.players[(myside + 2) % game.players.count].score))
                    .modifier(PlayerScoreModifier())
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.42)
                                    
                Text(String(game.players[(myside + 3) % game.players.count].score))
                    .modifier(PlayerScoreModifier())
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.60)
                    .rotationEffect(Angle(degrees: -90))
            }
            
            // Btn
            Group {
                HStack(spacing: 15) {
                    
                    if game.turnFlg == 0 {
                        Button(action: {
                            GameBotController().drawCard(Index: myside)
                        }) {
                            Btnaction(btnText: "引く", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightYellow)
                        }
                    } else {
                        Button(action: {
                            GameBotController().pass(Index: myside)
                        }) {
                            Btnaction(btnText: "パス", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightBlue)
                        }
                    }
                                        
                    // testようにボタンとして動かしておく
                    Button(action: {
                        // dtnk
                        GameBotController().dtnk(Index: myside)
                    }) {
                        // icon
                        // TODO: 磨き上げ
                        Image(game.players[myside].icon_url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60)
                            .cornerRadius(10)
                            .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
                    }
                    
                    Button(action: {
                        let selectedCards: [N_Card] = game.players[myside].selectedCards
                        let cardIds: [CardId] = selectedCards.map { $0.id }
                        GameBotController().playCards(Index: myside, cards: cardIds)
                    }) {
                        Btnaction(btnText: "出す", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightRed)
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.9)
            }

            
            
            Group {
                // 広告用
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.casinoGreen)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                
                // Rate
                RateView(gamenum: game.gameNum, rate: game.initialRate, magnification: game.ascendingRate)
                    .background(Color.casinoGreen)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.09)

            }
            Group {
                // ゲーム数アナウンス
                if game.gamePhase == .dealcard {
                    GmaeNumAnnounce(gameNum: game.gameNum, gameTarget: game.gameTarget)
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height / 2)
                }

                // 開始ボタン
                if game.startFlag && !game.AnnounceFlg {
                    Button(action: {
                        game.startFlag = false
                        game.gamePhase = .countdown

                    }) {
                        Text("Start")
                            .font(.custom(FontName.font01, size: 30))
                    }
                    .buttonStyle(ShadowButtonStyle())
                    .frame(width: 100, height: 100)
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
                }
                // CountDown
                if game.gamePhase == .countdown {
                    Countdown02View()
                        .scaleEffect(2.0)
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
                }
                // 仮想View 初期カード設置
                Text("").onReceive(game.$counter) { newValue in
                    if newValue {
                        game.gamePhase = .ratefirst
                    }
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
            }
            Group {
                // DTNK View
                if game.gamePhase == .dtnk {
                    DTNKView(text: "DOTENKO")
                }
                // チャレンジ可否ポップ
                if game.gamePhase == .q_challenge {
                    ChallengePopView(Index: myside, vsInfo: game.gamevsInfo!)
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
                        .transition(.move(edge: .top))
                        .animation(.default, value: game.gamePhase == .q_challenge)
                }
                if game.gamePhase == .challenge {
                    MovingImage()
                }
                if game.gamePhase == .decisionrate {
                    DecisionScoreView()
                }

            }


        }
        .onAppear {
            game.myside = self.myside
            game.gamePhase = .dealcard
        }
    }
}
