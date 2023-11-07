/**
 エラーメッセージView
 */

import SwiftUI

struct ErrorMessageView: View {
    @Binding var showErrorMessage: Bool
    @Binding var errorMessageText: String
    
    @State private var errorMessageOpacity = 0.0

    var body: some View {
        if showErrorMessage {
            Text(errorMessageText)
                .font(.custom(FontName.MP_Bl, size: 20))
                .foregroundColor(Color.red)
                .opacity(errorMessageOpacity)
                .onAppear {
                    withAnimation {
                        errorMessageOpacity = 1.0
                    }
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                        withAnimation {
                            errorMessageOpacity = 0.0
                        }
                        showErrorMessage = false
                    }
                }
        }
    }
}
