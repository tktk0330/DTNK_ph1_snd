//
//  DTNK_shinoda01App.swift
//  DTNK_shinoda01
//
//  Created by Takuma Shinoda on 2023/06/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct DTNK_shinoda01App: App {
    
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
