import SwiftUI

struct GameFriendView: View {
    @StateObject var game: GameUIState = appState.gameUIState
    @StateObject var room: RoomState = appState.room
    let fbm = FirebaseManager()
    let cardSpacingDegrees: Double = 5 // カード間の間隔（度数法）
    
    var body: some View {
        GeometryReader { geo in
            
            // プレイヤーのアイコンをループで表示
            HStack(spacing: 30) {
//                ForEach(game.players.indices, id: \.self) { index in
//                    BotIconView(player: game.players[(myside() + index) % game.players.count])
//                }
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.3)
            
            // Field
            // TODO: 別でまとめる
            HStack() {
                // Deck
                ZStack() {
                    ForEach(game.deck, id: \.self) { card in
                        ALLCardView(card: card, degree: 0, width: 60, location: .deck, total: 0)
                            .animation(.easeInOut(duration: 0.5), value: game.deck)
                    }
                }
                
                // Table
                ZStack {
                    if game.table.isEmpty {
                        Rectangle()
                            .foregroundColor(Color.clear)
                            .frame(width: 60, height: 1)
                    }
                    else{
                        ForEach(game.table) { card in
                            FieldCardView(card: card, degree: 0, width: 60)
                        }
                    }
                }
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)

            // MyHand
            ZStack {
                if game.players[myside()].hand.isEmpty {
                    // 手札無
                }
                else{
                    // TODO: 対戦相手は-50にする
                    HStack(spacing: -30) {
                        ForEach(Array(game.players[0].hand.enumerated()), id: \.offset) { index, card in
                            ALLCardView(card: card, degree: 0, width: 60, location: .hand(playerIndex: index), total: game.players[0].hand.count)
                                .rotationEffect(Angle.degrees(cardSpacingDegrees * (Double(index) - Double(game.players[0].hand.count - 1) / 2))) // Rotate the cards properly
                                .animation(.easeInOut(duration: 0.5), value: game.players[0].hand) // And this
                        }
                    }
                }
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.7)

            
            // 正面
            ZStack {
                if game.players[myside()].hand.isEmpty {
                    // 手札無
                }
                else{
                    // TODO: 対戦相手は-50にする
                    HStack(spacing: -50) {
                        ForEach(Array(game.players[0].hand.enumerated()), id: \.offset) { index, card in
                            ALLCardView(card: card, degree: 0, width: 60, location: .hand(playerIndex: index), total: game.players[0].hand.count)
                                .rotationEffect(Angle.degrees(cardSpacingDegrees * (Double(index) - Double(game.players[0].hand.count - 1) / 2))) // Rotate the cards properly
                                .animation(.easeInOut(duration: 0.5), value: game.players[0].hand) // And this
                        }
                    }
                    .rotationEffect(.degrees(180))
                }
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.10)
            
            // 左
            ZStack {
                if game.players[myside()].hand.isEmpty {
                    // 手札無
                }
                else{
                    // TODO: 対戦相手は-50にする
                    HStack(spacing: -50) {
                        ForEach(Array(game.players[0].hand.enumerated()), id: \.offset) { index, card in
                            ALLCardView(card: card, degree: 0, width: 60, location: .hand(playerIndex: index), total: game.players[0].hand.count)
                                .rotationEffect(Angle.degrees(cardSpacingDegrees * (Double(index) - Double(game.players[0].hand.count - 1) / 2))) // Rotate the cards properly
                                .animation(.easeInOut(duration: 0.5), value: game.players[0].hand) // And this
                        }
                    }
                    .rotationEffect(.degrees(90))
                }
            }
            .position(x: UIScreen.main.bounds.width * 0.01, y:  geo.size.height * 0.30)
            
            // 右
            ZStack {
                if game.players[myside()].hand.isEmpty {
                    // 手札無
                }
                else{
                    // TODO: 対戦相手は-50にする
                    HStack(spacing: -50) {
                        ForEach(Array(game.players[0].hand.enumerated()), id: \.offset) { index, card in
                            ALLCardView(card: card, degree: 0, width: 60, location: .hand(playerIndex: index), total: game.players[0].hand.count)
                                .rotationEffect(Angle.degrees(cardSpacingDegrees * (Double(index) - Double(game.players[0].hand.count - 1) / 2))) // Rotate the cards properly
                                .animation(.easeInOut(duration: 0.5), value: game.players[0].hand) // And this
                        }
                    }
                    .rotationEffect(.degrees(-90))
                }
            }
            .position(x: UIScreen.main.bounds.width * (1.00 - 0.01), y:  geo.size.height * 0.30)



            
            // Btn
            Group {
                HStack(spacing: 50) {
                    
                    Button(action: {
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
                        fbm.playCard(
                            roomID: room.roomData.roomID,
                            playerID: game.players[0].id,
                            gameID: game.gameID) { bool in
                                print("Play")
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
            Header()
                .frame(width: UIScreen.main.bounds.width , height: 40)
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.13)
            


        }.onAppear {
            // ゲーム情報取得
            fbm.getGameInfo(from: room.roomData.roomID) { info in
                game.gameID = info!.gameID
                game.deck = info!.deck
                
                fbm.observeDeckInfo(
                    from: room.roomData.roomID,
                    gameID: game.gameID) { cards in
                        if (cards != nil) {
                            game.deck = cards!
                        } else{
                            print("erroer1")
                        }
                    }
                fbm.observeTableInfo(
                    from: room.roomData.roomID,
                    gameID: game.gameID) { cards in
                        if (cards != nil) {
                            game.table = cards!
                        } else{
                            print("erroer2")
                        }
                    }
                fbm.observeHandInfo(
                    from: room.roomData.roomID,
                    gameID: game.gameID,
                    playerID: game.players[0].id) { cards in
                        if (cards != nil) {
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
    }
}
