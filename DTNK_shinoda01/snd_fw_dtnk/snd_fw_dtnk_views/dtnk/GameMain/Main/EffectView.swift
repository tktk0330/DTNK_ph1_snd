/**
何試合目かアナウンスアニメーション
 
 */

import SwiftUI

struct EffectView: View {
    
    @State private var shouldAnimate = false
    let gamenum: Int

    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color.white)
//                .shadow(color: .gray, radius: 10, x: 0, y: 5)
                .frame(height: 80)
            
            Text("GAME \(gamenum) ")
                .font(.system(size: 50))
                .foregroundColor(Color.plusDarkGreen)
                .fontWeight(.bold)
                .padding(5)
        }
        .frame(maxWidth: .infinity)
        .offset(x: shouldAnimate ? 0 : -UIScreen.main.bounds.width)
        .animation(.easeOut(duration: 0.5), value: shouldAnimate)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeOut(duration: 1.0)) {
                    shouldAnimate = false
                }
            }
            shouldAnimate = true
        }
    }
}

