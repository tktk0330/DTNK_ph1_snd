/**
 最終スコア決定画面
 */

import SwiftUI

struct DecisionScoreView: View {
    @StateObject var game: GameUIState = appState.gameUIState
    @StateObject var sub: SubState = appState.subState
    @State private var step: Int = 0
    @State private var plus: Int = 0
    @State private var quickDeck: [CardId] = []
    @State private var quickBox: [CardId] = []
    @Namespace private var namespace

    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                // 勝者・敗者
                HStack(spacing: 30) {
                    VStack() {
                        Text("Winer")
                            .modifier(DecisionScoreViewModifier(fontSize: 30))
                        if step >= 2 + plus {
                            Text(sub.resultItem.winners.count > 1 ? "ALL" : sub.resultItem.winners[0].name)
                                .modifier(DecisionScoreViewModifier(fontSize: 20))
                                .onAppear{
                                    SoundMng.shared.playSound(soundName: SoundName.SE.donaction.rawValue)
                                }

                        } else {
                            Text("")
                                .modifier(DecisionScoreViewModifier(fontSize: 20))
                        }
                    }
                    VStack() {
                        Text("Loser")
                            .modifier(DecisionScoreViewModifier(fontSize: 30))
                        if step >= 2 + plus {
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
                Group {
                    QuicDeckView(cars: quickDeck, namespace: namespace)
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.30)
                    
                    DecisionCardsView(cars: quickBox, namespace: namespace)
                        .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.50)
                }
                
                // 最終スコア要素
                VStack(alignment: .leading) {
                    HStack() {
                        Text("初期レート： ")
                            .modifier(DecisionScoreViewModifier(fontSize: 20))
                        if step >= 2 + plus {
                            Text("\(game.initialRate)")
                                .modifier(DecisionScoreViewModifier(fontSize: 20))
                        }
                    }
                    HStack() {
                        Text("上昇レート： ")
                            .modifier(DecisionScoreViewModifier(fontSize: 20))
                        if step >= 3 + plus {
                            Text("✖︎ \(sub.resultItem.ascendingRate)")
                                .modifier(DecisionScoreViewModifier(fontSize: 20))
                                .onAppear{
                                    SoundMng.shared.playSound(soundName: SoundName.SE.donaction.rawValue)
                                }

                        }
                    }
                    HStack() {
                        Text("最終　数字： ")
                            .modifier(DecisionScoreViewModifier(fontSize: 20))
                        if step >= 4 + plus {
                            Text("✖︎ \(sub.resultItem.decisionScoreCards.last!.rate()[1])")
                                .modifier(DecisionScoreViewModifier(fontSize: 20))
                                .onAppear{
                                    SoundMng.shared.playSound(soundName: SoundName.SE.donaction.rawValue)
                                }

                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, geo.size.width * 0.1)
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.70)
                
                // 最終スコア
                if step >= 5 + plus {
                    VStack(alignment: .trailing) {
                        Text("＝　\(sub.resultItem.gameScore)")
                            .modifier(DecisionScoreViewModifier(fontSize: 20))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, geo.size.width * 0.1)
                    .onAppear{
                        SoundMng.shared.playSound(soundName: SoundName.SE.donaction.rawValue)
                    }
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.80)
                }
                
                // 次へボタン
                if step >= 6 + plus {
                    Button(action: {
                        // 途中結果へ
                        GameFriendEventController().onTapOKButton(gamePhase: .result)
                        SoundMng.shared.playSound(soundName: SoundName.SE.btn_positive.rawValue)
                    }) {
                        Btnwb(btnText: "OK", btnTextSize: 30, btnWidth: 200, btnHeight: 50, btnColor: Color.clear)
                    }
                    .position(x: UIScreen.main.bounds.width * 0.5, y:  geo.size.height * 0.90)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(
                Color.black.opacity(0.98)
            )
            .onAppear {
                // スコア代入
                GameMainController().updateScores(with: sub.resultItem.winners, losers: sub.resultItem.losers, gameScore: sub.resultItem.gameScore)
                GameFriendEventController().calculateRanks()
                print("\(game.players[0].rank)")
                print("\(game.players[1].rank)")
                print("\(game.players[2].rank)")
                print("\(game.players[3].rank)")

                // 仮想デッキ作成
                quickDeck = sub.resultItem.decisionScoreCards
                //　カードを一枚ずつ引く
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.addCards()
                }
                // タイマーを使用して段階的に表示
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    if step < 7 + plus {
                        step += 1
                    } else {
                        timer.invalidate()
                    }
                }
            }
        }
    }
    
    func addCards() {
        if let drawnCard = quickDeck.first {
            plus = plus + 1
            quickBox.append(drawnCard)
            quickDeck.removeFirst()

            if !quickDeck.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.addCards()
                }
            }
            
        } else {
            log("quick box draw", level: .error)
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

struct QuicDeckView: View {
    
    var cars: [CardId]
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            ForEach(cars) { card in
                DecisionCardsViewUnit(card: card, namespace: namespace, degree: 0, width: 60)
            }
            
            Image(ImageName.Card.back.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 60)
        }
    }
}

// 裏の数字
struct DecisionCardsView: View {
    
    var cars: [CardId]
    let namespace: Namespace.ID
    
    var body: some View {
        HStack(spacing: 10){
            ForEach(cars) { card in
                DecisionCardsViewUnit(card: card, namespace: namespace, degree: 0, width: 90)
                    .onAppear{
                        // TODO: 種類によって区別
                        if card.rate()[1] == 50 {
                            // rateup
                            VibrateMng.vibrate(type: .defaultVibration)
                            SoundMng.shared.playSound(soundName: SoundName.SE.rateup.rawValue)
                        } else if card.rate()[1] == 20 {
                            // 逆転
                            VibrateMng.vibrate(type: .defaultVibration)
                            SoundMng.shared.playSound(soundName: SoundName.SE.rateup.rawValue)
                        } else if card.rate()[1] == 30 {
                            // 30
                            VibrateMng.vibrate(type: .defaultVibration)
                            SoundMng.shared.playSound(soundName: SoundName.SE.rateup.rawValue)
                        }
                    }
            }
        }
    }
}

struct DecisionCardsViewUnit: View {
    
    let card: CardId
    let namespace: Namespace.ID
    let degree: Double
    let width: Double
    
    var body: some View {

        Flip(degree: degree,
             front:
                Image(card.imageName())
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
        .animation(.default)
    }
}
