/**
 gameBackgroud
 */

import SwiftUI

struct GameBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RadialGradient(
                    gradient: Gradient(
                        colors: [.init(hex: 0x008800), .black]
                    ),
                    center: .center,
                    startRadius: 2,
                    endRadius: UIScreen.main.bounds.height
                )
                    .ignoresSafeArea(.all)
            )
    }
}

extension View {
    func gameBackground() -> some View {
        self.modifier(GameBackground())
    }
}



struct PlayerScoreModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontName.font01, size: 20))
            .foregroundColor(Color.white)
            .background(
                Rectangle()
                    .fill(Color.casinoShadow)
                    .frame(width: UIScreen.main.bounds.width * 0.405, height: Constants.scrHeight * 0.0248)
            )
    }
}
