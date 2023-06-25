


import SwiftUI

final class HomeState: ObservableObject {
    
    @Published var mode: HomeMode = .noEditting
    @Published var nickname: String = ""
    @Published var iconURL: String = ""
    
    init(mode: HomeMode = .noEditting,
         nickname: String = "",
         iconURL: String = "") {
        self.mode = mode
        self.nickname = nickname
        self.iconURL = iconURL
    }
}
