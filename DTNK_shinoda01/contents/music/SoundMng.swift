


import SwiftUI
import AVFoundation

class SoundMng: NSObject{
    static let shared = SoundMng()
    private var audioPlayers: [AVAudioPlayer] = []


    private override init() {
        super.init()
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session setup failed: \(error)")
        }
    }
    
    func dtnkSound() {
        // check
        guard appState.account.loginUser.se else { return }

        guard let url = Bundle.main.url(forResource: SoundName.SE.dtnk.rawValue, withExtension: "wav") else {
            log("Sound file not found.")
            return
        }

        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayers.append(audioPlayer)
            audioPlayer.delegate = self
            audioPlayer.play()

            // 5秒後にこの特定の音声を停止する
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                audioPlayer.stop()
                if let index = self.audioPlayers.firstIndex(of: audioPlayer) {
                    self.audioPlayers.remove(at: index)
                }
            }
        } catch {
            print("Error:", error.localizedDescription)
        }
    }

    func playSound(soundName: String) {
        guard appState.account.loginUser.se else { return }
        
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else {
            log("音声ファイルが見つかりません")
            return
        }

        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayers.append(audioPlayer)
            
            // オーディオが終了したら、配列から削除
            audioPlayer.delegate = self
            audioPlayer.play()
            
        } catch {
            log("音声の再生に失敗しました: \(error)", level: .error)
        }
    }
}

extension SoundMng: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let index = audioPlayers.firstIndex(of: player) {
            audioPlayers.remove(at: index)
        }
    }
}
