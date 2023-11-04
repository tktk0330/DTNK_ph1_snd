/**
 バイブレーション
 */

import SwiftUI
import AudioToolbox

struct VibrateMng {

    enum VibrationType {
        case defaultVibration
        case rateup
        // 他のバイブレーションタイプもここに追加できます。
    }

    static func vibrate(type: VibrationType) {
        guard appState.account.loginUser.vibration else { return }

        switch type {
        case .defaultVibration:
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
        case .rateup:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        // 他のバイブレーションタイプの場合の処理もここに追加できます。
        }
    }
}
