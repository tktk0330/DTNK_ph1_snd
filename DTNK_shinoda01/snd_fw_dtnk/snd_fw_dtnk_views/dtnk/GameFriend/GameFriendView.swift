


import SwiftUI

struct GameFriendView: View {
    @StateObject var game: GameUiState = appState.gameUiState

    // TODO: 自分のアイコンから表示するように
    func myside() -> Int {
        let id = appState.account.loginUser.userID
        let players =  appState.gameUiState.players
        let myIndex = players.firstIndex(where: { $0.id == id })
        
        return myIndex!
    }
    
    var body: some View {
        GeometryReader { geo in
            
            // CountDown View
            if game.gamePhase == .countdown {
                Countdown02View()
                    .scaleEffect(3.0)
            }

            // 広告用
            Rectangle()
                .foregroundColor(Color.white.opacity(0.3))
                .shadow(color: .gray, radius: 10, x: 0, y: 5)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
            
            HStack(spacing: 30) {
                BotIconView(player: game.players[0])
                
                BotIconView(player: game.players[1])
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)

        }.onAppear{
//            game.gamePhase = .countdown
        }
    }
}
