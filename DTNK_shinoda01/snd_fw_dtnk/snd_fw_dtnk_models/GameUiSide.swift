/*

 */
import SwiftUI

final class GameUiSide: ObservableObject {

    let seat: PlayerSeat

    @Published var hand: [Card]?
    @Published var playerNickname: String = "--"
    @Published var playerIconUrl: String = ""
    @Published var point: Int = 0



    init(seat: PlayerSeat) {
        self.seat = seat
    }

}

//人数に伴って増やす
enum PlayerSeat: Int {
    case s1 = 1
    case s2 = 2
    case s3 = 3
    case s4 = 4
}
