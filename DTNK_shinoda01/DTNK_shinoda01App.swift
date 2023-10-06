import SwiftUI
import FirebaseCore
import RealmSwift

@main
struct DTNK_shinoda01App: SwiftUI.App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var networkMng = NetworkManager()
    @Environment(\.scenePhase) private var scenePhase


    var body: some Scene {
        WindowGroup {
            ZStack {
                NaviWindow(state: appState.routing.baseNaviState)
                    .environmentObject(networkMng)
                // ネットワークが切れた場合にエラー画面を表示
                if !networkMng.isConnected {
                    NetworkWaitingView()
                }

                if networkMng.showDisconnectPrompt {
                    DisconnectPromptView {
                        exit(0)  // ユーザーが終了ボタンをクリックしたときのアクション
                    }
                }
            }
            .background(Color.casinoGreen.ignoresSafeArea())
        }
    }
}
