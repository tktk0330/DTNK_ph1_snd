


import Foundation
import SwiftUI

struct SplashController {
    
    func initSplashState() {
        let splashState = SplashState()
        appState.splash = splashState
    }
    
    func onSplashAppear() {
        Task {
            print("ホーム画面へ進みます")
            // ホームへ進む
            await scaleUpSplashAsync()
            Router().setBasePages(stack: [.top], animated: false)
        }
    }
    
    // 拡大アニメーション
    func scaleUpSplash(completion: @escaping () -> Void) {
        let delaySec: Double = 2
        let durationSec: Double = 0.5
        let endWidth = UIScreen.main.bounds.width * 8
        let endAlpha: Double = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySec) {
            withAnimation(.easeIn(duration: durationSec)) {
                appState.splash.width = endWidth
                appState.splash.alpha = endAlpha
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + durationSec) {
                completion()
            }
        }
    }
    
    // 拡大アニメーション の async ラップ
    func scaleUpSplashAsync() async {
        await withCheckedContinuation { continuation in
            scaleUpSplash {
                continuation.resume()
            }
        }
    }
}

