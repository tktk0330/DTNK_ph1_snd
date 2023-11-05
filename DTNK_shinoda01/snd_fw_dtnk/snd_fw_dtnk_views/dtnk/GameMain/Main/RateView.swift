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
            .background(Color.casinoShadow)
            .border(Color.white, width: 5)
            .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.12)
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
            magnificationView(magnification: magnification)
        }
        .frame(width: Constants.scrWidth)
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

// 上昇レート
struct magnificationView: View {

    let magnification: Int

    var body: some View {

        HStack(spacing: 0) {
            
            Text("✖︎ ")
                .font(.custom(FontName.font01, size: 25))
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .padding(5)
            
            Text(String(magnification))
                .font(.custom(FontName.font01, size: 25))
                .foregroundColor(magnification != 1 ? Color.yellow : Color.white)
                .fontWeight(.bold)
                .padding(5)
        }
    }
}
