/**
 バイブレーション
 */

import SwiftUI
import AudioToolbox

struct Vibration {
    
    let generator = UINotificationFeedbackGenerator()
    @State var isVibrationOn = false

    func vib01() {
        for _ in 0...30 {
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
            sleep(UInt32(0.01))
        }
    }
}
