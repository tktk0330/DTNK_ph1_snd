/*
 
 */

import SwiftUI

final class MatchingState: ObservableObject {
    
    let seatCount: Int
    @Published var message: String
    @Published var players: [Player]

    
    init(seatCount: Int, message: String) {
        self.seatCount = seatCount
        self.message = message
        self.players = []
    }

}
