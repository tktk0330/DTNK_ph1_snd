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
//    @ObservedObject var resultState: ResultState = appState.resultState
//    @StateObject var game: GameUiState = appState.gameUiState
    var body: some View {
        GeometryReader { geo in
            ZStack() {
                // Game
                // TODO: 反映
                Text("Game 10")
                    .font(.custom(FontName.font01, size: 30))
                    .foregroundColor(Color.white)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width * 0.50, y:  geo.size.height * 0.15)
                
                MidResultItem(index: 1)
                    .position(x: UIScreen.main.bounds.width * 0.2, y:  geo.size.height * 0.5)
                
                MidResultItem(index: 2)
                    .position(x: UIScreen.main.bounds.width * 0.5, y:  geo.size.height * 0.3)
                
                MidResultItem(index: 3)
                    .position(x: UIScreen.main.bounds.width * 0.8, y:  geo.size.height * 0.5)

                MidResultItem(index: 0)
                    .position(x: UIScreen.main.bounds.width * 0.5, y:  geo.size.height * 0.7)
                
                
                // 次へボタン
                Button(action: {
                    // 次ゲームに向けた処理
//                    ScoreContoroller().onTapScoreOK()
//                    appState.gameUIState.gamePhase = .dealcard
                    GameFriendEventController().onTapOKButton(gamePhase: .dealcard)
                }) {
                    Btnwb(btnText: "OK", btnTextSize: 30, btnWidth: 200, btnHeight: 50, btnColor: Color.clear)
                }
                .position(x: UIScreen.main.bounds.width * 0.5, y:  geo.size.height * 0.9)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(
                Color.black.opacity(0.80)
            )
        }
    }
}

struct ResultView01: View {
    
    @ObservedObject var resultState: ResultState = appState.resultState
    @StateObject var game: GameUiState = appState.gameUiState

    var body: some View {
        GeometryReader { geo in
            
            ZStack(alignment: .center) {

                VStack(spacing:50) {

                    VStack(spacing: 0) {
                        // title
                        Text("GAME RESULT")
                            .font(.system(size: 45))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .padding(5)

                        // GAME
                        Text("GAME \(resultState.gameitems.gamenum)")
                            .font(.system(size: 30))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .padding(5)

                        // SCORE
                        Text("SCORE \(resultState.gameitems.gamescore)")
                            .font(.system(size: 30))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .padding(5)

                        // 勝敗
                        Text("\(resultState.gameitems.loosers.count > 1 ? "ALL" : resultState.gameitems.loosers[0].name) ➡︎ \(resultState.gameitems.winners.count > 1 ? "ALL" : resultState.gameitems.winners[0].name)")
                            .font(.system(size: 30))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .padding(5)
                    }


                    ForEach(resultState.playeritems.indices, id: \.self) { index in
                        ScorePlayerItem(playerResult: resultState.playeritems[index])
                    }

                    // 次へボタン
                    Button(action: {
                        ScoreContoroller().onTapScoreOK()
                    }) {
                        Text("OK")
                            .font(.system(size: 25))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .bold()
                            .padding()
                            .frame(width: 100, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.yellow, lineWidth: 3)
                            )
                    }
                    Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .background(
                    Color.black.opacity(0.93)
                )
            }
            
            
        }
    }
}

struct MidResultItem: View {
    
    @StateObject var game: GameUIState = appState.gameUIState
    let index: Int
    
    var body: some View {
        GeometryReader { geo in
            VStack() {
                HStack(spacing: 7) {
                    // icon
                    Image(game.players[index].icon_url)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
//                        .offset(x: 5)

                    // name
                    Text(game.players[index].name)
                        .font(.custom(FontName.font01, size: 15))
                        .foregroundColor(Color.white)
                        .frame(width: geo.size.width * 0.2, alignment: .trailing)
                        .offset(x: -2, y: 5)
//                        .border(Color.red)
                    
                }
                HStack {
                    
                    // rank
                    Text(game.players[index].name)
                        .font(.custom(FontName.font02, size: 40))
                        .foregroundColor(Color.white)
                        .frame(width: geo.size.width * 0.05)
                        .position(x: 7, y: -15)
                        .border(Color.red)
                    
                    VStack(alignment: .trailing) {
                        // point
                        Text("+12000")// 1200000
                            .font(.custom(FontName.font02, size: 15))
                            .foregroundColor(Color.red)
                            .frame(width: geo.size.width * 0.28, alignment: .trailing)
//                            .border(Color.red)

                        // point
                        Text(String(game.players[index].score))// 1200000
                            .font(.custom(FontName.font02, size: 30))
                            .foregroundColor(Color.white)
                            .frame(width: geo.size.width * 0.28, alignment: .trailing)
//                            .border(Color.red)
                    }

                }
                Spacer().frame(height: geo.size.height * 0.02) // 追加されたスペーサー

            }
            .frame(width: UIScreen.main.bounds.width * 0.25, height: geo.size.height * 0.065)
            .padding() // 内部要素との間のスペースを追加するためのパディング
            .background(RoundedRectangle(cornerRadius: 20) // 角の丸みを調整する場合はこの行を変更してください
                            .fill(Color.casinoGreen)) // RoundedRectangleの色を変更する場合はこの行を変更してください
            .position(x: UIScreen.main.bounds.width * 0.5, y:  geo.size.height * 0.5)

        }
    }
}
