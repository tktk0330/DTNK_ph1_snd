/**
 最終スコア決定画面
 */


import SwiftUI
/**
友達対戦
 */
struct DecisionScoreView: View {
    @StateObject var game: GameUIState = appState.gameUIState
    @StateObject var sub: SubState = appState.subState
    @State private var step: Int = 0

    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                // 勝者・敗者
                HStack(spacing: 30) {
                    VStack() {
                        Text("Winer")
                            .modifier(DecisionScoreViewModifier(fontSize: 30))
                        if step >= 2 {
                            Text(sub.resultItem.winners.count > 1 ? "ALL" : sub.resultItem.winners[0].name)
                                .modifier(DecisionScoreViewModifier(fontSize: 20))
                        } else {
                            Text("")
                                .modifier(DecisionScoreViewModifier(fontSize: 20))
                        }
                    }
                    VStack() {
                        Text("Loser")
                            .modifier(DecisionScoreViewModifier(fontSize: 30))
                        if step >= 2 {
                            Text(sub.resultItem.losers.count > 1 ? "ALL" : sub.resultItem.losers[0].name)
                                .modifier(DecisionScoreViewModifier(fontSize: 20))
                        } else {
                            Text("")
                                .modifier(DecisionScoreViewModifier(fontSize: 20))
                        }
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.15)
                
                    // 決定アクション
                
                Image(ImageName.Card.back.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.30)


                if step >= 1 {
                    HStack() {
                        ForEach(sub.resultItem.decisionScoreCards) { card in
                            Image(card.imageName())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90)
                        }
                    }
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.50)
                }
                
                // 最終スコア要素
                VStack(alignment: .leading) {
                    HStack() {
                        Text("初期レート： ")
                            .modifier(DecisionScoreViewModifier(fontSize: 20))
                        if step >= 2 {
                            Text("\(game.initialRate)")
                                .modifier(DecisionScoreViewModifier(fontSize: 20))
                        }
                    }
                    HStack() {
                        Text("上昇レート： ")
                            .modifier(DecisionScoreViewModifier(fontSize: 20))
                        if step >= 3 {
                            Text("✖︎ \(sub.resultItem.ascendingRate)")
                                .modifier(DecisionScoreViewModifier(fontSize: 20))
                        }
                    }
                    HStack() {
                        Text("最終　数字： ")
                            .modifier(DecisionScoreViewModifier(fontSize: 20))
                        if step >= 4 {
                            Text("✖︎ \(sub.resultItem.decisionScoreCards.last!.rate()[1])")
                                .modifier(DecisionScoreViewModifier(fontSize: 20))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, geo.size.width * 0.1)
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.70)
                
                // 最終スコア
                if step >= 5 {
                    VStack(alignment: .trailing) {
                        Text("＝　\(sub.resultItem.gameScore)")
                            .modifier(DecisionScoreViewModifier(fontSize: 20))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, geo.size.width * 0.1)
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.80)
                }
                
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
                Color.black.opacity(0.98)
            )
            .onAppear {
                // タイマーを使用して段階的に表示
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    if step < 6 {
                        step += 1
                    } else {
                        timer.invalidate()
                    }
                }
            }
        }
    }
}

struct DecisionScoreViewModifier: ViewModifier {
    var fontSize: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom(FontName.MP_Bo, size: fontSize))
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

