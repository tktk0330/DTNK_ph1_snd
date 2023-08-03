


import SwiftUI

struct GameFriendView: View {
    @StateObject var game: GameUIState = appState.gameUIState
    @StateObject var room: RoomState = appState.room
    let fbm = FirebaseManager()
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
                        GameObserber().fbm.moveTopCardToTable(roomID: room.roomData.roomID, gameID: game.gameID) { result in
                        }
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
                        fbm.drawCard(
                            roomID: room.roomData.roomID,
                            playerID: game.players[myside].id,
                            gameID: game.gameID) { bool in
                                print("Draw")
                            }
                    }) {
                        Btnaction(btnText: "引く", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightYellow)
                    }
                    
                    // testようにボタンとして動かしておく
                    Button(action: {
                        // count変数にする（人数変動対応）
                        GameFriendEventController().pass(passPayerIndex: game.currentPlayerIndex, playersCount: 4)
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
                        fbm.playCards(
                            roomID: room.roomData.roomID,
                            playerID: game.players[myside].id,
                            gameID: game.gameID,
                            baseselectedCards: game.players[myside].selectedCards
                        ) { bool in
                                print("Play")
                            game.players[myside].selectedCards = []
                            }
                    }) {
                        Btnaction(btnText: "出す", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightRed)
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.9)
            }
            
            // 開始ボタン
            if startFlag {
                Button(action: {
                    startFlag = false
                    fbm.updateGamePhase(roomID: room.roomData.roomID, gameID: game.gameID, gamePhase: .countdown) { result in
                    }
                }) {
                    Text("Start")
                }
                .buttonStyle(ShadowButtonStyle())
                .frame(width: 200, height: 100)
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
            }
            
            // CountDown
            if game.gamePhase == .countdown {
                Countdown02View()
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
            }
            
            Group {
                // 広告用
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.casinoGreen)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                
                //Rate
                RateView(gamenum: 1, rate: 10, magnification: 10)
                    .background(Color.casinoGreen)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.09)
            }
            
//            //Exit btn
//            Header()
//                .frame(width: UIScreen.main.bounds.width , height: 40)
//                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.13)
            
            
        } .onAppear {
            // サイド設定
            game.myside = self.myside
                        
            // ゲーム情報取得
            fbm.getGameInfo(from: room.roomData.roomID) { info in
                game.gameID = info!.gameID
                game.deck = info!.deck
                
                fbm.observeGamePhase(roomID: room.roomData.roomID, gameID: game.gameID) { gamePhase in
                    if (gamePhase != nil) {
                        game.gamePhase = gamePhase!
                    }
                }
                fbm.getCurrentPlayerIndex(roomID: room.roomData.roomID, gameID: game.gameID) { currentPlayerIndex in
                    if (currentPlayerIndex != nil) {
                        game.currentPlayerIndex = currentPlayerIndex!
                    }
                }
                
                fbm.observeDeckInfo (
                    from: room.roomData.roomID,
                    gameID: game.gameID) { cards in
                        if (cards != nil) {
                            game.deck = cards!                            
                            } else{
                            print("デッキ取得エラー")
                        }
                    }
                fbm.observeTableInfo (
                    from: room.roomData.roomID,
                    gameID: game.gameID) { cards in
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
                for s in 0..<game.players.count {
                    fbm.observeHandInfo (
                        from: room.roomData.roomID,
                        gameID: game.gameID,
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
                
                // オブザーバーの方が配布
                if game.myside == 0 {
                    //　カード配布
                    GameObserber().dealFirst(roomID: room.roomData.roomID, players: game.players, gameID: game.gameID) { result in
                        startFlag = true
                    }
                }
            }
        }
    }
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

struct N_Card: Equatable {
    let id: CardId
    var location: CardLocation
}


// Deck & Table
struct FieldCardView: View {
    let card: CardId
    let degree: Double
    let width: Double
    
    var body: some View {
        Flip(degree: degree,
             front:
                Image(card.imageName())
                .resizable()
                .aspectRatio(contentMode: .fit),
             back:
                Image(ImageName.Card.back.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
        )
        .frame(width: width)
    }
}

// Hand
struct ALLCardView: View {
    let card: CardId
    let degree: Double
    let width: Double
    let location: CardLocation
    let total: Int // 新しいプロパティを追加
    
    var body: some View {
        Flip(degree: degree,
             front:
                Image(card.imageName())
            .resizable()
            .aspectRatio(contentMode: .fit),
             back:
                Image(ImageName.Card.back.rawValue)
            .resizable()
            .aspectRatio(contentMode: .fit)
        )
        .frame(width: width)
        .offset(card.location(for: location, total: total)) // 'total'を引数として渡す
        .animation(.easeInOut(duration: 0.5), value: location)

    }
}
