
import SwiftUI


struct HomeController {
    var heartsController = HeartsRecoverController.shared
    
    func onTapPlay() {
        Router().onOpenMenu()
    }
    
    func hasHeartSoloPlay() {
        if appState.home.heartsData.heartsCount > 0 {
            // ハートが0より大きい場合はゲームを開始する
            // ゲームの開始処理をここに記述する
            Router().pushBasePage(pageId: .gameSet)
        } else {
            // ハートが0の場合はアラートを表示する
            appState.home.heartsData.showAlert = true
        }
    }
    
    func hasHeartMultiPlay() {
        if appState.home.heartsData.heartsCount > 0 {
            // ハートが0より大きい場合はゲームを開始する
            // ゲームの開始処理をここに記述する
            Router().pushBasePage(pageId: .room)
        } else {
            // ハートが0の場合はアラートを表示する
            appState.home.heartsData.showAlert = true
        }
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
