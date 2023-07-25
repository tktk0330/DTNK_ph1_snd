import SwiftUI

struct BurstCoutionView: View {
    @State private var isAnimating = false
    let text: String
    
    var body: some View {
        GeometryReader { proxy in
            AnimationReader(100) { value in
                ZStack {
                    Text(text)
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .fontWeight(.heavy)
                        .foregroundColor(.red) // 赤い色を追加
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .scaleEffect(isAnimating ? 1.5 : 1.0)
                }

                .onAppear {
                    withAnimation(Animation.interpolatingSpring(stiffness: 200, damping: 10)) {
                        self.isAnimating = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: true)) {
                            self.isAnimating = false
                        }
                    }
                }

                
            }
        }
        .background(Color.clear) // 背景色を透明にする
    }
}
