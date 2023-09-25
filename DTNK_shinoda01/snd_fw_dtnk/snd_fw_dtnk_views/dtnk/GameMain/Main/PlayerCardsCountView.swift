// PlayerCardsCountView.swift


import SwiftUI

struct PlayerCardsCountView: View {
    @ObservedObject var game: GameUIState // あなたのゲームの型に変更してください
    var myside: Int
    var geo: GeometryProxy

    var body: some View {
        if game.gamePhase != .challenge {
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
