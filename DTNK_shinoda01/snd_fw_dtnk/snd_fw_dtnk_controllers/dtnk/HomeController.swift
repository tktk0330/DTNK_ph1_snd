


import SwiftUI

struct HomeController {
    
    func onTapPlay() {
        Router().onOpenMenu()
    }
    
    func onTapStart(gamenum: Int, rate: Int, jorker: Int) {
        let eventController = GameEventController()
        eventController.play(gamenum: gamenum, rate: rate, jorker: jorker)
        Router().onCloseMenu()
    }
    
    func onTapIcon(){
        appState.home.mode = .edittingIcon
    }
    
    func onTapNickname(){
        appState.home.mode = .edittingNickname
    }
    
    func onTapRule(){
        Router().pushBasePage(pageId: .rule)

//        appState.home.mode = .checkrule
    }
    
    func onTapShop(){
        appState.home.mode = .checkshop
    }
    
    func onTapOption(){
        appState.home.mode = .checkoption
    }
    func onTapBack(){
        Router().pushBasePage(pageId: .home)
    }
}
