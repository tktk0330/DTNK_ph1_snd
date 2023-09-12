//
//  DTNK_shinoda01App.swift
//  DTNK_shinoda01
//
//  Created by Takuma Shinoda on 2023/06/25.
//

import SwiftUI
import FirebaseCore
import RealmSwift

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    let config = Realm.Configuration(
      schemaVersion: 1,
      migrationBlock: { migration, oldSchemaVersion in
        if (oldSchemaVersion < 1) {
          // Do nothing.
        }
    })
    Realm.Configuration.defaultConfiguration = config

    return true
  }
 
    func applicationDidEnterBackground(_ application: UIApplication) {
            // アプリがバックグラウンドに入るときにハート情報を保存
        let heartsData = HeartsData(heartsCount: appState.home.heartsData.heartsCount, remainingTime: appState.home.heartsData.remainingTime, showAlert: false)
            HeartsDataManager.shared.saveHeartsData(heartsData)
        }
        
        func applicationDidBecomeActive(_ application: UIApplication) {
            // アプリがアクティブになったときにハート情報を復元
            if let savedHeartsData = HeartsDataManager.shared.loadHeartsData() {
                appState.home.heartsData.heartsCount = savedHeartsData.heartsCount
                appState.home.heartsData.remainingTime = savedHeartsData.remainingTime
            }
        }
}



@main
struct DTNK_shinoda01App: SwiftUI.App {  // SwiftUI.Appを指定
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var loading: LoadingState = appState.loading
    @StateObject var heartsRecoverController: HeartsRecoverController =  HeartsRecoverController.shared // 新たに追加

    var body: some Scene {
        WindowGroup {
            ZStack {
                NaviWindow(state: appState.routing.baseNaviState)
                LoadingView(loading.loadingTasks)
            }
            .background(
                //basebackgroundが設定される
                Color.casinoGreen
                    .ignoresSafeArea(.all)
            )
        }
    }
}
