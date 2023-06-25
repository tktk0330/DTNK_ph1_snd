/*
 手札
 */
import SwiftUI

struct PlayerView: View {
    
    let playerIndex: Int
    @StateObject var game: GameUiState = appState.gameUiState

    let namespace: Namespace.ID
    
    let a:[Int] = [0,0,14,15,18,15,8,8]
    let b:[Int] = [0,0,7,15,27,30,20,24]

    var body: some View {
        
        let handsCount = game.players[playerIndex].hand.count
        let cardposition_y = [[0],
                              [0],
                              [0,0],
                              [5,0,5],
                              [10,0,0,10],
                              [15,3,0,3,15],
                              [15,5,0,0,5,15],
                              [23,10,3,0,3,10,23]]

        VStack{
            // 手札
            HStack(spacing: -35) {
                ForEach(Array(game.players[playerIndex].hand.enumerated()), id: \.1.id) { index, card in
                    CardView(card: card, namespace: namespace, selectedCards: $game.players[playerIndex].selectedCards)
                        .rotationEffect(.degrees(Double(index * a[handsCount] - b[handsCount])))
                        .offset(y:CGFloat(cardposition_y[handsCount][index]))
                }
            }
            .animation(.easeInOut(duration: 0.3))

        }
    }
}


struct PlayerHand: View {
    
    @StateObject var game: GameUiState = appState.gameUiState
    let namespace: Namespace.ID
    
    var body: some View {
        GeometryReader { geo in
            //player
            ZStack{
                //MainPlayer
                PlayerView(playerIndex: 0, game: game, namespace: namespace)

            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.68)
        }
    }
}
