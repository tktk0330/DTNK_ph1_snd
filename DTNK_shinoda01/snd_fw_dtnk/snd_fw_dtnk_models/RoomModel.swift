

import SwiftUI

/**
 RoomModel
 */
struct Room {
    let roomID: String
    let roomName: String
    let hostID: String
    var participants: [Player]
}

/**
 RoomMode
 画面切り替えのため
 */
enum RoomMode: Int {
    case base = 0
    case pop = 1
    case waiting = 2
}
