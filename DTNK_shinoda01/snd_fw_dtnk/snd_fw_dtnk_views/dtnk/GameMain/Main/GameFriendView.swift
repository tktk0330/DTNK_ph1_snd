/**
 友達対戦　メイン画面
 */

import SwiftUI

struct GameFriendView: View {
    
    @StateObject var game: GameUIState = appState.gameUIState
    @StateObject var room: RoomState = appState.room
    let gameObserber = GameObserber(hostID: appState.room.roomData.hostID)
    let fbm = FirebaseManager()
    let fbms = FirebaseManager.shared
    // mysideをプロパティとして定義します
    var myside: Int {
        let id = appState.account.loginUser.userID
        let players =  appState.gameUIState.players
        let myIndex = players.firstIndex(where: { $0.id == id })
        return myIndex!
    }

    var body: some View {
        GeometryReader { geo in
            
            TargetPlayerPositionView(game: game, geo: geo)
            CardPoolView(game: game, myside: myside, geo: geo, selectedCards: $game.players[myside].selectedCards)
            ScoreBarView(game: game, myside: myside, geo: geo)
            OtherPlayerIconsView(game: game, myside: myside, geo: geo)
            PlayerCardsCountView(game: game, myside: myside, geo: geo)
            GameButtonView(game: game, myside: myside, geo: geo)
            Header(game: game, geo: geo)
            GameEventView(game: game, myside: myside, geo: geo, fbms: fbms)
            Group {
                
                // Challenge関連
                // 開始
                if game.gamePhase == .startChallenge {
                    ChallengeActionAnnounce(text: "Challenge ZONE\nStart") {
                        // チャレンジへ
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            game.setGamePhase(gamePhase: .challenge)
                        }
                    }
                    .position(x: Constants.scrWidth * 0.50, y:  geo.size.height / 2)
                }
                // Challenger
                if game.nextChallengerIndex != nil {
                    ChallengeActionAnnounce(text: "\(game.players[game.nextChallengerIndex!].name) のChallenge") {
                        // チャレンジへ
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            game.nextChallengerIndex = nil
                        }
                    }
                    .position(x: Constants.scrWidth * 0.50, y:  geo.size.height / 2)

                }
                // Over
                
                // どてんこ返し(in challenge)
                if game.revengerIndex != nil {
                    RevengeAnnounce() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            game.revengeInChallenge()
                        }
                    }
                    .id(game.revengerIndex)
                    .position(x: Constants.scrWidth * 0.50, y:  geo.size.height / 2)
                }
                
                // 終了
                if game.gamePhase == .endChallenge  {
                    ChallengeActionAnnounce(text: "Challenge ZONE\nEnd") {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            // 最終結果へ
                            game.setGamePhase(gamePhase: .decisionrate_pre)
                        }
                    }
                    .position(x: Constants.scrWidth * 0.50, y:  geo.size.height / 2)
                }
                
                // レートアップアナウンス
                if game.rateUpCard != nil {
                    RateUpAnnounce(cardImage: game.rateUpCard!) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            gameObserber.firstCard()
                            game.ascendingRate += game.ascendingRate
                            game.rateUpCard = nil
                        }
                    }
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height / 2)
                }
                // デッキ再生成
                if game.regenerationDeckFlg == 1 {
                    RegenerationDeck() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            game.regenerationDeckFlg = 0
                        }
                    }
                    .id(game.regenerationDeckFlg)
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height / 2)
                }
                // スコア
                if appState.subState != nil && game.gamePhase == .decisionrate {
                    DecisionScoreView()
                }
            }
            GameHelpGroupView(game: game, geo: geo)

        }
        .gameBackground()
        .onAppear {
            // サイド設定
            game.myside = self.myside
            GameMainController().initFunction()
            // ゲーム情報取得
            fbm.getGameInfo(from: room.roomData.roomID) { info in
                game.gameID = info!.gameID
                game.gameNum = info!.gameNum
                game.gameTarget = info!.gameTarget
                game.initialRate = info!.initialRate
                game.gamevsInfo = info!.gamevsInfo
                game.deck = info!.deck
                FirebaseManager.shared.setIDs(roomID: room.roomData.roomID, gameID: info!.gameID)
                // 情報取得
                getGameInfo()
            }
        }
    }
    // いろんな情報取得
    func getGameInfo() {
        // deck
        fbms.observeDeckInfo() { cards in
            if (cards != nil) {
                if let cardsUnwrapped = cards {
                    for deckCard in cardsUnwrapped {
                        if let index = game.cardUI.firstIndex(where: { $0.id.rawValue == deckCard.id }) {
                            var newCard = game.cardUI.remove(at: index)
                            // 新しい位置を設定
                            newCard.location = .deck
                            game.cardUI.append(newCard)
                        }
                    }
                }
                game.deck = cards!
            } else {
                // ゲーム中であれば再生成します
                if game.table.count > 1 {
                    gameObserber.regenerateDeck(table: game.table)
                }
            }
        }
        // table
        fbms.observeTableInfo() { cards in
            if (cards != nil) {
                if let cardsUnwrapped = cards {
                    for tableCard in cardsUnwrapped {
                        if let index = game.cardUI.firstIndex(where: { $0.id.rawValue == tableCard.id }) {
                            var newCard = game.cardUI.remove(at: index)
                            // 新しい位置を設定
                            newCard.location = .table
                            game.cardUI.append(newCard)
                        }
                    }
                }
                game.table = cards!
            } else{
                log("table is 0")
            }
        }
        // gamePhase
        fbms.observeGamePhase() { gamePhase in
            if (gamePhase != nil) {
                game.gamePhase = gamePhase!
            }
        }
        // currentPlayerIndex
        fbms.observeCurrentPlayerIndex() { currentPlayerIndex in
            if (currentPlayerIndex != nil) {
                game.currentPlayerIndex = currentPlayerIndex!
            }
        }
        // nextChallengerIndex
        fbms.observeNextChallengerIndex() { nextChallengerIndex in
            if (nextChallengerIndex != nil) {
                game.nextChallengerIndex = nextChallengerIndex!
            }
        }
        // revengerIndex
        fbms.observesetRevengerIndex() { revengerIndex in
            if (revengerIndex != nil) {
                game.revengerIndex = revengerIndex!
            }
        }

        for s in 0..<game.players.count {
            // rank & score
            fbms.observeRankAndScore(playerIndex: String(s)) { rank, score in
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    game.players[s].rank = rank
                    game.players[s].score = score
                }
            }
            // hand
            fbms.observeHandInfo (
                playerIndex: String(s)) { cards in
                    var i = 0
                    if let cardsUnwrapped = cards {
                        for newhandcard in cardsUnwrapped {
                            // まず新しい手札を配列から見つけ出し
                            if let index = game.cardUI.firstIndex(where: { $0.id.rawValue == newhandcard.id }) {
                                var newCard = game.cardUI.remove(at: index)
                                // 新しい位置を設定
                                newCard.location = .hand(playerIndex: s, cardIndex: i)
                                i += 1;
                                // 新しい手札を一番最後に追加
                                game.cardUI.append(newCard)
                            }
                        }
                        game.players[s].hand = cards!
                    } else{
                        game.players[s].hand = []
                    }
                    log("Index: \(s)  hand: \(game.players[s].hand)")
                }
        }
        // lastPlayerIndex
        fbms.observeLastPlayerIndex() { lastPlayerIndex in
            game.lastPlayerIndex = lastPlayerIndex!
        }
        // DTNKInfo
        fbms.observeDTNKInfo() { Index, player in
            game.dtnkPlayerIndex = Index!
            game.dtnkPlayer = player
        }
        // DTNKInfo
        fbms.observeBurstPlayerIndex() { Index in
            game.burstPlayerIndex = Index!
        }
        // 初期回答
        fbms.observeFirstAnswers() { firstAnswers in
            game.firstAnswers = firstAnswers
            if firstAnswers.allSatisfy({ $0 != .initial }) {
                gameObserber.firstAnswers()
            }
        }
        // challengeAnswers
        fbms.observeChallengeAnswer() { challengeAnswers in
            print("\(challengeAnswers)")
            game.challengeAnswers = challengeAnswers
            if challengeAnswers.allSatisfy({ $0 != .initial }) {
                gameObserber.challengeAnswers()
            }
        }
        fbms.observeNextGameAnnouns() { announce in
            game.nextGameAnnouns = announce
            if announce.allSatisfy({ $0 != .initial }) {
                gameObserber.nextGameAnnounce()
            }
        }
        // スコア決定・途中結果 Item
        fbms.observeResultItem() { resultItem in
            if let result = resultItem {
                appState.subState = SubState(resultItem: result)
                game.gameScore = resultItem!.gameScore
            }
        }
        fbms.observeGameNum() { gameNum in
            game.gameNum = gameNum!
        }
        fbms.observeWinnersLosers() { winners, losers in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                game.winners = winners
                game.losers = losers
            }
        }
        fbms.observeRateUpCard() { cardsImage in
            game.rateUpCard = cardsImage
        }
        fbms.observeAscendingRate() { rate in
            game.ascendingRate = rate!
            print("\(game.ascendingRate)")
        }
        RoomFirebaseManager.shared.observeMatchingFlg(roomID: room.roomData.roomID) { result in
            if result == 2 {
                // 誰かが退出したのでゲームを終了する
                game.gameMode = .exit
            }
        }
    }
}
