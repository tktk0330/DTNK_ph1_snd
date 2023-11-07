/**
結果の表示
表示内容：
 何ゲーム目
 各プレイヤーの順位
 ポイント変動
 
 ボタン
 */

import SwiftUI

// 統合
struct ResultView: View {
    @StateObject var game: GameUIState = appState.gameUIState

    var body: some View {
        GeometryReader { geo in
            ZStack() {
                // Game
                Text("Game \(game.gameNum)")
                    .font(.custom(FontName.font01, size: 30))
                    .foregroundColor(Color.white)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width * 0.50, y:  geo.size.height * 0.13)
                
                MidResultItem(player: game.players[(game.myside + 1) % game.players.count])
                    .position(x: UIScreen.main.bounds.width * 0.2, y:  geo.size.height * 0.45)
                
                MidResultItem(player: game.players[(game.myside + 2) % game.players.count])
                    .position(x: UIScreen.main.bounds.width * 0.5, y:  geo.size.height * 0.23)
                
                MidResultItem(player: game.players[(game.myside + 3) % game.players.count])
                    .position(x: UIScreen.main.bounds.width * 0.8, y:  geo.size.height * 0.45)

                MidResultItem(player: game.players[game.myside])
                    .position(x: UIScreen.main.bounds.width * 0.5, y:  geo.size.height * 0.65)
                
                // 次へボタン
                Button(action: {
                    SoundMng.shared.playSound(soundName: SoundName.SE.btn_positive.rawValue)

                    if game.gamevsInfo == .vsFriend {
                        // 次ゲームに向けた処理
                        if appState.gameUIState.gameNum == appState.gameUIState.gameTarget {
                            Router().setBasePages(stack: [.gameresult])
                        } else {
                            GameFriendEventController().moveNextGame(index: appState.gameUIState.myside, ans: .waiting)
                            GameFriendEventController().onTapOKButton(gamePhase: .waiting)
                        }
                    } else {
                        GameBotController().moveNextGame()
                    }
                }) {
                    Btnwb(btnText: "OK", btnTextSize: 30, btnWidth: 200, btnHeight: 50, btnColor: Color.clear)
                }
                .position(x: UIScreen.main.bounds.width * 0.5, y:  geo.size.height * 0.9)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(
                Color.black.opacity(0.98)
            )
        }
    }
}

// 横
struct MidResultItem1: View {
    @StateObject var game: GameUIState = appState.gameUIState
    let player: Player_f
    
    var body: some View {
        GeometryReader { geo in
            VStack() {
                HStack(spacing: 7) {
                    // icon
                    IconView(iconURL: player.icon_url, size: 40)
                    
                    Spacer()
                    // name
                    Text(player.name)
                        .font(.custom(FontName.MP_Bo, size: 15))
                        .foregroundColor(Color.white)
                        .frame(width: geo.size.width * 0.2, alignment: .trailing)
                        .offset(x: -2, y: 6)
                    Spacer()

                }
                HStack {
                    // rank
                    Text(String(player.rank))
                        .font(.custom(FontName.font02, size: 40))
                        .foregroundColor(rankColor(for: player.rank))
                        .frame(width: geo.size.width * 0.05)
                        .position(x: 15, y: -2)
                    // point
                    VStack(alignment: .trailing) {
                        if game.winners.contains(where: { $0.id == player.id }) {
                            Text("+\(game.gameScore * game.losers.count)")
                                .font(.custom(FontName.font02, size: 15))
                                .foregroundColor(Color.casinoLightGreen)
                                .frame(width: geo.size.width * 0.28, alignment: .trailing)
                        } else if game.losers.contains(where: { $0.id == player.id }) {
                            Text("-\(game.gameScore * game.winners.count)")
                                .font(.custom(FontName.font02, size: 15))
                                .foregroundColor(Color.plusRed)
                                .frame(width: geo.size.width * 0.28, alignment: .trailing)
                        } else {
                            Text("")
                                .font(.custom(FontName.font02, size: 15))
                                .foregroundColor(Color.plusRed)
                                .frame(width: geo.size.width * 0.28, alignment: .trailing)
                        }
                        Text(String(player.score))// 1200000
                            .font(.custom(FontName.font02, size: 30))
                            .foregroundColor(Color.white)
                            .frame(width: geo.size.width * 0.28, alignment: .trailing)
                    }
                }
                Spacer().frame(height: geo.size.height * 0.02)
            }
            .frame(width: Constants.scrWidth * 0.30, height: geo.size.height * 0.065)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 4) // 枠線を追加
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.casinoGreen)
                    )
            )
            .position(x: Constants.scrWidth * 0.5, y: Constants.scrHeight * 0.5)
        }
    }
    
    func rankColor(for rank: Int) -> Color {
        switch rank {
        case 1:
            return Color.red
        case 2:
            return Color.blue
        case 3:
            return Color.orange
        case 4:
            return Color.green
        default:
            return Color.white
        }
    }
}

// 縦長
struct MidResultItem: View {
    @StateObject var game: GameUIState = appState.gameUIState
    let player: Player_f
    
    var body: some View {
        GeometryReader { geo in
            VStack() {
                HStack() {
                    // rank
                    Text(String(player.rank))
                        .font(.custom(FontName.font02, size: 40))
                        .foregroundColor(rankColor(for: player.rank))
                        .frame(width: geo.size.width * 0.05)
                    
                    // icon
                    IconView(iconURL: player.icon_url, size: 40)
                }

                // name
                Text(player.name)
                    .font(.custom(FontName.MP_Bo, size: 15))
                    .foregroundColor(Color.white)
                    .frame(width: geo.size.width * 0.2, alignment: .trailing)
                
                // point
                VStack(alignment: .trailing) {
                    if game.winners.contains(where: { $0.id == player.id }) {
                        Text("+\(game.gameScore * game.losers.count)")
                            .font(.custom(FontName.font02, size: 15))
                            .foregroundColor(Color.casinoLightGreen)
                            .frame(width: geo.size.width * 0.28, alignment: .trailing)
                    } else if game.losers.contains(where: { $0.id == player.id }) {
                        Text("-\(game.gameScore * game.winners.count)")
                            .font(.custom(FontName.font02, size: 15))
                            .foregroundColor(Color.plusRed)
                            .frame(width: geo.size.width * 0.28, alignment: .trailing)
                    } else {
                        Text("")
                            .font(.custom(FontName.font02, size: 15))
                            .foregroundColor(Color.plusRed)
                            .frame(width: geo.size.width * 0.28, alignment: .trailing)
                    }
                    Text(String(player.score))// 1200000
                        .font(.custom(FontName.font02, size: 30))
                        .foregroundColor(Color.white)
                        .frame(width: geo.size.width * 0.28, alignment: .trailing)
                }
                .offset(x: -7, y: 0)
            }
            .frame(width: Constants.scrWidth * 0.2, height: Constants.scrHeight * 0.12)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 4)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.casinoGreen)
                    )
            )
            .position(x: Constants.scrWidth * 0.5, y: Constants.scrHeight * 0.5)
        }
    }
    
    func rankColor(for rank: Int) -> Color {
        switch rank {
        case 1:
            return Color.red
        case 2:
            return Color.blue
        case 3:
            return Color.orange
        case 4:
            return Color.green
        default:
            return Color.white
        }
    }
}

