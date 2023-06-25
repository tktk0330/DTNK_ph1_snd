
import SwiftUI

struct FieldView: View {
    // 山札
    @Binding var deck: [Card]
    // 場にでたカード
    @Binding var table: [Card]
    let namespace: Namespace.ID
    
    var body: some View {
        GeometryReader { geo in
            
            HStack{
                DeckView(deck: $deck, namespace: namespace)
//                    .animation(.default)

                TableView(table: $table, namespace: namespace)
//                    .animation(.default)
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.52)
        }
    }
}
