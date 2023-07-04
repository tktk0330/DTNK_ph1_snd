/**
 
 */

import SwiftUI

final class MatchingState: ObservableObject {
    
    let seatCount: Int
    @Published var message: String
    @Published var players: [Player]
    @Published var vsInfo: String
    
    init(seatCount: Int, message: String, vsInfo: String) {
        self.seatCount = seatCount
        self.message = message
        self.players = []
        self.vsInfo = vsInfo
    }

}
