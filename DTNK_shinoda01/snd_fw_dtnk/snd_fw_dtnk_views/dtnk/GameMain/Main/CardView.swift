
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

