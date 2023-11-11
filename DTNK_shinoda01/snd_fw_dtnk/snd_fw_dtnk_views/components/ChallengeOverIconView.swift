/**
 NoChallenge Over の人にはアイコン付与
 */

import SwiftUI

struct ChallengeOverIconView: View {
    var body: some View {
        Image(ImageName.Game.cross.rawValue)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30)
            .padding(10)
            .background(Circle()
                            .fill(Color.blue))
    }
}

