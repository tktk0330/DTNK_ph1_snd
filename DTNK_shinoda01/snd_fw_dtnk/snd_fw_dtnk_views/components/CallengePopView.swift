


import SwiftUI

struct CallengePopView: View {
    
    @StateObject var game: GameUiState = appState.gameUiState
    let index: Int

    var body: some View {
        GeometryReader { geo in
            
            Text("Let's Move On To The Next Stage!​")
                .font(.system(size: 20))
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .padding(5)
                .position(x: geo.size.width / 2, y: geo.size.height / 4)
            
            HStack(spacing: 10) {
                
                Button(action: {
                    // TODO: REVENGE処理に変える
                    if game.dtnkJudge(playerAllCards: game.players[0].hand, table: game.table) {
                        game.Revengefirst(Index: 0)
                        game.challengeFlag[0] = 3
                    } else {
                        // challenge
                        game.challengeFlag[0] = 1
                    }
                }) {
                    Text(game.dtnkJudge(playerAllCards: game.players[0].hand, table: game.table) ? "REVENGE" : "CHALLENGE")
                        .font(.system(size: 18))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                        .bold()
                        .padding(3)
                        .frame(width: 150, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 3)
                        )
                }
                
                Button(action: {
                    game.challengeFlag[0] = 2
                }) {
                    Text("RETIRE")
                        .font(.system(size: 18))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                        .bold()
                        .padding(3)
                        .frame(width: 150, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 3)
                        )
                }
            }
            .position(x: geo.size.width / 2, y: geo.size.height * 0.7)
        }
        .frame(width: 350, height: 200)
        .background(
            Color.black.opacity(0.85)
            )
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 3)
        )


    }
}

