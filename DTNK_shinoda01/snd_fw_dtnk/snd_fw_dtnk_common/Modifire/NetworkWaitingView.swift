


import SwiftUI

struct NetworkWaitingView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 30) {
                    Text("ネットワーク接続確認中...")
                        .font(.custom(FontName.MP_EB, size: 20))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.casinoLightGreen))
                        .scaleEffect(2.0)
                }
                .frame(width: geo.size.width, height: geo.size.height * 0.18)
                .background(Color.casinoGreen)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.black.opacity(0.80))
        }
    }
}

struct DisconnectPromptView: View {
    let exitAction: () -> Void

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    Text("ネットワーク接続エラー")
                        .font(.custom(FontName.MP_EB, size: 20))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                    
                    Button(action: exitAction) {
                        Text("終了")
                            .font(.custom(FontName.MP_EB, size: 20))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .bold()
                            .padding()
                            .frame(width: 150, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.red)
                                    .shadow(color: Color.casinoShadow, radius: 1, x: 5, y: 10)
                            )
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height * 0.18)
                .background(Color.casinoGreen)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.black.opacity(0.80))
        }
    }
}

