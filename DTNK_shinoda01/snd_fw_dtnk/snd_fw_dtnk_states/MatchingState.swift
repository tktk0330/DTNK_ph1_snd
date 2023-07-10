/**
 
 */

import SwiftUI

final class MatchingState: ObservableObject {
    
    let seatCount: Int
    @Published var message: String
    @Published var players: [Player]
    @Published var vsInfo: Int
    
    init(seatCount: Int, message: String, vsInfo: Int) {
        self.seatCount = seatCount
        self.message = message
        self.players = []
        self.vsInfo = vsInfo
    }

}
