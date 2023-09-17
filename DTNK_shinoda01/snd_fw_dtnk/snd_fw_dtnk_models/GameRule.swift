


import SwiftUI
import Foundation

struct GameRule {
    
    /**
     マッチング時に生成
     id :　ゲーム固有のID
     deck :　カードデッキ
     sides :　参加者【ゲーム情報】
     players :　参加者【固有情報】
     */
    static var initialState: GameState {
        
        return GameState(
            gameID: "",
            gameNum: 1,
            gameTarget: 1,
            initialRate: 1,
            gamevsInfo: .vsFriend,
            deck:  self.initialDeck)
    }
    
    // Deck
    static var initialDeck: [CardId] {
        return [
            .spade1,
            .spade2,
            .spade3,
            .spade4,
            .spade5,
            .spade6,
            .spade7,
            .spade8,
            .spade9,
            .spade10,
            .spade11,
            .spade12,
            .spade13,
            .club1,
            .club2,
            .club3,
            .club4,
            .club5,
            .club6,
            .club7,
            .club8,
            .club9,
            .club10,
            .club11,
            .club12,
            .club13,
            .heart1,
            .heart2,
            .heart3,
            .heart4,
            .heart5,
            .heart6,
            .heart7,
            .heart8,
            .heart9,
            .heart10,
            .heart11,
            .heart12,
            .heart13,
            .diamond1,
            .diamond2,
            .diamond3,
            .diamond4,
            .diamond5,
            .diamond6,
            .diamond7,
            .diamond8,
            .diamond9,
            .diamond10,
            .diamond11,
            .diamond12,
            .diamond13,
        ]
    }
    
    static var appendJorker2: [CardId] {
        return [
            .whiteJorker1,
            .blackJorker1,
        ]
    }
    
    static var appendJorker4: [CardId] {
        return [
            .whiteJorker1,
            .blackJorker1,
            .whiteJorker2,
            .blackJorker2,
        ]
    }

    
    static var initialSides: [GameSide] {
        return [
            .init(
                seat: .s1,
                score: 0,
                hand: []
            ),
            .init(
                seat: .s2,
                score: 0,
                hand: []
            ),
            .init(
                seat: .s3,
                score: 0,
                hand: []
            ),
            .init(
                seat: .s4,
                score: 0,
                hand: []
            ),
        ]
    }
    
    static var initialgameStep:  GameStep {
        return .dealcard
    }
    
    
    static var initialplayers: [Player] {
        
        var players: [Player] = []

        //myaccount
        let myaccount = Player(id: "my", side: 1, name: "user", icon_url: "icon-bot1")
        players.append(myaccount)

        
        let allBots = BotUserList().botUsers().shuffled()
        //ゲーム人数分botをセットする
        for i in 2...4 {
            //
            let bot = allBots[i]
            let player = Player(
                id: "",
                side: i,
                name: bot.name,
                icon_url: bot.icon_url)
            players.append(player)
        }
        return players
    }


    
}

