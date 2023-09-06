


import SwiftUI

let appState: AppState = AppState()

final class AppState {
    
    // ページ遷移
    var routing: RoutingState
    // ローディング
    var loading: LoadingState
    // スプラッシュ
    var splash: SplashState!
    // ホームタブ
    var home: HomeState
    // アカウント
    var account: AccountState
    // ルーム
    var room: RoomState
    // マッチング
    var matching: MatchingState!
    
    var gamesystem: GameSystemState!
    // Game
    var gameUIState: GameUIState!
    
    var subState: SubState!

    var resultState: ResultState!
    
    init(
        pageRoute: RoutingState,
        loading: LoadingState,
        splash: SplashState?,
        home: HomeState,
        account: AccountState,
        room: RoomState,
        matching: MatchingState?,
        gamesystem: GameSystemState?,
        gameUIState: GameUIState?,
        subState: SubState?,
        resultState: ResultState?
    ) {
        self.routing = pageRoute
        self.loading = loading
        self.splash = splash
        self.home = home
        self.account = account
        self.room = room
        self.matching = matching
        self.gamesystem = gamesystem
        self.gameUIState = gameUIState
        self.subState = subState
        self.resultState = resultState
    }
    init() {
        self.routing = RoutingState()
        self.loading = LoadingState()
        self.splash = SplashState()
        self.home = HomeState()
        self.account = AccountState()
        self.room = RoomState()
        self.matching = nil
        self.gamesystem = nil
        self.gameUIState = GameUIState()
        self.subState = nil
        self.resultState = nil
    }
}
