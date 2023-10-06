/**
 ネットワーク接続確認
 */


import SwiftUI
import Network

class NetworkManager: ObservableObject {
    private var monitor: NWPathMonitor?
    private var disconnectTimer: Timer?

    @Published var isConnected: Bool = false
    @Published var showDisconnectPrompt: Bool = false  // この名前を変更

    init() {
        monitor = NWPathMonitor()
        
        monitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self?.isConnected = true
                    self?.stopDisconnectTimer()
                } else {
                    self?.isConnected = false
                    self?.startDisconnectTimer()
                }
            }
        }

        let queue = DispatchQueue.global(qos: .background)
        monitor?.start(queue: queue)
    }

    deinit {
        monitor?.cancel()
        stopDisconnectTimer()
    }

    private func startDisconnectTimer() {
        disconnectTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { [weak self] _ in
            // タイマーが発火する前にネットワークが復帰したか確認
            if !(self?.isConnected ?? false) {
                self?.showDisconnectPrompt = true
            }
        })
    }

    private func stopDisconnectTimer() {
        disconnectTimer?.invalidate()
        disconnectTimer = nil
    }
}
