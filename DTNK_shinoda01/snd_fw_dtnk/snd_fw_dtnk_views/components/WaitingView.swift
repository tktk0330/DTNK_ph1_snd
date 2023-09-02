


import SwiftUI

struct WaitingView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 30) {
                    Text("対戦相手を待っています")
                        .font(.custom(FontName.font01, size: 20))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.casinoLightGreen))
                        .scaleEffect(3.0)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(
                Color.black.opacity(0.80)
            )
        }
    }
}

struct WaitingChallengeView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 30) {
                    Text("対戦相手を待っています")
                        .font(.custom(FontName.font01, size: 20))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.casinoLightGreen))
                        .scaleEffect(3.0)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height * 0.3)
        }
    }
}

