/**
 最終スコア決定画面
 */


import SwiftUI
/**
友達対戦
 */
// TODO: 統合
struct DecisionScoreView: View {
    @StateObject var game: GameUIState = appState.gameUIState
    @StateObject var sub: SubState = appState.subState

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 勝者・敗者
                HStack(spacing: 30) {
                    VStack() {
                        Text("Winer")
                            .modifier(DecisionScoreViewModifier(fontSize: 30))
                        // TODO: 名前反映
                        Text(sub.resultItem.winners.count > 1 ? "ALL" : sub.resultItem.winners[0].name)
                            .modifier(DecisionScoreViewModifier(fontSize: 20))
                    }
                    VStack() {
                        Text("Loser")
                            .modifier(DecisionScoreViewModifier(fontSize: 30))
                        // TODO: 名前反映
                        Text(sub.resultItem.losers.count > 1 ? "ALL" : sub.resultItem.losers[0].name)
                            .modifier(DecisionScoreViewModifier(fontSize: 20))
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.15)
                
                // 決定アクション
                // TODO: 処理
                VStack(spacing: 40) {
                    Image(ImageName.Card.back.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)

                    HStack() {
                        ForEach(sub.resultItem.decisionScoreCards) { card in
                            Image(card.imageName())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90)
                        }
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.40)
                
                // 最終スコア要素
                // TODO: 反映
                VStack(alignment: .leading) {
                    Text("初期レート：\(game.initialRate)")
                        .modifier(DecisionScoreViewModifier(fontSize: 20))
                    Text("上昇レート：✖︎ \(sub.resultItem.ascendingRate)")
                        .modifier(DecisionScoreViewModifier(fontSize: 20))
                    Text("最終　数字：✖︎ \(sub.resultItem.decisionScoreCards.last!.rate()[1])")
                        .modifier(DecisionScoreViewModifier(fontSize: 20))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, geo.size.width * 0.1)
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.70)
                
                // 最終スコア
                // TODO: 名前反映
                VStack(alignment: .trailing) {
                    Text("＝　\(sub.resultItem.gameScore)")
                        .modifier(DecisionScoreViewModifier(fontSize: 20))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, geo.size.width * 0.1)
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.80)
                
                // 次へボタン
                Button(action: {
                    // 途中結果へ
                    GameFriendEventController().onTapOKButton(gamePhase: .result)
                }) {
                    Btnwb(btnText: "OK", btnTextSize: 30, btnWidth: 200, btnHeight: 50, btnColor: Color.clear)
                }
                .position(x: UIScreen.main.bounds.width * 0.5, y:  geo.size.height * 0.90)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(
                Color.black.opacity(0.93)
            )
        }
    }
}

struct DecisionScoreViewModifier: ViewModifier {
    var fontSize: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom(FontName.font01, size: fontSize))
            .foregroundColor(Color.white)
            .padding(5)
    }
}

struct DecisionCardsView: View {
    
    @Binding var cars: [Card]
    let namespace: Namespace.ID
    
    var body: some View {
        
        HStack(spacing: 10){
            HStack() {
                ForEach(cars) { card in
//                    filedCardView(card: card, namespace: namespace)
                    noScaleCardView(card: card, namespace: namespace, degree: 0, width: 60)

                }
            }
        }
    }
}

