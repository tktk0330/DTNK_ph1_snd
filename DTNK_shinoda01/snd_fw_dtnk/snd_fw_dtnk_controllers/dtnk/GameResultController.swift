


import SwiftUI

struct GameResultController {
    
    func onTapPlay() {
        
        appState.gamesystem = nil
        appState.resultState = nil
        
        Router().pushBasePage(pageId: .home)
    }

}
