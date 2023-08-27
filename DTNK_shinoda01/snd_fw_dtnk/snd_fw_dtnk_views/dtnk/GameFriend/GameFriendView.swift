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
            Group {
                // ForcusAnimation
                if game.currentPlayerIndex != 99 && (game.gamePhase == .main) {
                    TargetPlayerView()
                        .position(x: TargetPlayerView().focusPosition(side: game.currentPlayerIndex).x,
                                  y: geo.size.height * TargetPlayerView().focusPosition(side: game.currentPlayerIndex).y)
                        .animation(.easeInOut(duration: 0.5), value: game.currentPlayerIndex)
                }
                
                // ScoreBar
                Group {
                    Text(String(game.players[myside].score))
                        .modifier(PlayerScoreModifier())
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.58)
                    
                    Text(String(game.players[(myside + 1) % game.players.count].score))
                        .modifier(PlayerScoreModifier())
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.60)
                        .rotationEffect(Angle(degrees: 90))
                    
                    Text(String(game.players[(myside + 2) % game.players.count].score))
                        .modifier(PlayerScoreModifier())
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.42)
                                        
                    Text(String(game.players[(myside + 3) % game.players.count].score))
                        .modifier(PlayerScoreModifier())
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.60)
                        .rotationEffect(Angle(degrees: -90))
                }
            }
                        
            // Card Pool
            HStack() {
                ZStack {
                    ForEach(Array(game.cardUI.enumerated()), id: \.1.id) { index, card in
                        N_CardView(card: card, location: card.location, selectedCards: $game.players[myside].selectedCards)
                            .animation(.easeInOut(duration: 0.3))
                    }
                }
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)

            // Btn
            Group {
                HStack(spacing: 15) {
                    
                    if game.turnFlg == 0 {
                        Button(action: {
                            GameFriendEventController().draw(playerID: game.players[myside].id, playerIndex: myside)
                        }) {
                            Btnaction(btnText: "引く", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightYellow)
                        }
                    } else {
                        Button(action: {
                            GameFriendEventController().pass(passPayerIndex: myside, playersCount: game.players.count)
                        }) {
                            Btnaction(btnText: "パス", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightBlue)
                        }
                    }
                                        
                    // testようにボタンとして動かしておく
                    Button(action: {
                        // dtnk
                        GameFriendEventController().dtnk(Index: myside, dtnkPlayer: game.players[myside])
                    }) {
                        // icon
                        // TODO: 磨き上げ
                        Image(game.players[myside].icon_url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60)
                            .cornerRadius(10)
                            .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
                    }
                    
                    Button(action: {
                        GameFriendEventController().play(playerID: game.players[myside].id, selectCrads: game.players[myside].selectedCards, passPayerIndex: myside) { result in
                            if result {
                                game.players[myside].selectedCards = []
                            } else {
                            }
                        }
                    }) {
                        Btnaction(btnText: "出す", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightRed)
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.9)
            }
                                    
            Group {
                Group {
                    // 広告用
                    Rectangle()
                        .foregroundColor(Color.white.opacity(0.3))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(Color.casinoGreen)
                        .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                    
                    // Rate
                    RateView(gamenum: game.gameNum, rate: game.initialRate, magnification: game.ascendingRate)
                        .background(Color.casinoGreen)
                        .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.09)
                }
                Group {
                    // ゲーム数アナウンス
                    if game.gamePhase == .dealcard {
                        GmaeNumAnnounce(gameNum: game.gameNum, gameTarget: game.gameTarget)
                            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height / 2)
                    }
                    // 開始ボタン
                    if game.startFlag && !game.AnnounceFlg {
                        Button(action: {
                            game.startFlag = false
                            fbms.setGamePhase(gamePhase: .countdown) { result in
                            }
                        }) {
                            Text("Start")
                                .font(.custom(FontName.font01, size: 30))
                        }
                        .buttonStyle(ShadowButtonStyle())
                        .frame(width: 100, height: 100)
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
                    }
                    // CountDown
                    if game.gamePhase == .countdown {
                        Countdown02View()
                            .scaleEffect(2.0)
                            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
                    }
                    
                    // 仮想View 初期カード設置
                    Text("").onReceive(game.$counter) { newValue in
                        if newValue {
                            gameObserber.firstCard()
                        }
                    }
                    // レートアップアナウンス
                    if game.rateUpCard != nil {
                        RateUpAnnounce(cardImage: game.rateUpCard!) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                gameObserber.firstCard()
                                game.rateUpCard = nil
                            }
                        }
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height / 2)
                    }
                }
                
                // DTNK View
                if game.gamePhase == .dtnk {
                    DTNKView(text: "DOTENKO")
                }
                // チャレンジ可否ポップ
                if game.gamePhase == .q_challenge {
                    ChallengePopView(Index: myside, vsInfo: game.gamevsInfo!)
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
                        .transition(.move(edge: .top))
                        .animation(.default, value: game.gamePhase == .q_challenge)
                }
                // チャレンジロゴ
                // TODO: 配置諸々考える
                if game.gamePhase == .challenge {
                    MovingImage()
                }
                                
                if appState.subState != nil && game.gamePhase == .decisionrate {
                    DecisionScoreView()
                }
                
                if game.gamePhase == .result {
                    ResultView()
                }
                
                if game.gamePhase == .waiting {
                    WaitingView()
                }
                
            }
        } .onAppear {
            // サイド設定
            game.myside = self.myside
            // ゲーム情報取得
            fbm.getGameInfo(from: room.roomData.roomID) { info in
                game.gameID = info!.gameID
                game.gameNum = info!.gameNum
                game.gameTarget = info!.gameTarget
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
//                if game.table.count > 1 {
//                    gameObserber.regenerateDeck(table: game.table)
//                }
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
                print("テーブル取得エラー")
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
        for s in 0..<game.players.count {
            // rank & score
            fbms.observeRankAndScore(playerIndex: String(s)) { rank, score in
                game.players[s].rank = rank
                game.players[s].score = score
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
        // challengeAnswers
        fbms.observeChallengeAnswer() { challengeAnswers in
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
            } else {
//                print("Error retrieving result item.")
            }
        }
        fbms.observeGameNum() { gameNum in
            game.gameNum = gameNum!
        }
        fbms.observeWinnersLosers() { winners, losers in
            game.winners = winners
            game.losers = losers
        }
        fbms.observeRateUpCard() { cardsImage in
            game.rateUpCard = cardsImage
        }
    }
}

struct PlayerScoreModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontName.font01, size: 20))
            .foregroundColor(Color.white)
            .background(
                Rectangle()
                    .fill(Color.casinoShadow)
                    .frame(width: UIScreen.main.bounds.width * 0.37, height: 23)
            )
    }
}


// TODO: 正しい場所へ
struct N_Card: Equatable {
    let id: CardId
    var location: CardLocation
}

struct N_CardView: View {
    var card: N_Card
    let location: CardLocation
    @Binding var selectedCards: [N_Card]
    
    var body: some View {
        Image(card.id.imageName())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60)
            .rotationEffect(Angle(degrees: card.id.angle(for: location, total: card.id.total(for: card.location))))
            .offset(card.id.location(for: location, total: card.id.total(for: card.location))) // 'total'を引数として渡す
            .offset(y: selectedCards.contains(card) ? -20 : 0)
            .onTapGesture {
                // 自分の手札のみTap可能
                if case let .hand(playerIndex, _) = card.location, case playerIndex = appState.gameUIState.myside {
                    if let idx = selectedCards.firstIndex(of: card) {
                        selectedCards.remove(at: idx)
                    } else {
                        selectedCards.append(card)
                    }
                }
            }
    }
}
