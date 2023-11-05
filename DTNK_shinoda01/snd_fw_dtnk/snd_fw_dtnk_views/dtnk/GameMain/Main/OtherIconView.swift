// PlayerIconsView.swift


import SwiftUI

struct OtherPlayerIconsView: View {
    @ObservedObject var game: GameUIState // あなたのゲームの型に変更してください
    var myside: Int
    var geo: GeometryProxy
    var imageSize: CGFloat = 50
    
    var body: some View {
        
        // left
        ZStack(alignment: .bottom) {
            OtherPlayerIcon(game: game, playerIndex: (myside + 1) % game.players.count, imageName: game.players[(myside + 1) % game.players.count].icon_url)
            Text(game.players[(myside + 1) % game.players.count].name)
                .modifier(IconTextModifier())
        }
        .position(x: Constants.scrWidth * 0.30, y:  geo.size.height * 0.30)

        // center
        ZStack(alignment: .bottom) {
            OtherPlayerIcon(game: game, playerIndex: (myside + 2) % game.players.count, imageName: game.players[(myside + 2) % game.players.count].icon_url)
            Text(game.players[(myside + 2) % game.players.count].name)
                .modifier(IconTextModifier())
        }
        .position(x: Constants.scrWidth * 0.50, y:  geo.size.height * 0.26)
        
        // right
        ZStack(alignment: .bottom) {
            OtherPlayerIcon(game: game, playerIndex: (myside + 3) % game.players.count, imageName: game.players[(myside + 3) % game.players.count].icon_url)
            Text(game.players[(myside + 3) % game.players.count].name)
                .modifier(IconTextModifier())
        }
        .position(x: Constants.scrWidth * 0.70, y:  geo.size.height * 0.30)

    }
}

struct OtherPlayerIcon: View {
    @ObservedObject var game: GameUIState // あなたのゲームの型に変更してください
    let playerIndex: Int
    var imageName: String

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
                .cornerRadius(10)
                .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
            
            if game.dtnkPlayerIndex == playerIndex {
                Text("DOTENKO")
                    .font(.custom(FontName.font01, size: 12))
                    .foregroundColor(Color.dtnkLightRed)
                    .frame(width: 80, height: 20)
                    .background(Color.black.opacity(0.70))
                    .offset(y: -30)
            } else if game.lastPlayerIndex == playerIndex && game.dtnkPlayer != nil {
                Text("LOSER!?")
                    .font(.custom(FontName.font01, size: 12))
                    .foregroundColor(Color.dtnkBlue)
                    .frame(width: 80, height: 20)
                    .background(Color.black.opacity(0.70))
                    .offset(y: -30)
            }
        }
    }
}

struct IconTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontName.MP_EB, size: 18))
            .foregroundColor(Color.white)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .frame(width: 80, height: 20)
            .background(Color.black.opacity(0.50))
            .offset(y: 10)
    }
}
