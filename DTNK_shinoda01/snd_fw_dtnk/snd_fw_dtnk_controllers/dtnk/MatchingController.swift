


import Foundation
import SwiftUI

class MatchingController {
    
    /**
     GameInfoの設定
     */
    func generateGameInfo(players: [Player]) -> GameInfoModel {
        
        // 参加者
        let players = players
        let deck = GameRule.initialDeck.shuffled
        
        
        let jorker = 2
        let targetgamenum = 3
        let rate = 10
        
        let gameInfo = GameInfoModel(
            players: players,
            deck: deck(),
            joker: jorker,
            targetgamenum: targetgamenum,
            rate: rate)
        
        return gameInfo
    }
    
    /**
     vs Friends
     */
    func onTapStart(players: [Player], roomID: String) {
        
        // Game初期設定
        let gameInfo = generateGameInfo(players: players)
        
        // Stateの作成（バック）
        // player
        let players = appState.matching.players
        // deck
        _ = appState.gameUIState.deck

        var quick:[Player_f] = []
        let matchingplayer = players.last!
        
        quick.append(Player_f(id: matchingplayer.id, side: matchingplayer.side, name: matchingplayer.name, icon_url: matchingplayer.icon_url))
        // UIStateの作成（フロント）
        appState.gameUIState.players = quick
        
        // DBに保存
        FirebaseManager.shared.setGameInfo(gameInfo: gameInfo, roomID: roomID) { gameID in
            if (gameID != nil) {
                // matchingflgをOKに設定　その後遷移
                FirebaseManager.shared.updateMatchingFlg(roomID: roomID)
            } else {
                print("Failed to save game info")
            }
        }
    }
    
    /**
     vsBot
     */
    func onRequest() {
        // プレイヤーをUIへ表示
        appState.matching.message = "ゲームを開始します"
        appState.matching.players = BotCreate().initialplayers()
        // メインゲーム画面へ
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // gameUiStateにプレイヤーをセット
            appState.gameUiState.players = appState.matching.players
            Router().pushBasePage(pageId: .dtnkMain)
        }
    }
    
    /**
     戻る
     */
    // TODO: できていない
    func backMatching(room: Room, user: User) {
        // ownerだったらルームを削除
        if room.hostID == user.userID {
            FirebaseManager().deleteRoom(roomID: room.roomID) { success in
                if success {
                    print("Room deleted successfully")
                    // ルーム削除後の処理
                } else {
                    print("Failed to delete the room")
                }
            }

        } else {
            // 参加者だった退出
            FirebaseManager().leaveRoom(roomID: room.roomID, participantID: user.userID)  { judge in
                if judge {
                    print("sc")
                    Router().pushBasePage(pageId: .room)
                } else {
                    print("er")

                }
            }
        }
    }

}

/**
 vs Bot
 bot生成
 */
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


