


import SwiftUI
import Foundation

struct BotUserList {
    func botUsers() -> [Player] {
        return [
            .init(id: "aaa", side: 99, name: "石川", icon_url: "icon-bot1"),
            .init(id: "bbb", side: 99, name: "小川", icon_url: "icon-bot2"),
            .init(id: "ccc", side: 99, name: "こんどう", icon_url: "icon-bot3"),
            .init(id: "ddd", side: 99, name: "SHIGEM", icon_url: "icon-bot4"),
            .init(id: "eee", side: 99, name: "シノダ", icon_url: "icon-bot5"),
            .init(id: "fff", side: 99, name: "maxnam", icon_url: "icon-bot9")
            
        ]
    }
}
