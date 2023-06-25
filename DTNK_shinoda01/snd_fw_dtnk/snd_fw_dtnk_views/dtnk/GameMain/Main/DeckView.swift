
import SwiftUI

struct DeckView: View {
    
    @Binding var deck: [Card]
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack() {
            ForEach(deck) { card in
                noScaleCardView(card: card, namespace: namespace, degree: 180, width: 60)
            }
        }
    }
}

