// PlayerIconsView.swift


import SwiftUI

struct OtherPlayerIconsView: View {
    var game: GameUIState
    var myside: Int
    var geo: GeometryProxy
    
    var body: some View {
        Image(game.players[(myside + 1) % game.players.count].icon_url)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40)
            .cornerRadius(10)
            .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
            .position(x: UIScreen.main.bounds.width * 0.30, y:  geo.size.height * 0.30)
        
        Image(game.players[(myside + 2) % game.players.count].icon_url)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40)
            .cornerRadius(10)
            .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
            .position(x: UIScreen.main.bounds.width * 0.50, y:  geo.size.height * 0.25)
        
        Image(game.players[(myside + 3) % game.players.count].icon_url)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40)
            .cornerRadius(10)
            .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
            .position(x: UIScreen.main.bounds.width * 0.70, y:  geo.size.height * 0.30)
    }
}
