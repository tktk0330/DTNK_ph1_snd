


import SwiftUI

struct WaitingView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 30) {
                    Text("対戦相手を待っています")
                        .font(.custom(FontName.MP_EB, size: 20))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.casinoLightGreen))
                        .scaleEffect(2.0)
                }
                .frame(width: geo.size.width, height: geo.size.height * 0.18)
                .background(
                    Color.casinoGreen
                )
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(
                Color.black.opacity(0.80)
            )
        }
    }
}

struct WaitingChallengePopView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 30) {
                    Text("対戦相手を待っています")
                        .font(.custom(FontName.MP_EB, size: 20))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.casinoLightGreen))
                        .scaleEffect(2.0)
                }
                .frame(width: geo.size.width, height: geo.size.height * 0.40)
                .background(
                    Color.casinoGreen
                )
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(
                Color.black.opacity(0.80)
            )
        }
    }
}


struct WaitingLoadingView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 30) {
                    Text("Now Loading...")
                        .font(.custom(FontName.font01, size: 20))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .scaleEffect(2.0)
                }
                .frame(width: geo.size.width, height: geo.size.height * 0.18)
                .background(
                    Color.casinoGreen
                )
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



