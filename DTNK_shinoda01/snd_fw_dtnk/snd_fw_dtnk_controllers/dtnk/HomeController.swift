


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
    
    
    func onTapBackMode(){
        appState.home.mode = .noEditting
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
    func onTapRuleSetting(){
           Router().pushBasePage(pageId: .ruleSetting)
       }
    
    func onTapShop(){
        appState.home.mode = .checkshop
    }
    
    func onTapOption(){
        Router().pushBasePage(pageId: .option)
        
    }
    func onTapBack(){
        Router().pushBasePage(pageId: .home)
    }
    
    // 名前変更
    func updateName(newName: String) {
        // FB
        HomeFireBaseMng().upDateUserName(newUsername: newName) { result in
            if result {
                // Realm
                RealmMng().updateUsernameInRealm(userId: appState.account.loginUser.userID, newUsername: newName) { result in
                    if result {
                        appState.account.loginUser.name = newName
                    }
                }
            }
        }
    }
    
    // Icon変更
    func updateIcon(iconURL: String) {
        // FB
        HomeFireBaseMng().upDateIcon(iconURL: iconURL) { result in
            if result {
                // Realm
                RealmMng().updateIconInRealm(userId: appState.account.loginUser.userID, iconURL: iconURL) { result in
                    if result {
                        appState.account.loginUser.iconURL = iconURL
                    }
                }
            }
        }
    }

}
