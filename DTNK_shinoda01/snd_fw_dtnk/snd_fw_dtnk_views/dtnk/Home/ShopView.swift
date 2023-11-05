/**
Shop
 */

import SwiftUI

struct ShopView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // back
                BackButton(backPage: .home, geo: geo)

                // title
                Text("Shop")
                    .modifier(PageTitleModifier())
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.15)
            }
        }
    }
}
