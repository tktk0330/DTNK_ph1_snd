


import SwiftUI

struct Header: View {
    var game: GameUIState
    var geo: GeometryProxy
    
    var body: some View {
        
        AdTestView(geo: geo)
        GameRateView(game: game, geo: geo)
        // option
        Button(action: {
        }) {
            Image(ImageName.Common.setting.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
        }
        .position(x: Constants.scrWidth * 0.1, y: geo.size.height * 0.16)
    }
}
