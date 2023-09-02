


import SwiftUI

//func AnnounceLabel(_ text: String, duration: Double = 0.5, completion: (() -> Void)? = nil) {
//    DispatchQueue.main.async {
//        let label = UILabel()
//        label.text = text
//        label.textColor = .UIColorDarkGreen
//        label.backgroundColor = UIColor.white
//        label.textAlignment = .center
//        label.font = UIFont.boldSystemFont(ofSize: 55)
//        label.clipsToBounds = true
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        guard let window = UIApplication.shared.windows.first,
//              let windowScene = window.windowScene else {
//            return
//        }
//
//        window.addSubview(label)
//
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: window.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: window.centerYAnchor),
//            label.widthAnchor.constraint(equalToConstant: 400),
//            label.heightAnchor.constraint(equalToConstant: 100)
//        ])
//
//        label.alpha = 0.0
//        label.transform = CGAffineTransform(translationX: -window.frame.width, y: 0)
//
//        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
//            label.alpha = 1.0
//            label.transform = .identity
//        }, completion: { (_) in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
//                    label.alpha = 0.0
//                    label.transform = CGAffineTransform(translationX: window.frame.width, y: 0)
//                }) { (_) in
//                    label.removeFromSuperview()
//                    completion?() // アニメーション完了後に次のアクションを実行
//                }
//            }
//        })
//    }
//}

/**
 ゲーム数のアナウンス
 */
struct GmaeNumAnnounce: View {
    @State private var moveRectangle: CGFloat = -UIScreen.main.bounds.width
    @State private var animationStarted = false // 開始フラグ
    @State private var animationEnded = false   // 終了フラグ
    var duration = 0.3
    var stoptime01 = 1.0// 中央
    var stoptime02 = 1.0
    let gameNum: Int
    let gameTarget: Int

    var body: some View {
        ZStack {
            // アニメーション対象の長方形とテキスト
            ZStack {
                Rectangle()
                    .fill(Color.black.opacity(0.7))
                    .frame(width: UIScreen.main.bounds.width, height: 130)
                Text("Game \(gameNum) / \(gameTarget)")
                    .font(.custom(FontName.font01, size: 30))
                    .foregroundColor(.white)
            }
            .offset(x: moveRectangle, y: 0)
            .onAppear(perform: startAnimation) // Viewが表示された時のトリガー
        }
    }

    // アニメーションを制御する関数
    func startAnimation() {
        // 既にアニメーションが開始されていたら、再度実行しない
        guard !animationStarted else {
            return
            
        }
        
        // アニメーション開始フラグをセット
        animationStarted = true
        appState.gameUIState.AnnounceFlg = true
        print("開始") // 開始の出力
        
        // 左から中央に動く
        withAnimation(Animation.linear(duration: self.duration)) {
            self.moveRectangle = 0
        }
        
        // 1.5秒後に中央での停止
        DispatchQueue.main.asyncAfter(deadline: .now() + stoptime01) {
            // さらに1秒後に中央から右へ動き出す
            DispatchQueue.main.asyncAfter(deadline: .now() + stoptime02) {
                withAnimation(Animation.linear(duration: self.duration)) {
                    self.moveRectangle = UIScreen.main.bounds.width
                }
                
                // アニメーション終了フラグをセット
                animationEnded = true
                print("終了") // 終了の出力
                appState.gameUIState.AnnounceFlg = false
            }
        }
    }
}

/**
 レートアップのアナウンス
 */
struct RateUpAnnounce: View {
    @State private var moveRectangle: CGFloat = -UIScreen.main.bounds.width
    @State private var animationStarted = false // 開始フラグ
    @State private var animationEnded = false   // 終了フラグ
    var duration = 0.3
    var stoptime01 = 2.0// 中央
    var stoptime02 = 1.0
    let cardImage: String
    // アニメーション終了時のコールバックを追加
    var onEnd: (() -> Void)? = nil

    var body: some View {
        ZStack {
            // アニメーション対象の長方形とテキスト
            ZStack {
                Rectangle()
                    .fill(Color.yellow.opacity(0.8))
                    .frame(width: UIScreen.main.bounds.width, height: 160)
                VStack(spacing: 10) {
                    Text("Rate UP")
                        .font(.custom(FontName.font01, size: 30))
                        .foregroundColor(.dtnkBlue)
                    Image(cardImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60)
                }
            }
            .offset(x: moveRectangle, y: 0)
            .onAppear(perform: startAnimation) // Viewが表示された時のトリガー
        }
    }

    // アニメーションを制御する関数
    func startAnimation() {
        // 既にアニメーションが開始されていたら、再度実行しない
        guard !animationStarted else { return }
        
        // アニメーション開始フラグをセット
        animationStarted = true
        print("開始") // 開始の出力
        
        // 左から中央に動く
        withAnimation(Animation.linear(duration: self.duration)) {
            self.moveRectangle = 0
        }
        
        // 1.5秒後に中央での停止
        DispatchQueue.main.asyncAfter(deadline: .now() + stoptime01) {
            // さらに1秒後に中央から右へ動き出す
            DispatchQueue.main.asyncAfter(deadline: .now() + stoptime02) {
                withAnimation(Animation.linear(duration: self.duration)) {
                    self.moveRectangle = UIScreen.main.bounds.width
                }
                
                // アニメーション終了フラグをセット
                animationEnded = true
                print("終了") // 終了の出力

                // アニメーション終了時のコールバックを実行
                onEnd?()
            }
        }
    }
}



