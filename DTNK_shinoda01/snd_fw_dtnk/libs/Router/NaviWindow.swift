


import SwiftUI

struct NaviWindow: View {
    @StateObject var state: NaviState
    
    var body: some View {
        return Group {
            if let latestPageId = state.stack.last {
                
                PageContent(id: latestPageId)
                //遷移アニメーション　TODO：考える
//                    .transition(.asymmetric(
//                        insertion: .move(edge: .trailing),
//                        removal: .move(edge: .leading)
//                    ))
                
            } else {
//                RelaunchView()
            }
        }
    }
}
