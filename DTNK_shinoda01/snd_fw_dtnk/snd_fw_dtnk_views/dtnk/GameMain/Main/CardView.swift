
import SwiftUI

//スケール変化あり：触れるカードView
struct CardView: View {
    
    let card: Card
    let namespace: Namespace.ID
    @Binding var selectedCards: [Card]
    
    var body: some View {
        
        Image(card.cardid.imageName())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 70)
            .matchedGeometryEffect(id: card.id, in: namespace)
            .scaleEffect(selectedCards.contains(card) ? 1.2 : 1)
            .opacity(1.0)
            .onTapGesture {
                if selectedCards.contains(card) {
                    selectedCards.removeAll(where: { $0 == card })
                } else {
                    selectedCards.append(card)
                }
            }
//            .animation(.easeInOut(duration: 0.5))

    }
}

// 裏表ありカードView
struct noScaleCardView: View {
    
    let card: Card
    let namespace: Namespace.ID
    let degree: Double
    let width: Double
    
    var body: some View {

        Flip(degree: degree,
             front:
                Image(card.cardid.imageName())
                .resizable()
                .matchedGeometryEffect(id: card.id, in: namespace)
                .aspectRatio(contentMode: .fit),
             back:
                Image(ImageName.Card.back.rawValue)
                .resizable()
                .matchedGeometryEffect(id: card.id, in: namespace)
                .aspectRatio(contentMode: .fit)
        )
        .frame(width: width)
//        .animation(.easeInOut(duration: 0.5))

    }
}




//スケール変化なし：触れないカードView
struct filedCardView: View {
    
    let card: Card
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack{
            Image(card.cardid.imageName())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
                .matchedGeometryEffect(id: card.id, in: namespace)
//                .transition(.scale(scale: 1)) // フェードを無効にする
        }
    }
}
// スケール変化なし：触れないカードView
struct NSCardView: View {
    
    let card: Card
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack{
            Image(card.cardid.imageName())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
                .matchedGeometryEffect(id: card.id, in: namespace)
//                .transition(.scale(scale: 1)) // フェードを無効にする
        }
    }
}

// 裏表ありカードView
struct FlipCardView: View {
    let imageName: String
    let degree: Double
    var body: some View {

        Flip(degree: degree,
             front:
                Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit),
             back:
                Image(ImageName.Card.back.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
        )
    }
}

/**
 
 */
struct N_CardView: View {
    var card: N_Card
    let location: CardLocation
    @Binding var selectedCards: [N_Card]
    
    // カードが表か裏かを示す変数（例）
    var isFaceUp: Bool {
        if appState.gameUIState.gamePhase == .challenge || isMyHandCard || location == .table {
            return true
        }
        return Constants.cardFaceUp
    }
    
    var body: some View {
        ZStack {
            // 表のビュー
            if isFaceUp {
                Image(card.id.imageName())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            // 裏のビュー
            else {
                Image(ImageName.Card.back.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(width: isMyHandCard ? Constants.myCardWidth : Constants.otherCardWidth)
        .rotationEffect(Angle(degrees: card.id.angle(for: location, total: card.id.total(for: card.location))))
        .offset(card.id.location(for: location, total: card.id.total(for: card.location))) // 'total'を引数として渡す
        .offset(y: selectedCards.contains(card) ? -20 : 0)
        .onTapGesture {
            if appState.gameUIState.gamePhase != .decisioninitialplayer {
                withAnimation(.easeInOut(duration: 0.0)) {
                    // 自分の手札のみTap可能
                    if case let .hand(playerIndex, _) = card.location, case playerIndex = appState.gameUIState.myside {
                        if let idx = selectedCards.firstIndex(of: card) {
                            selectedCards.remove(at: idx)
                        } else {
                            selectedCards.append(card)
                        }
                    }
                }
            }
        }
    }
    // 自分の手札か
    var isMyHandCard: Bool {
        if case let .hand(playerIndex, _) = card.location, case playerIndex = appState.gameUIState.myside {
            return true
        }
        return false
    }
}
