//// TODO: テキストの背景をオシャレにしたいipadで作って取り込む？　　アニメーションも要検討
//
//
//import SwiftUI
//
//struct DTNKView: View {
//    @State private var isAnimating = false
//    let text: String
//
//    var body: some View {
//        GeometryReader { proxy in
//            AnimationReader(100) { value in
//                ZStack {
//                    Text(text)
//                        .font(.custom(FontName.font01, size: Constants.scrWidth * 0.1))
//                        .font(.system(size: Constants.scrWidth * 0.1, weight: .bold, design: .default))
//                        .shine(.gold, withWaveIndex: value)
//                        .fontWeight(.heavy)
//                        .foregroundColor(.white)
//                        .opacity(isAnimating ? 1.0 : 0.0)
//                        .scaleEffect(isAnimating ? 1.5 : 1.0)
//                }
//                .onAppear {
//                    withAnimation(Animation.interpolatingSpring(stiffness: 200, damping: 10)){
//                        self.isAnimating = true
//                    }
//                    // ２秒後に消える
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        withAnimation {
//                            self.isAnimating = false
//                        }
//                    }
//
//                }
//            }
//        }
//    }
//}
//
//struct RevengeView: View {
//    @State private var isAnimating = false
//    let text: String
//
//    // アニメーション終了時のコールバックを追加
//    var onEnd: (() -> Void)? = nil
//
//    var body: some View {
//        GeometryReader { proxy in
//            AnimationReader(100) { value in
//                ZStack {
//                    Text(text)
//                        .font(.custom(FontName.MP_Bo, size: Constants.scrWidth * 0.1))
//                        .font(.system(size: Constants.scrWidth * 0.1, weight: .bold, design: .default))
//                        .shine(.gold, withWaveIndex: value)
//                        .fontWeight(.heavy)
//                        .foregroundColor(.white)
//                        .opacity(isAnimating ? 1.0 : 0.0)
//                        .scaleEffect(isAnimating ? 1.5 : 1.0)
//                }
//                .onAppear {
//                    withAnimation(Animation.interpolatingSpring(stiffness: 200, damping: 10)) {
//                        self.isAnimating = true
//                    }
//
//                    // After 2 seconds, hide the view
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        withAnimation {
//                            self.isAnimating = false
//                        }
//
//                        // After the animation ends, execute the callback
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            self.onEnd?()
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
