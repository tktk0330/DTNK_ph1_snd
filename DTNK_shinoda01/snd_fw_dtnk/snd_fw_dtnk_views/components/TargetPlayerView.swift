/**
 ターンフォーカスView
 */

import SwiftUI

struct TargetPlayerPositionView: View {
    @ObservedObject var game: GameUIState // あなたのゲームの型に変更してください
    var geo: GeometryProxy
    
    var body: some View {
        if game.currentPlayerIndex != 99 && (game.gamePhase == .main || game.gamePhase == .gamefirst_sub) {
            TargetPlayerView()
                .position(x: TargetPlayerView().focusPosition(side: game.currentPlayerIndex).x,
                          y: geo.size.height * TargetPlayerView().focusPosition(side: game.currentPlayerIndex).y)
                .animation(.easeInOut(duration: 0.5), value: game.currentPlayerIndex)
        }
    }
}

struct TargetPlayerView: View {
    
    @State private var isAnimating = false

    var body: some View {
        ZStack() {
            ForEach(0..<1) { index in
                Circle()
                    .foregroundColor(.yellow)
                    .frame(width: 80, height: 80)
                    .scaleEffect(isAnimating ? 2.0 : 1.0)
                    .opacity(isAnimating ? 0.0 : 1.0)
                    .animation(
                        Animation.linear(duration: 0.7)
                            .delay(Double(index) * 0.07)
                            .repeatForever(autoreverses: false)
                    , value: isAnimating)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    func focusPosition(side: Int) -> CGPoint {
        
        let game = appState.gameUIState
        
        switch side {
        case game!.myside:
            return CGPoint(x: UIScreen.main.bounds.width / 2, y: 0.90)
        case  (game!.myside + 1) % game!.players.count:
            return CGPoint(x: UIScreen.main.bounds.width * 0.10, y: 0.32)
        case  (game!.myside + 2) % game!.players.count:
            return CGPoint(x: UIScreen.main.bounds.width / 2, y: 0.12)
        case  (game!.myside + 3) % game!.players.count:
            return CGPoint(x: UIScreen.main.bounds.width * 0.90, y: 0.32)
        default:
            return CGPoint.zero
        }
    }

}

