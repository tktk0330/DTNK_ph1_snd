/**
 最終結果画面
 */

import SwiftUI

struct GameResultView: View {
    
    @StateObject var game: GameUIState = appState.gameUIState
    let sortedPlayers = appState.gameUIState.players.sorted(by: { $0.rank < $1.rank })
    var body: some View {
        
        GeometryReader { geo in
            ZStack(alignment: .center) {
                // title
                Text("Result")
                    .font(.custom(FontName.font01, size: UIScreen.main.bounds.width * 0.15))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.15)

                
                // TOTAL GAME
                Text("Total Game \(game.gameTarget)")
                    .font(.custom(FontName.font01, size: UIScreen.main.bounds.width * 0.08))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.25)

                
                VStack(spacing: 30){
                    // 個人成績
                    ForEach(sortedPlayers) { player in
                        HStack(spacing: 10){
                            Text(String(player.rank))
                                .font(.custom(FontName.font01, size: 30))
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .padding(5)
                                .frame(width: geo.size.width * 0.1)

                            Image(player.icon_url)
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .frame(width: geo.size.width * 0.1)

                            Text(player.name)
                                .font(.custom(FontName.font01, size: 30))
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .padding(5)
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                                .frame(width: geo.size.width * 0.3)

                            Text(String(player.score))
                                .font(.custom(FontName.font01, size: 30))
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .padding(5)
                                .minimumScaleFactor(0.3)
                                .frame(width: geo.size.width * 0.3)
                        }
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.55)

                // Homeへ
                Button(action: {
                    // Home画面へ
                    GameResultController().onTapPlay()
                    if game.gamevsInfo == .vsBot {
                        appState.matching = nil
                        game.resetItem()
                    } else {
                        // ゲームデータ削除
                        game.deleteGamedate()
                    }
                }) {
                    Text("Home")
                        .font(.custom(FontName.font01, size: UIScreen.main.bounds.width * 0.10))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                        .padding(5)
                }
                .blinkEffect(animating: true)
                .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.85)
            }
        }
    }
}

