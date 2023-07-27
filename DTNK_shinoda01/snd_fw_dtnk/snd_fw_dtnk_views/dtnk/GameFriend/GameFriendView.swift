import SwiftUI

struct GameFriendView: View {
    @StateObject var game: GameUIState = appState.gameUIState
    @StateObject var room: RoomState = appState.room
    let fbm = FirebaseManager()
    let cardSpacingDegrees: Double = 5 // カード間の間隔（度数法）
    // CardPool
    @State var cardUI: [N_Card] = cards

    var body: some View {
        GeometryReader { geo in
            
            // プレイヤーのアイコンをループで表示
            HStack(spacing: 30) {
//                ForEach(game.players.indices, id: \.self) { index in
//                    BotIconView(player: game.players[(myside() + index) % game.players.count])
//                }
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.3)
            
            // Card Pool
            HStack() {
                ZStack {
                    ForEach(Array(cardUI.enumerated()), id: \.1.id) { index, card in
                        // totalもdeckに依存
                        N_CardView(card: card, location: card.location, total: game.players[0].hand.count, selectedCards: $game.players[0].selectedCards)
                            .animation(.easeInOut(duration: 0.3))
                    }
                }
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)

            // Btn
            Group {
                HStack(spacing: 50) {
                    
                    Button(action: {
                        print(game.players[0].hand.count)
                        fbm.drawCard(
                            roomID: room.roomData.roomID,
                            playerID: game.players[0].id,
                            gameID: game.gameID) { bool in
                                print("Draw")
                            }
                    }) {
                        Text("引く")
                            .font(.system(size: 25))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .bold()
                            .padding()
                            .frame(width: 100, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.yellow, lineWidth: 3)
                            )
                    }
                    
                    Button(action: {
                        fbm.playCards(
                            roomID: room.roomData.roomID,
                            playerID: game.players[0].id,
                            gameID: game.gameID,
                            baseselectedCards: game.players[0].selectedCards
                        ) { bool in
                                print("Play")
                            game.players[0].selectedCards = []

                            }
                        
                    }) {
                        Text("出す")
                            .font(.system(size: 25))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .bold()
                            .padding()
                            .frame(width: 100, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.yellow, lineWidth: 3)
                            )
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
                    .background(Color.plusDarkGreen)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                
                //Rate
                RateView(gamenum: 1, rate: 10, magnification: 10)
                    .background(Color.plusDarkGreen)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.09)
            }
            
            //Exit btn
//            Header()
//                .frame(width: UIScreen.main.bounds.width , height: 40)
//                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.13)
            


        }.onAppear {
            // ゲーム情報取得
            fbm.getGameInfo(from: room.roomData.roomID) { info in
                game.gameID = info!.gameID
                game.deck = info!.deck
                
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
                fbm.observeHandInfo (
                    from: room.roomData.roomID,
                    gameID: game.gameID,
                    playerID: game.players[0].id) { cards in
                        var i = 0
                        if let cardsUnwrapped = cards {
                            for newhandcard in cardsUnwrapped {
                                // まず新しい手札を配列から見つけ出し
                                if let index = cardUI.firstIndex(where: { $0.id.rawValue == newhandcard.id }) {
                                    var newCard = cardUI.remove(at: index)
                                    // 新しい位置を設定
                                    newCard.location = .hand(playerIndex: 0, cardIndex: i)
                                    i += 1;
                                    // 新しい手札を一番最後に追加
                                    cardUI.append(newCard)
                                }
                            }
                            game.players[0].hand = cards!
                        } else{
                            game.players[0].hand = []
                        }
                    }
            }
        }
    }
    // 自分のサイドを探索
    func myside() -> Int {
        let id = appState.account.loginUser.userID
        let players =  appState.gameUIState.players
        let myIndex = players.firstIndex(where: { $0.id == id })
        return myIndex!
    }
}

struct N_CardView: View {
    var card: N_Card
    let location: CardLocation
    let total: Int // 新しいプロパティを追加
    @Binding var selectedCards: [N_Card]
    
    var body: some View {
        // ここでCardの内容を表示する
        Image(card.id.imageName())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60)
            .rotationEffect(Angle(degrees: card.id.angle(for: location, total: total)))
            .offset(card.id.location(for: location, total: total)) // 'total'を引数として渡す
            .offset(y: selectedCards.contains(card) ? -20 : 0) // <- Here

            .onTapGesture {
                // タップ時にカードの選択状態を更新
                if let index = selectedCards.firstIndex(of: card) {
                    // カードが既に選択されている場合は選択を解除
                    selectedCards.remove(at: index)
                } else {
                    // それ以外の場合は選択
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
