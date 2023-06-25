/*
 rate
 text　と　数字分ける
 */
import SwiftUI

struct rateBtnView: View {

    let text: String

    var body: some View {

        Text(text)
            .font(.system(size: 25))
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
        VStack {
            HStack {
                rateBtnView(text: "GAME \(gamenum)")
                rateBtnView(text: "RATE \(rate)")
                rateBtnView(text: "✖️ \(magnification)")
            }
        }
    }
}
