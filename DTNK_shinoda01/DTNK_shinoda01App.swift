//
//  DTNK_shinoda01App.swift
//  DTNK_shinoda01
//
//  Created by Takuma Shinoda on 2023/06/25.
//

import SwiftUI
import FirebaseCore
import RealmSwift

//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//
//    let config = Realm.Configuration(
//      schemaVersion: 1,
//      migrationBlock: { migration, oldSchemaVersion in
//        if (oldSchemaVersion < 1) {
//          // Do nothing.
//        }
//    })
//    Realm.Configuration.defaultConfiguration = config
//
//    return true
//  }
//}

@main
struct DTNK_shinoda01App: SwiftUI.App {  // SwiftUI.Appを指定
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var loading: LoadingState = appState.loading

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
