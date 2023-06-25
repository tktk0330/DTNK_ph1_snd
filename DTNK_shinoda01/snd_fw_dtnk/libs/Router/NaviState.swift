


import Foundation
import SwiftUI

final class NaviState: ObservableObject {
    @Published var stack: [PageId]
        
    init(stack: [PageId]) {
        self.stack = stack
    }
}
