


import SwiftUI

struct RoomController {
    
    func onOpenMenu(animated: Bool = false) {
        DispatchQueue.main.async {
            if animated {
                withAnimation {
                    appState.room.roommode = .pop
                }
            } else {
                appState.room.roommode = .pop
            }
        }
    }
    
    func onCloseMenu(animated: Bool = false) {
        DispatchQueue.main.async {
            if animated {
                withAnimation {
                    appState.room.roommode = .base
                }
            } else {
                appState.room.roommode = .base
            }
        }
    }
    
    
    
    
}
