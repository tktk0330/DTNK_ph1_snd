// PlayerCardsCountView.swift


import SwiftUI

struct PlayerCardsCountView: View {
    @ObservedObject var game: GameUIState
    var myside: Int
    var geo: GeometryProxy

    var body: some View {
        if game.gamePhase != .challenge && game.gamePhase != .endChallenge && game.gamePhase != .decisionrate_pre && game.gamePhase != .decisionrate {
            ForEach(0..<4) { index in
                CardsCountView(cardsCount: game.players[(myside + index) % game.players.count].hand.count)
                    .position(
                        x: CardsCountView(cardsCount: (myside + index) % game.players.count).position(side: (myside + index) % game.players.count).x,
                        y: geo.size.height * CardsCountView(cardsCount: (myside + index) % game.players.count).position(side: (myside + index) % game.players.count).y
                    )
            }
        }
    }
}
