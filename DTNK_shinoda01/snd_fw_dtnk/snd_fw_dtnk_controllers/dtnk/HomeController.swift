


import SwiftUI
import RealmSwift

struct HomeController {
    
    func onTapPlay() {
        Router().pushBasePage(pageId: .gameSetting)
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
    
    func onTapPageBtn(page: PageId) {
        Router().pushBasePage(pageId: page)
    }
    
    func onTapBack(){
        Router().pushBasePage(pageId: .home)
    }
    
    // 入室時処理
    func enterHome() {
        // realm
        LifeMng().getLifeInfo()
        let lifeItem = GameCommonFunctions().calcuLife(life: appState.account.loginUser.life, lifeTime: appState.account.loginUser.lifeTime, lastUpdated: appState.account.loginUser.lastUpdated)
        appState.account.loginUser.life = lifeItem.0
        appState.account.loginUser.lifeTime = lifeItem.1
        appState.account.loginUser.lastUpdated = lifeItem.2
        
    }
    
    // 退室処理
    func exitHome() {
        appState.account.loginUser.lastUpdated = Date()
        // realm
        LifeMng().setLifeInfo()
        
        HomeFireBaseMng().setLifeInfo() { reault in }

    }
    
    /**
     ユーザー編集
     */
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
    
    // ゲーム設定変更
    func updateGameSetting<T: Numeric>(keyPath: WritableKeyPath<User, T>, item: String, value: T) {
        appState.account.loginUser[keyPath: keyPath] = value
        // IntにキャストしてRealmのアップデートを行う。この例ではTがIntとしてキャストできることを前提としています。
        if let intValue = value as? Int {
            RealmMng().updateGameSettingRealm(userId: appState.account.loginUser.userID, item: item, value: intValue) { result in }
        }
    }
    
    /**
     ライフ処理
     */
    // ライフ秒数
    func lifeCoundDown() {
        if appState.account.loginUser.lifeTime > 0 {
            appState.account.loginUser.lifeTime -= 1
        } else if appState.account.loginUser.life < Constants.lifeMax {
            HomeController().recoverLife() { result in
                if result {
                    if appState.account.loginUser.life < Constants.lifeMax { // 最大ライフに達していない場合、カウントダウンを再開
                        appState.account.loginUser.lifeTime = Constants.lifeTime
                    }
                }
            }
        }
    }
    
    // ライフの消費
    func useLife(completion: @escaping (Bool) -> Void) {
        // front
        appState.account.loginUser.life -= 1
        // realm
        if let realm = try? Realm(), let user = realm.objects(RealmUser.self).first {
            let manager = LifeManager(user: user)
            if manager.consumeLifeForGame() {
                // ゲームを開始
                
            } else {
                // ライフが足りない場合のアラート
                log("ライフが足らないです")
            }
        }
        
        // 残り時間の設定
        if appState.account.loginUser.lifeTime == 0 {
            appState.account.loginUser.lifeTime = Constants.lifeTime
        }
        
        completion(true)
    }

    
    // ライフの回復
    func recoverLife(completion: @escaping (Bool) -> Void) {
        
        // realm
        if let realm = try? Realm(), let user = realm.objects(RealmUser.self).first {
            let manager = LifeManager(user: user)
            manager.recoverLifeRealm()
        }
        // front
        appState.account.loginUser.life += 1
        completion(true)
    }
}
