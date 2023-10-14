/**
 カウントダウンView
 
 ・スタートカウントダウン
 ・ターンカウントダウン
 */

import SwiftUI


struct StartCountdownView: View {
    @StateObject private var game = StartCountDownState()
    @State private var isCountdownFinished = false
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            if isCountdownFinished {
                
            } else {
                VStack {
                    Text("\(game.remainingSeconds)")
                        .foregroundColor(game.remainingSeconds <= 3 ? .red : .black)
                        .font(.custom(FontName.font02, size: 150))
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
                appState.gameUIState.counter = true
            }
        }
    }
}

class StartCountDownState: ObservableObject {
    @Published var countdownSeconds = 5
    @Published var remainingSeconds = 0
}


struct CountdownView: View {
    @StateObject var viewModel = CountDownViewModel()

    var body: some View {
        Text("\(viewModel.remainingSeconds)")
            .foregroundColor(viewModel.remainingSeconds <= 3 ? .red : .white)
            .font(.custom(FontName.font02, size: 50))
            .onReceive(appState.gameUIState.$currentPlayerIndex) { _ in
                viewModel.nextTurn()
            }
    }
}

class CountDownViewModel: ObservableObject {
    @Published var remainingSeconds: Int = Constants.turnTime
    private var timer: Timer?

    func nextTurn() {
        timer?.invalidate()
        if ((appState.gameUIState.gamePhase == .gamefirst_sub || appState.gameUIState.gamePhase == .main) &&  appState.gameUIState.myside == appState.gameUIState.currentPlayerIndex) {
            startTimer()
        } else {
            remainingSeconds = Constants.turnTime
        }
    }

    private func startTimer() {
        remainingSeconds = Constants.turnTime
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
            } else {
                self.timer?.invalidate()
                // タイムオーバー処理
                GameMainController().timeLimitAction()
            }
        }
    }
}
