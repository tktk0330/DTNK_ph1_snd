


import SwiftUI

final class RoutingState: ObservableObject {
    @Published var baseNaviState: NaviState
    
    init() {
        self.baseNaviState = NaviState(stack: [.splash])
//        self.baseNaviState = NaviState(stack: [.home])

    }
}
