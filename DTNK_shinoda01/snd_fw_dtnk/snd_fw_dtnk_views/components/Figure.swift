
import SwiftUI

struct Figure: View {
    var body: some View {
        Rectangle()
            .fill(Color.plusDarkGreen)
            .frame(width:200, height: 80)
    }
}

// Game スコア表示バー
struct ScoreBar: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: 150, height: 115)
            .overlay(
                Rectangle()
                    .stroke(Color.casinoShadow, lineWidth: 20)
            )
    }
}

