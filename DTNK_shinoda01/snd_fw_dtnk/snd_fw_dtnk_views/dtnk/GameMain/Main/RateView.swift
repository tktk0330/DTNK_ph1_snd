/*
 rate
 text　と　数字分ける
 */

import SwiftUI

struct GameRateView: View {
    
    var game: GameUIState
    var geo: GeometryProxy
    var body: some View {
        RateView(gamenum: game.gameNum, rate: game.initialRate, magnification: game.ascendingRate)
            .background(Color.casinoGreen)
            .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.12)
    }
}

struct rateBtnView: View {

    let text: String

    var body: some View {

        Text(text)
            .font(.custom(FontName.font01, size: 25))
            .foregroundColor(Color.white)
            .fontWeight(.bold)
            .padding(5)
    }
}

struct RateView: View {
    
    let gamenum: Int
    let rate: Int
    let magnification: Int
    
    var body: some View {
        HStack {
            rateBtnView(text: "Game \(gamenum)")
            rateBtnView(text: "Rate \(rate)")
            rateBtnView(text: "✖︎ \(magnification)")
        }
        .frame(width: Constants.scrWidth)
    }
}
