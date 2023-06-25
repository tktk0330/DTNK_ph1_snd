/**
横スライドさせる
 
 */

import SwiftUI

struct PhotosView<T: View>: View {
    private let width: CGFloat
    private let height: CGFloat
    private let content: () -> T

    init(width: CGFloat, height: CGFloat, @ViewBuilder content: @escaping () -> T) {
        self.width = width
        self.height = height
        self.content = content
    }
    var body: some View {
        TabView {
            content()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
        .frame(width: width, height: height)
        .background(Color(UIColor.secondarySystemFill))
    }
}
