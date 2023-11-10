


import SwiftUI

struct ChallengeOverIconView: View {
    var body: some View {
        Image(ImageName.Game.cross.rawValue)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50)
            .padding(20)
            .background(Circle()
                            .fill(Color.blue))
    }
}

