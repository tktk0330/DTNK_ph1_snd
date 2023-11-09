


import SwiftUI
import Foundation

struct SplashController {
    
    func initSplashState() {
        let splashState = SplashState()
        appState.splash = splashState
    }
    
    func onSplashAppear() {
        Task {
            log("ホーム画面へ進みます")
            // 画像の読み込みを待つ
            await preloadImages()
            // ホームへ進む
            await scaleUpSplashAsync()
            Router().setBasePages(stack: [.top], animated: false)
        }
    }
    
    // IconViewの画像読み込みロジックを使用して、必要な画像を事前に読み込む関数
    func preloadImages() async {
        let imageUrl = appState.account.loginUser.iconURL
        await preloadImage(url: imageUrl)
    }
    
    func preloadImage(url: String) async {
        await withCheckedContinuation { continuation in
            let cache = ImageCache.shared
            // キャッシュにあるかどうかを確認
            if cache.getImage(forKey: url) == nil {
                // キャッシュにない場合はダウンロード
                guard let imageURL = URL(string: url) else {
                    log("Invalid URL.")
                    continuation.resume()
                    return
                }
                
                URLSession.shared.dataTask(with: imageURL) { data, _, _ in
                    if let data = data, let uiImage = UIImage(data: data) {
                        let squareImage = uiImage.croppedToSquare() ?? uiImage
                        cache.saveImage(squareImage, forKey: url)
                    } else {
                        log("Failed to download image.")
                    }
                    continuation.resume()
                }.resume()
            } else {
                continuation.resume()
            }
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

