/**
 ゲームのメイン画面
 
 */

import SwiftUI

struct GameMain: View {
    @StateObject var game: GameUiState = appState.gameUiState
    @Namespace private var namespace
    
    let speed = 0.3
    let playerPositions: [CGPoint] = [
        CGPoint(x: UIScreen.main.bounds.width / 2, y: 0.68),
        CGPoint(x: UIScreen.main.bounds.width * 0.10, y: 0.35),
        CGPoint(x: UIScreen.main.bounds.width / 2, y: 0.20),
        CGPoint(x: UIScreen.main.bounds.width * 0.90, y: 0.35)
    ]

    var body: some View {
        GeometryReader { geo in
            if game.gamePhaseOrigine == .playing  {
                ZStack{
                    Group() {
                        
                        if game.currentPlayerIndex != 99 && ( game.gamePhase == .gamefirst_sub || game.gamePhase == .gamefirst || game.gamePhase == .main ) {
                            TargetPlayerView()
                                .position(x: playerPositions[game.currentPlayerIndex].x, y: geo.size.height * playerPositions[game.currentPlayerIndex].y)
                                .animation(.easeInOut(duration: 0.5), value: game.currentPlayerIndex)
                        }
                        
                        //Field
                        FieldView(deck: $game.deck.cards, table: $game.table, namespace: namespace)
                            .scaleEffect( (game.gamePhase == .challenge) ? 1.5 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: game.gamePhase == .challenge)

                        // Player Hand
                        PlayerHand(game: game, namespace: namespace)
                            .scaleEffect( (game.gamePhase == .challenge) ? 1.5 : 1.2)
                            .animation(.easeInOut(duration: speed), value: game.gamePhase == .challenge)
                        
                        // Bot Hand
                        Bot(game: game, namespace: namespace)
                            .animation(.easeInOut(duration: speed), value: game.gamePhase == .challenge)
                    }
                    
                    // Icons 最上位要素スコア原因不明反映不可 ダミーで暫定的
                    Group{
                        // dummy
                        BotIconView(player: game.players[0])
                            .position(x: -200, y: -100)
                        
                        BotIconView(player: game.players[2])
                            .position(x: (game.gamePhase != .challenge) ? UIScreen.main.bounds.width * 0.50 : -200, y:  geo.size.height * 0.30)
                        
                        BotIconView(player: game.players[1])
                            .position(x: (game.gamePhase != .challenge) ? UIScreen.main.bounds.width * 0.40 : -200, y:  geo.size.height * 0.38)
                        
                        BotIconView(player: game.players[3])
                            .position(x: (game.gamePhase != .challenge) ? UIScreen.main.bounds.width * 0.60 : -200, y:  geo.size.height * 0.38)
                        
                        BotIconView(player: game.players[0])
                            .position(x: (game.gamePhase != .challenge) ? UIScreen.main.bounds.width * 0.16 : -200, y:  geo.size.height * 0.77)
                    }
                    .transition(.slide)
                    .animation(.easeInOut(duration: speed), value: game.gamePhase == .challenge)

                    Group {
                        if game.dtnkJudge(playerAllCards: game.players[0].hand, table: game.table) == true{
                            // Dtnk
                            Button(action: {
                                game.dtnkevent(Index: 0)
                            }) {
                                Text(game.isfirstplayer ? "DOTENKO" : "SYOTENKO")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                    .bold()
                                    .padding()
                                    .frame(width: 170, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.yellow, lineWidth: 3)
                                    )
                                    .saturation(!game.dtnkJudge(playerAllCards: game.players[0].hand, table: game.table) ? 0.0: 1.0)
                            }
                            .position(x: (game.gamePhase != .challenge) ? UIScreen.main.bounds.width / 2 : -200, y:  geo.size.height * 0.85)
                            .disabled(!game.dtnkJudge(playerAllCards: game.players[0].hand, table: game.table))
                        }
                        //action btn
                        HStack(spacing: 10){
                            Button(action: {
                                // TODO: 初期イベント処理追加
                                if game.canDraw {
                                    game.drawCard()
                                    game.canDraw = false
                                }
                            }) {
                                actionBtnView(text: "Draw")
                            }
                            .disabled(!(game.canDraw && (game.gamePhase == .main)))
                            .saturation(game.canDraw && (game.gamePhase == .main) ? 1.0: 0.0)
                            
                            Button(action: {
                                // TODO: 初期イベント処理追加
                                if game.canTurn {
                                    game.canTurn = false
                                    game.playCards(Index: 0, cards: game.players[0].selectedCards)
                                }
                            }) {
                                actionBtnView(text: "Play")
                            }
                            Button(action: {
                                // TODO: 初期イベント処理追加
                                if !game.isfirstplayer && !(game.gamePhase == .main) {
                                    game.initialAction[0] = false
                                } else {
                                    if game.canTurn {
                                        game.canTurn = false
                                        game.pass()
                                        game.botTurn(Index: 0)
                                    }
                                }
                            }) {
                                actionBtnView(text: "Pass")
                            }
                            .disabled(!(!game.canDraw || (game.gamePhase == .gamefirst)))
                            .saturation(!game.canDraw || (game.gamePhase == .gamefirst) ? 1.0: 0.0)
                            
                        }
                        // TODO: 自分のターン以外は非活性＋色変更
                        .saturation( ((game.gamePhase == .gamefirst || game.gamePhase == .main) && (game.currentPlayerIndex == 0 || game.currentPlayerIndex == 99)) ? 1.0: 0.0)
                        .disabled(!((game.gamePhase == .gamefirst || game.gamePhase == .main) && (game.currentPlayerIndex == 0 || game.currentPlayerIndex == 99)))
                        .position(x: (game.gamePhase != .challenge) ? UIScreen.main.bounds.width / 2 : -200, y:  geo.size.height * 0.93)
                    }

                    // 常時表示
                    Group{
                        // 広告用
                        Rectangle()
                            .foregroundColor(Color.white.opacity(0.3))
                            .shadow(color: .gray, radius: 10, x: 0, y: 5)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                        
                        Text("ゲームの進行状況: \(game.progress)")
                            .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                        
                        //Rate
                        RateView(gamenum: game.gamenum, rate: game.rate, magnification: game.magunigication)
                            .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.09)
                        
                        //Exit btn
                        Header(game: game)
                            .frame(width: UIScreen.main.bounds.width , height: 40)
                            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.13)
                    }
                    
                    //バースト注意
                    if  game.players[0].hand.count == 4 && game.gamePhase != .main{
                        BurstCoutionView(text: "BURST COUTION!").position(x: geo.size.width * 0.68, y: geo.size.height * 1.08)
                    }
                    
                    Group {
                        // Game number View
                        if game.gamePhase == .gamenum {
                            EffectView(gamenum: game.gamenum)
                        }
                        // CountDown View
                        if game.gamePhase == .countdown {
                            Countdown02View()
                                .scaleEffect(3.0)
                        }
                        // Decision Initial Player View
                        if game.gamePhase == .decisioninitialplayer {
                            InitialFlip(player: game.players, initialIndex: game.currentPlayerIndex)
                                .position(x: UIScreen.main.bounds.width / 2,  y:  geo.size.height / 2)
                                .transition(.move(edge: .top))
                                .animation(.default, value: game.gamePhase == .decisioninitialplayer)
                        }
                        // DTNK View
                        if game.gamePhase == .dtnk {
                            DTNKView(text: game.isfirstplayer ? "DOTENKO" : "SYOTENKO")
                        }
                        
                        // DTNK View
                        if game.gamePhase == .revenge {
                            RevengeView(text: "REVENGE")
                        }
                        
                        //BurstView
                        if game.gamePhase == .burst{
                            BurstView(text: "BURST")
                        }
                        
                                               
                        if game.gamePhase == .q_challenge && game.challengeFlag[0] == 0 {
                            CallengePopView(game: game, index: 0)
                                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
                                .transition(.move(edge: .top))
                                .animation(.default, value: game.gamePhase == .q_challenge && game.challengeFlag[0] == 0)
                        }
                        
                        if game.gamePhase == .decisionrate {
                            DecisionView(game: game, deck: $game.deck.cards)
                        }
                        if appState.resultState != nil {
                            ResultView(game: game)
                        }
                    }
                }
                // 画面表示後の処理
                .onAppear {
                    //　カードを配る
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                        game.gamePhase = .dealcard
                        game.gamePhase = .gamenum
                        game.dealCards(completion: { isCompleted in
                            if isCompleted {
                                game.progress = "start"
                                game.gamePhase = .countdown
                            }
                        })
                    }
                }
            }
        }
    }
}


