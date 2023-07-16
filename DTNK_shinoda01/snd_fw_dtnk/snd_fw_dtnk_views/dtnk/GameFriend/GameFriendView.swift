import SwiftUI

struct GameFriendView: View {
    @StateObject var game: GameUIState = appState.gameUIState
    @StateObject var room: RoomState = appState.room


    func myside() -> Int {
        let id = appState.account.loginUser.userID
        let players =  appState.gameUIState.players
        let myIndex = players.firstIndex(where: { $0.id == id })
        
        return myIndex!
    }
    
    var body: some View {
        GeometryReader { geo in
            
            // 広告用
            Rectangle()
                .foregroundColor(Color.white.opacity(0.3))
                .shadow(color: .gray, radius: 10, x: 0, y: 5)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
            
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
                    ForEach(game.deck) { card in
                        FieldCardView(card: card, degree: 0, width: 60)
                    }
                }
                
                // Table
                ZStack {
//                    if game.table.isEmpty {
//                        Rectangle()
//                            .foregroundColor(Color.clear)
//                            .frame(width: 60, height: 1)
//                    }
//                    else{
//                        ForEach(game.table) { card in
//                            FieldCardView(card: card, degree: 0, width: 60)
//                        }
//                    }
                }
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)

            // Hand
            ZStack {
                if game.players[myside()].hand.isEmpty {
                    Rectangle()
                        .foregroundColor(Color.clear)
                        .frame(width: 60, height: 1)
                }
                else{
                    HStack(spacing: -30) {
                        ForEach(Array(game.players[0].hand.enumerated()), id: \.offset) { index, card in
                            HandCardView(card: card, degree: 0, width: 60)
                        }
                    }
                }
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.7)

            
            // Btn
            Button(action: {
                FirebaseManager().drawCard(
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
                    .frame(width: 170, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.yellow, lineWidth: 3)
                    )
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.8)
            
            Button(action: {
                FirebaseManager().drawCard(
                    roomID: room.roomData.roomID,
                    playerID: game.players[0].id,
                    gameID: game.gameID) { bool in
                    print("Draw")
                }
                
            }) {
                Text("出す")
                    .font(.system(size: 25))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .bold()
                    .padding()
                    .frame(width: 170, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.yellow, lineWidth: 3)
                    )
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.9)


        }.onAppear{
            
            // ゲーム情報取得
            FirebaseManager().getGameInfo(from: room.roomData.roomID) { info in
                game.gameID = info!.gameID
                game.deck = info!.deck
                
                FirebaseManager().observeDeckInfo(
                    from: room.roomData.roomID,
                    gameID: game.gameID) { cards in
                    if (cards != nil) {
                        game.deck = cards!
                    } else{
                        print("erroer1")
                    }
                }
                FirebaseManager().observeHandInfo(
                    from: room.roomData.roomID,
                    gameID: game.gameID,
                    playerID: game.players[0].id) { cards in
                        if (cards != nil) {
                            game.players[0].hand = cards!
                            print(cards!)
                        } else{
                            print("no cards")
                        }
                    }
            }
        }
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
struct HandCardView: View {

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
