// PlayerIconsView.swift


import SwiftUI

struct OtherPlayerIconsView: View {
    var game: GameUIState
    var myside: Int
    var geo: GeometryProxy
    var imageSize: CGFloat = 50
    
    var body: some View {
        
        // left
        ZStack(alignment: .bottom) {
            OtherPlayerIcon(imageName: game.players[(myside + 1) % game.players.count].icon_url)
            Text(game.players[(myside + 1) % game.players.count].name)
                .modifier(IconTextModifier())
        }
        .position(x: Constants.scrWidth * 0.30, y:  geo.size.height * 0.27)

        // center
        ZStack(alignment: .bottom) {
            OtherPlayerIcon(imageName: game.players[(myside + 2) % game.players.count].icon_url)
            Text(game.players[(myside + 2) % game.players.count].name)
                .modifier(IconTextModifier())
        }
        .position(x: Constants.scrWidth * 0.50, y:  geo.size.height * 0.22)
        
        // right
        ZStack(alignment: .bottom) {
            OtherPlayerIcon(imageName: game.players[(myside + 3) % game.players.count].icon_url)
            Text(game.players[(myside + 3) % game.players.count].name)
                .modifier(IconTextModifier())
        }
        .position(x: Constants.scrWidth * 0.70, y:  geo.size.height * 0.27)

    }
}

struct OtherPlayerIcon: View {
    var imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50)
            .cornerRadius(10)
            .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
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
