/**
 
 */

import SwiftUI

struct BotView: View {
    
    let playerIndex: Int
    @ObservedObject var game: GameUiState
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

        ZStack{
            // 手札
            HStack(spacing: -40) {
                ForEach(Array(game.players[playerIndex].hand.enumerated()), id: \.1.id) { index, card in
                        noScaleCardView(card: card, namespace: namespace, degree: (game.gamePhase == .challenge) ? 0 : 180, width: 60)
                            .rotationEffect(.degrees(Double(index * a[handsCount] - b[handsCount])))
                            .offset(y:CGFloat(cardposition_y[handsCount][index]))
//                            .animation(.default)
                }
            }
            .animation(.easeInOut(duration: 0.3))

        }
    }
}

struct Bot: View {
    
    @StateObject var game: GameUiState = appState.gameUiState
    let namespace: Namespace.ID
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                BotView(playerIndex: 2, game: game, namespace: namespace)
                    .rotationEffect(.degrees(180))
                    .scaleEffect( (game.gamePhase == .challenge) ? 1.3 : 1.0)
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.20)
                
                BotView(playerIndex: 1, game: game, namespace: namespace)
                    .rotationEffect(.degrees(90))
                    .scaleEffect( (game.gamePhase == .challenge) ? 1.3 : 1.0)
                    .position(x: UIScreen.main.bounds.width * 0.10, y:  geo.size.height * 0.35)
                
                BotView(playerIndex: 3, game: game, namespace: namespace)
                    .rotationEffect(.degrees(-90))
                    .scaleEffect( (game.gamePhase == .challenge) ? 1.3 : 1.0)
                    .position(x: UIScreen.main.bounds.width * 0.90, y:  geo.size.height * 0.35)
            }
        }
    }
}
