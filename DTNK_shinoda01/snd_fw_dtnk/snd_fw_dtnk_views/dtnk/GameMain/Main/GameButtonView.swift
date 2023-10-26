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
                        Btnaction(btnText: "どてんこ（仮）", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.5, btnHeight: 60, btnColor: Color.casinoLightGreen)
                    }
                    .buttonStyle(PressBtn())
                }
                if GameBotController().dtnkJudge(myside: myside, playerAllCards: game.players[myside].hand, table: game.table) == Constants.stnkCode {
                    Button(action: {
                        if game.gamevsInfo == .vsBot {
                            GameBotController().playerDtnk(Index: myside)
                        } else {
                            GameFriendEventController().playerDtnk(Index: myside, dtnkPlayer: game.players[myside])
                        }
                    }) {
                        Btnaction(btnText: "しょてんこ（仮）", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.5, btnHeight: 60, btnColor: Color.casinoLightGreen)
                    }
                    .buttonStyle(PressBtn())
                    
                }
                if GameBotController().dtnkJudge(myside: myside, playerAllCards: game.players[myside].hand, table: game.table) == Constants.revengeCode {
                    Button(action: {
                        if game.gamevsInfo == .vsBot {
                            GameBotController().playerDtnk(Index: myside)
                        } else {
                            GameFriendEventController().playerDtnk(Index: myside, dtnkPlayer: game.players[myside])
                        }
                    }) {
                        Btnaction(btnText: "どてんこ返し（仮）", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.5, btnHeight: 60, btnColor: Color.casinoLightGreen)
                    }
                    .buttonStyle(PressBtn())
                }
            }
        }
        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.80)
        
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
                if game.gamevsInfo == .vsBot {
                    GameBotController().playerDtnk(Index: myside)
                } else {
                    GameFriendEventController().playerDtnk(Index: myside, dtnkPlayer: game.players[myside])
                }

            }) {
                ZStack{
                    Image(game.players[myside].icon_url)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(
                            Group {
                                if appState.gameUIState.gamePhase == .main && game.currentPlayerIndex == game.myside && game.gamevsInfo == .vsFriend {
                                    Rectangle().foregroundColor(.black).opacity(0.7)
                                } else {
                                    Rectangle().opacity(0)
                                }
                            }
                        )
                        .frame(width: 60)
                        .cornerRadius(10)
                        .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)

                    if appState.gameUIState.gamePhase == .main && game.currentPlayerIndex == game.myside && game.gamevsInfo == .vsFriend {
                        // ターンカウントダウン
                        CountdownView()
                            .frame(width: 60)
                    }
                }
            }
            
            Button(action: {
                SoundMng.shared.playSound(soundName: SoundName.SE.card_action.rawValue)
                if game.gamevsInfo == .vsBot {
                    let selectedCards: [N_Card] = game.players[myside].selectedCards
                    let cardIds: [CardId] = selectedCards.map { $0.id }
                    GameBotController().playCards(Index: myside, cards: cardIds)
                } else {
                    GameFriendEventController().play(playerID: game.players[myside].id, selectCrads: game.players[myside].selectedCards, passPayerIndex: myside) { result in
                        if result {
                            game.players[myside].selectedCards = []
                        } else {
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
