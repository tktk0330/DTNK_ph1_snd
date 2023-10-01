


import SwiftUI

struct Header: View {
    var game: GameUIState
    var geo: GeometryProxy
    
    var body: some View {
        
        BunnerView(geo: geo)

        GameRateView(game: game, geo: geo)
        // option
        Button(action: {
            game.gameMode = .option
            SoundMng.shared.playSound(soundName: SoundName.SE.btn_positive.rawValue)
        }) {
            Image(ImageName.Common.setting.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
        }
        .position(x: Constants.scrWidth * 0.1, y: geo.size.height * 0.16)
    }
}
