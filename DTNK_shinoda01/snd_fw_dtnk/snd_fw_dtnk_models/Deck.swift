


import SwiftUI
import Foundation

struct Deck: Equatable {
    var cards: [Card]
    
    init() {
        var cards: [Card] = []
        cards.append(Card(suit: .spade, number: 1, cardid: .spade1))
        cards.append(Card(suit: .spade, number: 2, cardid: .spade2))
        cards.append(Card(suit: .spade, number: 3, cardid: .spade3))
        cards.append(Card(suit: .spade, number: 4, cardid: .spade4))
        cards.append(Card(suit: .spade, number: 5, cardid: .spade5))
        cards.append(Card(suit: .spade, number: 6, cardid: .spade6))
        cards.append(Card(suit: .spade, number: 7, cardid: .spade7))
        cards.append(Card(suit: .spade, number: 8, cardid: .spade8))
        cards.append(Card(suit: .spade, number: 9, cardid: .spade9))
        cards.append(Card(suit: .spade, number: 10, cardid: .spade10))
        cards.append(Card(suit: .spade, number: 11, cardid: .spade11))
        cards.append(Card(suit: .spade, number: 12, cardid: .spade12))
        cards.append(Card(suit: .spade, number: 13, cardid: .spade13))
        cards.append(Card(suit: .heart, number: 1, cardid: .heart1))
        cards.append(Card(suit: .heart, number: 2, cardid: .heart2))
        cards.append(Card(suit: .heart, number: 3, cardid: .heart3))
        cards.append(Card(suit: .heart, number: 4, cardid: .heart4))
        cards.append(Card(suit: .heart, number: 5, cardid: .heart5))
        cards.append(Card(suit: .heart, number: 6, cardid: .heart6))
        cards.append(Card(suit: .heart, number: 7, cardid: .heart7))
        cards.append(Card(suit: .heart, number: 8, cardid: .heart8))
        cards.append(Card(suit: .heart, number: 9, cardid: .heart9))
        cards.append(Card(suit: .heart, number: 10, cardid: .heart10))
        cards.append(Card(suit: .heart, number: 11, cardid: .heart11))
        cards.append(Card(suit: .heart, number: 12, cardid: .heart12))
        cards.append(Card(suit: .heart, number: 13, cardid: .heart13))
        cards.append(Card(suit: .diamond, number: 1, cardid: .diamond1))
        cards.append(Card(suit: .diamond, number: 2, cardid: .diamond2))
        cards.append(Card(suit: .diamond, number: 3, cardid: .diamond3))
        cards.append(Card(suit: .diamond, number: 4, cardid: .diamond4))
        cards.append(Card(suit: .diamond, number: 5, cardid: .diamond5))
        cards.append(Card(suit: .diamond, number: 6, cardid: .diamond6))
        cards.append(Card(suit: .diamond, number: 7, cardid: .diamond7))
        cards.append(Card(suit: .diamond, number: 8, cardid: .diamond8))
        cards.append(Card(suit: .diamond, number: 9, cardid: .diamond9))
        cards.append(Card(suit: .diamond, number: 10, cardid: .diamond10))
        cards.append(Card(suit: .diamond, number: 11, cardid: .diamond11))
        cards.append(Card(suit: .diamond, number: 12, cardid: .diamond12))
        cards.append(Card(suit: .diamond, number: 13, cardid: .diamond13))
        cards.append(Card(suit: .club, number: 1, cardid: .club1))
        cards.append(Card(suit: .club, number: 2, cardid: .club2))
        cards.append(Card(suit: .club, number: 3, cardid: .club3))
        cards.append(Card(suit: .club, number: 4, cardid: .club4))
        cards.append(Card(suit: .club, number: 5, cardid: .club5))
        cards.append(Card(suit: .club, number: 6, cardid: .club6))
        cards.append(Card(suit: .club, number: 7, cardid: .club7))
        cards.append(Card(suit: .club, number: 8, cardid: .club8))
        cards.append(Card(suit: .club, number: 9, cardid: .club9))
        cards.append(Card(suit: .club, number: 10, cardid: .club10))
        cards.append(Card(suit: .club, number: 11, cardid: .club11))
        cards.append(Card(suit: .club, number: 12, cardid: .club12))
        cards.append(Card(suit: .club, number: 13, cardid: .club13))

        self.cards = cards
    }
    
    // カードをシャッフルする
    mutating func shuffle() {
        cards.shuffle()
    }
    
    func reset() -> Deck {
        var deck = Deck()
        deck.shuffle()
        return deck
    }
    
    // jorker選択分だけ入れる
//    mutating func appendjorker(Index: Int) {
//        for _ in 0..<Index/2 {
//            cards.append(Card(suit: .all, number: 0, cardid: .blackJocker))
//            cards.append(Card(suit: .all, number: 0, cardid: .whiteJocker))
//        }
//        shuffle()
//    }
    
    //　カードを引く
    mutating func draw() -> Card? {
        return cards.popLast()
    }
    
    mutating func dealOneCard() -> Card? {
        guard !cards.isEmpty else {
            return nil
        }
        return cards.removeLast()
    }
    
    
}
