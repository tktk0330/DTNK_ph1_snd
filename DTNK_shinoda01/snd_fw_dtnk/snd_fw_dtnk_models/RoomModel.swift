

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

/**
RoomType
参加タイプ
*/
enum RoomType: Int {
    case base = 0
    case create = 1
    case participate = 2
}
