


import SwiftUI
import AVFoundation

class BgmMng {
    static let shared = BgmMng()
    private var audioPlayer: AVAudioPlayer?
    
    
    private init() {
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            log("Audio session setup failed: \(error)", level: .error)
        }
    }

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
