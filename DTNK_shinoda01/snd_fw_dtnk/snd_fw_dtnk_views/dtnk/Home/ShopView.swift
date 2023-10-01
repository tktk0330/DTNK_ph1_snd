/**
Shop
 */

import SwiftUI

struct ShopView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // admob
                BunnerView(geo: geo)
                // back
                BackButton(backPage: .home, geo: geo)

                // title
                Text("Shop")
                    .font(.custom(FontName.font01, size: 45))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.15)
            }
        }
    }
}
