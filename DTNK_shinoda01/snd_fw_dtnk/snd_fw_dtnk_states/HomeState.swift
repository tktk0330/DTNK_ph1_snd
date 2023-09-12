import SwiftUI

struct HeartsData: Codable {
    var heartsCount: Int
    var remainingTime: TimeInterval
    var showAlert: Bool
}

final class HomeState: ObservableObject {
    @Published var mode: HomeMode = .noEditting
    @Published var nickname: String = ""
    @Published var iconURL: String = ""
    @Published var heartsData: HeartsData
    @Published var ruleSet: Int = 0
    
    init(mode: HomeMode = .noEditting,
         nickname: String = "",
         iconURL: String = "",
         heartsData: HeartsData = HeartsData(heartsCount: 5, remainingTime: 300, showAlert: false),
         ruleSet: Int = 0) {
        self.mode = mode
        self.nickname = nickname
        self.iconURL = iconURL
        self.heartsData = heartsData // ここではデフォルト値をそのまま設定
        self.ruleSet = ruleSet
    }
    
}
