/**
 Botリスト
 */

import SwiftUI

struct BotUserList {
    func botUsers() -> [Player_f] {
        return [
            .init(id: "aaa", side: 99, name: "Liam", icon_url: "icon-bot1"),
            .init(id: "bbb", side: 99, name: "Olivia", icon_url: "icon-bot2"),
            .init(id: "ccc", side: 99, name: "Lucas", icon_url: "icon-bot3"),
            .init(id: "ddd", side: 99, name: "Emma", icon_url: "icon-bot4"),
            .init(id: "eee", side: 99, name: "Harry", icon_url: "icon-bot5"),
            .init(id: "fff", side: 99, name: "Alice", icon_url: "icon-bot9")
        ]
    }
}
