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
                        Text(sub.resultItem.winners[0].name)
                            .modifier(DecisionScoreViewModifier(fontSize: 20))
                    }
                    VStack() {
                        Text("Loser")
                            .modifier(DecisionScoreViewModifier(fontSize: 30))
                        // TODO: 名前反映
                        Text(sub.resultItem.losers[0].name)
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

struct DecisionView: View {
    
//    @ObservedObject var game = GameUiState()
    @StateObject var game: GameUiState = appState.gameUiState

    //山札
    @Binding var deck: [Card]
    @Namespace private var namespace
    func calculateScore() -> Int {
        return game.rate * game.magunigication * game.decisionnum
    }

    var score: Int {
        get {
            return calculateScore()
        }
        set {
            game.gameScore = newValue
        }
    }
    
    func onTapScoreOK() {
        
        // 手札のリセット
        appState.gameUiState.players.forEach { player in
            player.hand.removeAll()
        }
        // 山札リセット
        appState.gameUiState.deck.cards.removeAll()
        appState.gameUiState.deck =  appState.gameUiState.deck.reset()
        // 場リセット
        appState.gameUiState.table.removeAll()

        // TODO: 次のゲームへの処理を行う
        game.gamePhase = .result
        
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(){
                HStack(spacing: 30) {
                    VStack() {
                        Text("WINNER")
                            .font(.system(size: 30))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .padding(5)
                        
                        Text("\(game.winers.count > 1 ? "ALL" : game.winers[0].name)")
                            .font(.system(size: 30))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .padding(5)
                    }

                    VStack() {
                        Text("LOSER")
                            .font(.system(size: 30))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .padding(5)
                        
                        Text("\(game.loosers.count > 1 ? "ALL" : game.loosers[0].name)")
                            .font(.system(size: 30))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .padding(5)
                    }

                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.15)
                
                // Deck
                // TODO: 表示は裏面にする
                DeckView(deck: $deck, namespace: namespace)
                    .scaleEffect(1.2)
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.4)
                
                // cards
                DecisionCardsView(cars: $game.decisionCards, namespace: namespace)
                    .scaleEffect(1.5)
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.6)

                // Score
                Text("\(game.rate)✖️\(game.magunigication)✖️\(game.decisionnum) = \(score)")
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.80)


                // btn
                Button(action: {
                    game.gameScore = self.score
                    game.finishEvent()
                    onTapScoreOK()

                }) {
                    Text("NEXT")
                        .font(.system(size: 25))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                        .bold()
                        .padding()
                        .frame(width: 100, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.yellow, lineWidth: 3)
                        )
                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.9)
                
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(
                Color.black.opacity(0.93)
            )
        }
        // 画面表示後の処理
        .onAppear {
            //　カードを一枚ずつ引く
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                game.drawLastCard()
            }
        }
        // 画面消去後の処理
        .onDisappear {
        }
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

