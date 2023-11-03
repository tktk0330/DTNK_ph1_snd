// ScoreBarView.swift


import SwiftUI

struct ScoreBarView: View {
    var game: GameUIState
    var myside: Int
    var geo: GeometryProxy

    var body: some View {
        Group {
            Text(String(game.players[myside].score))
                .modifier(PlayerScoreModifier())
                .position(x: Constants.scrWidth / 2, y:  geo.size.height * 0.58)

            Text(String(game.players[(myside + 1) % game.players.count].score))
                .modifier(PlayerScoreModifier())
                .position(x: Constants.scrWidth * 0.48, y:  geo.size.height * 0.61)
                .rotationEffect(Angle(degrees: 90))

            Text(String(game.players[(myside + 2) % game.players.count].score))
                .modifier(PlayerScoreModifier())
                .position(x: Constants.scrWidth / 2, y:  geo.size.height * 0.40)

            Text(String(game.players[(myside + 3) % game.players.count].score))
                .modifier(PlayerScoreModifier())
                .position(x: Constants.scrWidth * 0.52, y:  geo.size.height * 0.61)
                .rotationEffect(Angle(degrees: -90))
        }
    }
}
