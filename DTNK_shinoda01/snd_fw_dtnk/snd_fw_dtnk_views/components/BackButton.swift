


import SwiftUI

struct BackButton: View {
    
    var backPage: PageId
    var geo: GeometryProxy
    var keyboardHeight: CGFloat = 0
    
    var body: some View {
        ZStack{
            // back
            Button(action: {
                SoundMng.shared.playSound(soundName: SoundName.SE.btn_negative.rawValue)
                Router().pushBasePage(pageId: backPage)
                
            }) {
                Image(ImageName.Common.back.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
            }
            .frame(maxHeight: 40)
            .position(x: Constants.scrWidth * 0.10, y:  geo.size.height * 0.10 + keyboardHeight)
        }
    }
}
