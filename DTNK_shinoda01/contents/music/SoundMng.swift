


import SwiftUI
import AVFoundation

class SoundMng {
    static let shared = SoundMng()
    private var audioPlayer: AVAudioPlayer?

    func dtnkSound() {
        
        guard appState.account.loginUser.sound else { return }

        guard let url = Bundle.main.url(forResource: SoundName.SE.dtnk.rawValue, withExtension: "wav") else {
            log("Sound file not found.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            
            // 5秒後に音声を停止する
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                self?.audioPlayer?.stop()
            }

        } catch {
            print("Error:", error.localizedDescription)
        }
    }
}
