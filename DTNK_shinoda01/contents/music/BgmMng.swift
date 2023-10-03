


import SwiftUI
import AVFoundation

class BgmMng {
    static let shared = BgmMng()
    private var audioPlayer: AVAudioPlayer?

    func playSound(bgmName: String) {
        
        guard appState.account.loginUser.sound else { return }

        guard let url = Bundle.main.url(forResource: bgmName, withExtension: "wav") else {
            log("Bgmが見つかりません")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1  // infinity
            audioPlayer?.play()
        } catch {
            log("Bgm失敗しました: \(error)", level: .error)
        }
    }

    func stopSound() {
        audioPlayer?.stop()
    }
}
