//
//  MatchingController.swift
//  Dtnk-ver002
//
//  Created by Takuma Shinoda on 2023/06/02.
//

import Foundation
import SwiftUI

class MatchingController {
    
    func onRequest() {
        // State を作成
        let state = GameRule.initialState
        // プレイヤーをUIへ表示
        appState.matching.message = "ゲームを開始します"
        appState.matching.players = BotCreate().initialplayers()
        //gameStateの作成
        let gameSystemState = GameSystemState(
            gameState: state,
            players: appState.matching.players
        )
        appState.gamesystem = gameSystemState
                
        // メインゲーム画面へ
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // gameUiStateにプレイヤーをセット
            appState.gameUiState.players = appState.matching.players
            Router().pushBasePage(pageId: .dtnkMain)
        }
    }
}

class BotCreate {
    
    func initialplayers() -> [Player] {
        
        var players: [Player] = []
        //myaccount
        let myaccount = Player(id: "xxx", side: 1, name: "user", icon_url: "icon-bot1")
        players.append(myaccount)

        let allBots = BotUserList().botUsers().shuffled()
        //ゲーム人数分botをセットする
        for i in 2...4 {
            let bot = allBots[i]
            let player = Player(id: "", side: i, name: bot.name, icon_url: bot.icon_url)
            players.append(player)
        }
        return players
    }
}


