// GameButtonGroupView.swift

//if game.gamevsInfo == .vsBot {
//} else {
//}
//

import SwiftUI

struct GameButtonView: View {
    @ObservedObject var game: GameUIState // あなたのゲームの型に変更してください
    var myside: Int
    var geo: GeometryProxy

    var body: some View {
        Group {
            if game.gamePhase == .gamefirst || game.gamePhase == .gamefirst_sub || game.gamePhase == .main || game.gamePhase == .dtnk {
                if GameBotController().dtnkJudge(myside: myside, playerAllCards: game.players[myside].hand, table: game.table) == Constants.dtnkCode {
                    Button(action: {
                        if game.gamevsInfo == .vsBot {
                            GameBotController().playerDtnk(Index: myside)
                        } else {
                            GameFriendEventController().playerDtnk(Index: myside, dtnkPlayer: game.players[myside])
                        }
                    }) {
                        Image(ImageName.Common.dtnkBtn.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200)
                    }
                    .buttonStyle(PressBtn())
                    .onAppear{
                        VibrateMng.vibrate(type: .defaultVibration)
                        SoundMng.shared.playSound(soundName: SoundName.SE.possible_dtnk.rawValue)
                    }

                }
                if GameBotController().dtnkJudge(myside: myside, playerAllCards: game.players[myside].hand, table: game.table) == Constants.stnkCode {
                    Button(action: {
                        if game.gamevsInfo == .vsBot {
                            GameBotController().playerDtnk(Index: myside)
                        } else {
                            GameFriendEventController().playerDtnk(Index: myside, dtnkPlayer: game.players[myside])
                        }
                    }) {
                        Image(ImageName.Common.stnkBtn.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200)
                    }
                    .buttonStyle(PressBtn())
                    .onAppear{
                        VibrateMng.vibrate(type: .defaultVibration)
                        SoundMng.shared.playSound(soundName: SoundName.SE.possible_dtnk.rawValue)
                    }
                }
            }
        }
        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.80)
        
        if GameMainController().judgeChallenge(gamePase: game.gamePhase) {
            HStack(spacing: 15) {
                
                if game.gamePhase == .dealcard || game.gamePhase == .countdown || game.gamePhase == .gamefirst || game.gamePhase == .ratefirst {
                    Button(action: {
                        if game.gamevsInfo == .vsBot {
                            GameBotController().initPass(Index: myside)
                        } else {
                            GameFriendEventController().initPass(Index: myside)
                        }
                    }) {
                        Btnaction(btnText: "出せない", btnTextSize: 20, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightBlue)
                    }
                    .buttonStyle(PressBtn())
                    
                } else if game.turnFlg == 0 {
                    Button(action: {
                        SoundMng.shared.playSound(soundName: SoundName.SE.card_action.rawValue)
                        if game.gamevsInfo == .vsBot {
                            GameBotController().playerDrawCard(Index: myside)
                        } else {
                            GameFriendEventController().draw(playerID: game.players[myside].id, playerIndex: myside)
                        }
                    }) {
                        Btnaction(btnText: "引く", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightYellow)
                    }
                    .buttonStyle(PressBtn())
                    
                } else {
                    Button(action: {
                        if game.gamevsInfo == .vsBot {
                            GameBotController().pass(Index: myside)
                        } else {
                            GameFriendEventController().pass(passPayerIndex: myside, playersCount: game.players.count)
                        }
                        
                    }) {
                        Btnaction(btnText: "パス", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightBlue)
                    }
                    .buttonStyle(PressBtn())
                    
                }
                
                // MyIcon
                Button(action: {
                    // TODO: test
//                    if game.gamevsInfo == .vsBot {
//                        GameBotController().playerDtnk(Index: myside)
//                    } else {
//                        GameFriendEventController().playerDtnk(Index: myside, dtnkPlayer: game.players[myside])
//                    }
//                    game.errorMessageText = "新しいエラーメッセージ"
//                    game.showErrorMessage = true

                }) {
                    ZStack{
                        
                        IconView(iconURL: game.players[myside].icon_url, size: 60)
                            .overlay(
                                Group {
                                    if appState.gameUIState.gamePhase == .main && game.currentPlayerIndex == game.myside && game.gamevsInfo == .vsFriend {
                                        Rectangle().foregroundColor(.black).opacity(0.7)
                                    } else {
                                        Rectangle().opacity(0)
                                    }
                                }
                            )
                        
                        if appState.gameUIState.gamePhase == .main && game.currentPlayerIndex == game.myside && game.gamevsInfo == .vsFriend {
                            // ターンカウントダウン
                            CountdownView()
                                .frame(width: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        if game.dtnkPlayerIndex == game.myside {
                            Text("DOTENKO")
                                .font(.custom(FontName.font01, size: 12))
                                .foregroundColor(Color.dtnkLightRed)
                                .frame(width: 80, height: 20)
                                .background(Color.black.opacity(0.70))
                                .offset(y: -30)
                        } else if game.lastPlayerIndex == game.myside && game.dtnkPlayer != nil {
                            Text("LOSER!?")
                                .font(.custom(FontName.font01, size: 12))
                                .foregroundColor(Color.dtnkLightBlue)
                                .frame(width: 80, height: 20)
                                .background(Color.black.opacity(0.70))
                                .offset(y: -30)
                        }
                    }
                }
                .frame(width: 80)
                
                Button(action: {
                    SoundMng.shared.playSound(soundName: SoundName.SE.card_action.rawValue)
                    if game.gamevsInfo == .vsBot {
                        let selectedCards: [N_Card] = game.players[myside].selectedCards
                        let cardIds: [CardId] = selectedCards.map { $0.id }
                        GameBotController().playCards(Index: myside, cards: cardIds) { result, msg in
                            if result {
        
                            } else {
                                game.showErrorMessage = true
                                game.errorMessageText = msg!
                            }
                        }
                    } else {
                        GameFriendEventController().play(playerID: game.players[myside].id, selectCrads: game.players[myside].selectedCards, passPayerIndex: myside) { result, msg in
                            if result {
                                game.players[myside].selectedCards = []
                            } else {
                                game.showErrorMessage = true
                                game.errorMessageText = msg!
                            }
                        }
                    }
                }) {
                    Btnaction(btnText: "出す", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightRed)
                }
                .buttonStyle(PressBtn())
                
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.92)
        }
    }
}
