/*
 手札 配置書き直す
 */

import SwiftUI

// A view to represent the cards in a hand
struct HandView: View {
    
    let namespace: Namespace.ID
    @Binding var hand: [Card]
    @Binding var selectedCards: [Card]
    
    var body: some View {
        GeometryReader { geometry in
            
            ForEach(hand) { card in
                CardView(card: card, namespace: namespace, selectedCards: $selectedCards)
                    .onTapGesture {
                        if selectedCards.contains(card) {
                            selectedCards.removeAll(where: { $0 == card })
                        } else {
                            selectedCards.append(card)
                        }
                    }
                    .animation(.easeInOut .speed(2.0), value: card)
            }
        }
    }
}

