/**
PageIDの画面
 
 */

import Foundation
import SwiftUI

struct PageContent: View {
    let id: PageId
    var body: some View {
        return Group {
            switch id {
            case .splash:
                SplashView()
            case .top:
                TopView()
            case .home:
                HomeView()
            case .rule:
                GameRuleView()
            case .rule_select:
                GameResultView()
            case .battle_select:
                GameResultView()
            case .room:
                RoomView()
            case .dtnkMatching:
                MatchingView()
            case .dtnkMain:
//                GameMain()
                GameBotView()
            case .dtnkMain_friends:
                GameFriendView()
            case .dtnkResult:
                GameResultView()
            case .gameresult:
                GameResultView()
            case .gameSet:
                GameSettingView()
            }
        }
    }
}
