// CardPoolView.swift


import SwiftUI

struct CardPoolView: View {
    var game: GameUIState
    var myside: Int
    var geo: GeometryProxy
    @Binding var selectedCards: [N_Card]  // Add this line

    var body: some View {
        ZStack {
            ForEach(Array(game.cardUI.enumerated()), id: \.1.id) { index, card in
                N_CardView(card: card, location: card.location, selectedCards: $selectedCards) // Use this instead of $game.players[myside].selectedCards
                    .animation(.easeInOut(duration: 0.3))
            }

            Image(ImageName.Card.back.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Constants.otherCardWidth)
                .offset(CGSize(width: UIScreen.main.bounds.width * -0.09, height: -Constants.scrHeight * 0.01))
        }
        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
    }
}
