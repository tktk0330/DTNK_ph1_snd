
import SwiftUI

struct GameResultView: View {
    
    @ObservedObject var resultState: ResultState = appState.resultState
    @StateObject var game: GameUiState = appState.gameUiState

    
    var body: some View {

        GeometryReader { geo in
            ZStack(alignment: .center) {
                
                // 広告用
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                
                // title
                Text("FINAL RESULT")
                    .font(.system(size: 45))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.15)

                
                // TOTAL GAME
                Text("TOTAL GAME 10")
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.25)

                
                VStack(spacing: 30){
                    // 個人成績
                    ForEach(resultState.playeritems.indices, id: \.self) { index in
                        HStack(spacing: 10){
                            Text(String(resultState.playeritems[index].rank))
                                .font(.system(size: 30))
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .padding(5)
                                .frame(width: geo.size.width * 0.1)
                            
                            Image(resultState.playeritems[index].iconUrl)
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .frame(width: geo.size.width * 0.1)
                            
                            Text(resultState.playeritems[index].name)
                                .font(.system(size: 30))
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .padding(5)
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                                .frame(width: geo.size.width * 0.3)
                            
                            Text(String(resultState.playeritems[index].score))
                                .font(.system(size: 30))
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
                }) {
                    Text("HOME")
                        .font(.system(size: 45))
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

