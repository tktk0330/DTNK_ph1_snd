


import SwiftUI

struct TopController {
    
    func onTapPlay() {
        SoundMng.shared.playSound(soundName: SoundName.SE.btn_positive.rawValue)
        Router().pushBasePage(pageId: .home)
    }
}

