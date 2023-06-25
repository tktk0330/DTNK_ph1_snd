/*
 exit btn controllerの処理必要　現在簡易的
 */

import SwiftUI

struct Header: View {

//    @ObservedObject var game = GameUiState()
    @StateObject var game: GameUiState = appState.gameUiState


    
    var body: some View {
        HStack {
            Button {
//                Router().pushBasePage(pageId: .home)
            } label: {
                Text("Exit")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: 100, maxHeight: .infinity)
                    .background(.red)
                    .cornerRadius(10)
            }
            .padding()
            Spacer()
        }
    }
}

extension Header {
    class State: ObservableObject {
        @Published var isShowingAlert: Bool = false
        var onTapExit: (() -> Void)?
    }
}
