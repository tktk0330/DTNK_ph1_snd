


import Foundation
import SwiftUI

class BattleSelectController {
    
    func onTapPlay(gamenum: Int, rate: Int, jorker: Int)  {
        
        let eventController = GameEventController()
        eventController.play(gamenum: gamenum, rate: rate, jorker: jorker)
        
    }
}
