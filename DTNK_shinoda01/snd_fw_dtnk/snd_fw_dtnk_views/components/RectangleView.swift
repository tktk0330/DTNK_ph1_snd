/**
 図形の部品
 */

import SwiftUI

/**
 カード枚数の円
 */
struct CardsCountView: View {
    
    let cardsCount: Int
    var body: some View {
        Circle()
            .foregroundColor(.yellow)
            .frame(width: 20, height: 20)
            .overlay(
                Text(String(cardsCount))
                    .font(.headline)
                    .foregroundColor(.white)
            )
    }
    
    func position(side: Int) -> CGPoint {
        
        let game = appState.gameUIState
        
        switch side {
        case game!.myside:
            return CGPoint(x: UIScreen.main.bounds.width / 2, y: 0.84)
        case  (game!.myside + 1) % game!.players.count:
            return CGPoint(x: UIScreen.main.bounds.width * 0.05, y: 0.36)
        case  (game!.myside + 2) % game!.players.count:
            return CGPoint(x: UIScreen.main.bounds.width / 2, y: 0.17)
        case  (game!.myside + 3) % game!.players.count:
            return CGPoint(x: UIScreen.main.bounds.width * 0.95, y: 0.36)
        default:
            return CGPoint.zero
        }
    }
}
