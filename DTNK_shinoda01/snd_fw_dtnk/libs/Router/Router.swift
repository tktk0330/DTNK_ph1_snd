


import SwiftUI

struct Router {
    
    /**
     基本の画面遷移
     */
    func setBasePages(stack: [PageId], animated: Bool = true) {
        DispatchQueue.main.async {
            if animated {
                withAnimation {
                    appState.routing.baseNaviState.stack = stack
                }
            } else {
                appState.routing.baseNaviState.stack = stack
            }
        }
    }
    
    func pushBasePage(pageId: PageId, animated: Bool = true) {
        DispatchQueue.main.async {
            if animated {
                withAnimation {
                    appState.routing.baseNaviState.stack.append(pageId)
                }
            } else {
                appState.routing.baseNaviState.stack.append(pageId)
            }
        }
    }
    
    /**
     一部表示
     */
    func onOpenMenu(animated: Bool = false) {
        DispatchQueue.main.async {
            if animated {
                withAnimation {
                    appState.home.mode = .gamesetting
                }
            } else {
                appState.home.mode = .gamesetting
            }
        }
    }
    
    func onCloseMenu(animated: Bool = false) {
        DispatchQueue.main.async {
            if animated {
                withAnimation {
                    appState.home.mode = .noEditting
                }
            } else {
                appState.home.mode = .noEditting
            }
        }
    }


}

