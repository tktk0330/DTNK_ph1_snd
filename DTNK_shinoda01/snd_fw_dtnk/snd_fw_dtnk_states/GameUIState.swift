//
//  GameUIState.swift
//  DTNK_shinoda01
//
//  Created by Takuma Shinoda on 2023/07/15.
//

import SwiftUI

class GameUIState: ObservableObject {
    
    @Published var gameID: String = ""
    @Published var players: [Player_f] = []
    @Published var deck: [CardId] = []

}

class Player_f: Identifiable {
    let id: String
    var side: Int
    var name: String
    var icon_url: String
    var hand: [CardId] = []
    var score = 0
    var dtnk: Bool
    var selectedCards: [CardId] = []
    
    init(id: String, side: Int, name: String, icon_url: String) {
        self.id = id
        self.side = side
        self.name = name
        self.icon_url = icon_url
        self.score = 0
        self.dtnk = false

    }
}
