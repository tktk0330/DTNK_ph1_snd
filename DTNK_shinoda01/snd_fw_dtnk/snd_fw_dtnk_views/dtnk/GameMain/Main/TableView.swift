
import SwiftUI

struct TableView: View {
    
    @Binding var table: [Card]
    let namespace: Namespace.ID

    var body: some View {
        ZStack {
//            if table.isEmpty {
//                Rectangle()
//                    .foregroundColor(Color.clear)
//                    .frame(width: 60, height: 1)
//            }
//            else{
//                ForEach(table) { card in
//                    noScaleCardView(card: card, namespace: namespace, degree: 0, width: 60)
//                        .animation(.easeInOut(duration: 0.5))
//
//                }
//            }
        }
    }
}

