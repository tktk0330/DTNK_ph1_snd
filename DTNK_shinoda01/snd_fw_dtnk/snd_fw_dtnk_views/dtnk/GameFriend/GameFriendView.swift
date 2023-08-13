


import SwiftUI

struct GameFriendView: View {
    @StateObject var game: GameUIState = appState.gameUIState
    @StateObject var room: RoomState = appState.room
    let gameObserber = GameObserber(hostID: appState.room.roomData.hostID)
    let fbm = FirebaseManager()
    let fbms = FirebaseManager.shared

    // CardPool
    @State var cardUI: [N_Card] = cards
    // mysideをプロパティとして定義します
    var myside: Int {
        let id = appState.account.loginUser.userID
        let players =  appState.gameUIState.players
        let myIndex = players.firstIndex(where: { $0.id == id })
        return myIndex!
    }
    @State var startFlag: Bool = false

    var body: some View {
        GeometryReader { geo in
            
            Group {
                // 仮想View 初期カード設置
                Text("").onReceive(game.$counter) { newValue in
                    if newValue {
                        gameObserber.firstCard(roomID: room.roomData.roomID, gameID: game.gameID)
                    }
                }
                
                // ForcusAnimation
                if game.currentPlayerIndex != 99 {
                    TargetPlayerView()
                        .position(x: TargetPlayerView().focusPosition(side: game.currentPlayerIndex).x,
                                  y: geo.size.height * TargetPlayerView().focusPosition(side: game.currentPlayerIndex).y)
                        .animation(.easeInOut(duration: 0.5), value: game.currentPlayerIndex)
                }
                
                // ScoreBar
                ScoreBar()
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
            }
            
//            // プレイヤーのアイコンをループで表示
//            HStack(spacing: 30) {
//                ForEach(game.players.indices, id: \.self) { index in
//                    BotIconView(player: game.players[(myside() + index) % game.players.count])
//                }
//            }
//            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.3)
            
            // Card Pool
            HStack() {
                ZStack {
                    ForEach(Array(cardUI.enumerated()), id: \.1.id) { index, card in
                        N_CardView(card: card, location: card.location, selectedCards: $game.players[myside].selectedCards)
                            .animation(.easeInOut(duration: 0.3))
                    }
                }
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)

            // Btn
            Group {
                HStack(spacing: 15) {
                    
                    // TODO: ボタンだしわけ
//                    Button(action: {
//                    }) {
//                        Btnaction(btnText: "パス", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightBlue)
//                    }
                    
                    Button(action: {
                        fbms.drawCard(playerID: game.players[myside].id) { result in
                                print("Draw")
                            }
                    }) {
                        Btnaction(btnText: "引く", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightYellow)
                    }
                    
                    // testようにボタンとして動かしておく
                    Button(action: {
                        // count変数にする（人数変動対応）
                        GameFriendEventController().pass(passPayerIndex: game.currentPlayerIndex, playersCount: 4)
                        // stnk
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
                // 広告用
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.casinoGreen)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                
                // Rate
                RateView(gamenum: 1, rate: 10, magnification: 10)
                    .background(Color.casinoGreen)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.09)
                
                // DTNK View
                if game.gamePhase == .dtnk {
                    DTNKView(text: "DOTENKO")
                }
                // CountDown
                if game.gamePhase == .countdown {
                    Countdown02View()
                        .scaleEffect(2.0)
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
                }
                // チャレンジ可否ポップ
                if game.gamePhase == .q_challenge {
                    ChallengePopView(index: 0)
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
                        .transition(.move(edge: .top))
                        .animation(.default, value: game.gamePhase == .q_challenge)
                }
                // チャレンジロゴ
                // TODO: 配置諸々考える
                if game.gamePhase == .challenge {
                    MovingImage()
                }
                
                if game.gamePhase == .result {
                    ResultView()
                }
                if game.gamePhase == .decisionrate {
                    DecisionScoreView()
                    
                }

                // 開始ボタン
                if startFlag {
                    Button(action: {
                        startFlag = false
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
//                //Exit btn
//                Header()
//                    .frame(width: UIScreen.main.bounds.width , height: 40)
//                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.13)
            }
            
            
        } .onAppear {
            // サイド設定
            game.myside = self.myside
            // ゲーム情報取得
            fbm.getGameInfo(from: room.roomData.roomID) { info in
                game.gameID = info!.gameID
                game.deck = info!.deck
                FirebaseManager.shared.setIDs(roomID: room.roomData.roomID, gameID: info!.gameID)
                // 情報取得
                getGameInfo()
                // オブザーバーが配布
                if game.myside == 0 {
                    //　カード配布
                    gameObserber.dealFirst(roomID: room.roomData.roomID, players: game.players, gameID: game.gameID) { result in
                        startFlag = true
                    }
                }
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
                        if let index = cardUI.firstIndex(where: { $0.id.rawValue == deckCard.id }) {
                            var newCard = cardUI.remove(at: index)
                            // 新しい位置を設定
                            newCard.location = .deck
                            cardUI.append(newCard)
                        }
                    }
                }
                game.deck = cards!
            } else {
                // 再生成します
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
                        if let index = cardUI.firstIndex(where: { $0.id.rawValue == tableCard.id }) {
                            var newCard = cardUI.remove(at: index)
                            // 新しい位置を設定
                            newCard.location = .table
                            cardUI.append(newCard)
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
        // hand
        for s in 0..<game.players.count {
            fbms.observeHandInfo (
                playerIndex: String(s)) { cards in
                    var i = 0
                    if let cardsUnwrapped = cards {
                        for newhandcard in cardsUnwrapped {
                            // まず新しい手札を配列から見つけ出し
                            if let index = cardUI.firstIndex(where: { $0.id.rawValue == newhandcard.id }) {
                                var newCard = cardUI.remove(at: index)
                                // 新しい位置を設定
                                newCard.location = .hand(playerIndex: s, cardIndex: i)
                                i += 1;
                                // 新しい手札を一番最後に追加
                                cardUI.append(newCard)
                            }
                        }
                        game.players[s].hand = cards!
                    } else{
                        game.players[s].hand = []
                    }
                }
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
                // challengeAnswersが全部入ったら処理する
                gameObserber.challengeAnswers()
                
            }
        }
        // winners losers
        fbms.observeWinnersLosers() { winners, losers in
            game.winners = winners
            game.losers = losers
            print(losers)
        }
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
                if let index = selectedCards.firstIndex(of: card) {
                    selectedCards.remove(at: index)
                } else {
                    selectedCards.append(card)
                }
            }
    }
}
