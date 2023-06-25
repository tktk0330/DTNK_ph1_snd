/**
 カウントダウンView
 */

import SwiftUI


class CountDownState: ObservableObject {
    @Published var countdownSeconds = 5
    @Published var remainingSeconds = 0
}

struct Countdown02View: View {
    @StateObject private var game = CountDownState()
    @State private var isCountdownFinished = false
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            if isCountdownFinished {
                // カウントダウンが終了した後のビュー
//                Text("Countdown Finished")
            } else {
                VStack {
                    Text("\(game.remainingSeconds)")
                        .foregroundColor(game.remainingSeconds <= 3 ? .red : .black)
                        .font(.custom("DS-Digital", size: 150))
                }
                .onAppear {
                    startCountdown()
                }
            }
        }
    }
    
    private func startCountdown() {
        game.remainingSeconds = game.countdownSeconds
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            game.remainingSeconds -= 1
            
            if game.remainingSeconds <= 0 {
                timer?.invalidate()
                isCountdownFinished = true
            }
        }
    }
}
