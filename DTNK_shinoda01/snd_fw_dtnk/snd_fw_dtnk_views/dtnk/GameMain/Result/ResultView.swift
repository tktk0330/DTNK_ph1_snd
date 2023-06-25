/**
結果の表示
表示内容：
 何ゲーム目
 各プレイヤーの順位
 ポイント変動
 
 ボタン
 */

import SwiftUI


struct ResultView: View {
    
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

//struct ResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultView()
//    }
//}
