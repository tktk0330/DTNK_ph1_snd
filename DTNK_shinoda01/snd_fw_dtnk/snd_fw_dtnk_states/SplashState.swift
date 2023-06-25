


import SwiftUI

class SplashState: ObservableObject {
    @Published var width: CGFloat
    @Published var alpha: Double

    init(width: CGFloat = UIScreen.main.bounds.width,
         alpha: Double = 1) {
        self.width = width
        self.alpha = alpha
    }
}
