/**
 SplashView
 */

import SwiftUI

struct SplashView: View {
    
    @StateObject var splash: SplashState = appState.splash
    
    init() {
        SplashController().initSplashState()
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 広告用
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                
                Text("IWM")
                    .font(.custom(FontName.font01, size: UIScreen.main.bounds.width * 0.30))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .opacity(splash.alpha)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.50)
                
            }
            .onAppear {
                SplashController().onSplashAppear()
            }
        }
    }
}
