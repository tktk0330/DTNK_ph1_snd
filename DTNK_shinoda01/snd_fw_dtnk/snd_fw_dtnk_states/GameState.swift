/**
 メイン画面
 */

import SwiftUI
import Foundation
import AudioToolbox

class GameUiState: ObservableObject {
    
    var sides: [GameUiSide] = []
    // Player
    @Published var players: [Player] = []
    // 総試合数
    @Published var targetgamenum: Int = 0
    // rate
    @Published var rate: Int = 1
    // jorker枚数
    @Published var jorker: Int = 0 {
        didSet{
            deck.appendjorker(Index: jorker)
        }
    }
    
    // Game数
    @Published var gamenum: Int = 1
    // FieldCard
    @Published var table: [Card] = []
    // 裏のカードたち
    @Published var decisionCards: [Card] = []
    // 最後に出したカード
    @Published var lastPlayedCards: [Card] = []
    // 現在プレイしている人
    @Published var currentPlayerIndex: Int = 99
    // 最後にカードを出した人
    @Published var lastPlayCardsPlayer: Player?
    // どてんこした人
    @Published var dtnkPlayer: Player?
    // どてんこした人のIndex
    @Published var dtnkPlayerIndex: Int = 99
    //バーストした人
    @Published var burstPlayer: Player?
    //バーストした人のIndex
    @Published var burstPlayerIndex: Int = 88
    // Game進行
    @Published var progress: String = ""
    // Deck
    @Published var deck = Deck()
    // 最初のカードを出したか
    @Published var isfirstplayer: Bool = false
    // ゲーム状態を示す(大)
    @Published var gamePhaseOrigine: GamePhaseOrigine = .playing {
        didSet {
        }
    }
    // ゲーム状態を示す
    @Published var gamePhase: GamePhase = .dealcard {
        didSet {
            gamePhaseAction(phase: gamePhase)
        }
    }
    // どてんこ判定：誰かがどてんこしたかどうか
    @Published var gamedtnk: Bool = false
    // 出さないことを通知
    @Published var initialAction: [Bool] = [true, true, true, true] {
        didSet {
            // 変更されたときに実行する処理を記述する
            print("initialActionが変更されました")
            judgeFirstPlayer()
        }
    }
    // 倍率
    @Published var magunigication: Int = 1
    // 決定数
    @Published var decisionnum: Int = 1
    // ゲームスコア
    @Published var gameScore: Int = 1
    // 勝者：オールの場合もある
    @Published var winers: [Player] = []
    // 負者：オールの場合もある
    @Published var loosers: [Player] = []
    // チャレンジプレイヤー
    @Published var challengeplayers: [Player] = []
    // チャレンジ通知 init :0 yes :1 no :2 dtnkplayer :3
    @Published var challengeFlag: [Int] = [0, 0, 0, 0] {
        didSet {
            let quickPhase = GameMainController().moveChallengeEvent(challengeFlag: challengeFlag)
            if quickPhase != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.gamePhase = quickPhase!
                }
            }
            
        }
    }
    
    // FRONT
    // カードは１ターン１
    @Published var canDraw = true
    // pass or play
    @Published var canTurn = true
    
    init() {
        deck.shuffle()
    }
    
    //**********************************************************************************
    // About GamePhase
    //**********************************************************************************
    
    /**
     gamePhase変更時に値に依存して実行される関数
     */
    func gamePhaseAction(phase: GamePhase) {
        
        switch phase {
            // カードを配っている
        case .dealcard:
            print(phase)
            // ゲーム数のアナウンス
        case .gamenum:
            print(phase)
            // カウントダウン
        case .countdown:
            changedcountdown()
            // 最初のめくり
        case .ratefirst:
            changedratefirst()
            // SYOTENKO動作
        case .gamefirst:
            changedgamefirst()
            // 最初のプレイヤーをランダムで決定
        case .decisioninitialplayer:
            changeddecisioninitialplayer()
            // SYOTENKO可能状態？
        case .gamefirst_sub:
            print(phase)
            // メイン
        case .main:
            log("")
            // DOTENKO
        case .dtnk:
            changeddtnk()
            //　チャレンジするか質問
        case .burst:
            print(phase)
        case .q_challenge:
            changeq_challenge()
            //　チャレンジモード
        case .challenge:
            changedchallege()
            // 準備
        case .decisionrate_pre:
            changeddecisionrate_pre()
            //　スコア決定
        case .decisionrate:
            print(phase)
            //　結果
        case .result:
            print(phase)
        case .other:
            print(phase)
        case .revenge:
            changedrevenge()
        case .waiting:
            print(phase)
            
        }
    }
    
    func changedcountdown() {
        // X秒後にratefirst
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.gamePhase = .ratefirst
        }
    }
    
    func changedratefirst() {
        // 最初のカードを配置する + 特定数字だったらレート上げる
        firstCard()
    }
    
    func changedgamefirst() {
        // Botの初期アクション
        //        botSyotenko()
    }
    
    func changeddecisioninitialplayer() {
        // X秒後にratefirst
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            // まだ誰も出せずSYOTENKO可能状態である時
            gamePhase = .main
            // ペラペラが終わったら決まったプレイヤから始める
            let index = (currentPlayerIndex - 1 + 4) % 4
            //            botTurn(Index: index)
        }
    }
    
    func changeddtnk() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // 可否
            self.gamePhase = .q_challenge
        }
    }
    
    func changeq_challenge() {
        var numbers = [1, 2, 3]
        numbers.shuffle()
        // Botチャレンジ可否を送信
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
            for i in 0..<numbers.count {
                if gamePhase == .q_challenge {
                    challengeFlag[numbers[i]] = BotController().CheckBotChallenge(
                        bot: players[numbers[i]],
                        Index: numbers[i],
                        table: table,
                        dtnkPlayerIndex: dtnkPlayerIndex)
                    
                    // REVENGE
                    if challengeFlag[numbers[i]] == 99 {
                        dtnkevent(Index: numbers[i])
                    }
                } else {
                    print("割り込み発生？")
                }
            }
        }
    }
    
    func changedchallege() {
        AnnounceLabel("CHALLENGE"){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                // どてんこした次の人からカードを引く
                let index = dtnkPlayerIndex
                moveToNextPlayer(Index: index)
            }
        }
    }
    
    func changeddecisionrate_pre() {
        winloos()
        // X秒後にratefirst
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.gamePhase = .decisionrate
        }
    }
    
    func changedrevenge() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // 可否
            self.gamePhase = .q_challenge
        }
    }
    
    //**********************************************************************************
    // About Action
    //**********************************************************************************
    
    /**
     誰も出せなかった時にランダムで最初のプレイヤーを決める
     */
    func judgeFirstPlayer() {
//        if initialAction.allSatisfy({ $0 == false }) {
//            let randomInitialPlayerIndex = Int.random(in: 0...3)
//            currentPlayerIndex = randomInitialPlayerIndex
//            gamePhase = .decisioninitialplayer
//            progress = "\(players[currentPlayerIndex].name)の番です"
//            // Reset
//            initialAction = Array(repeating: true, count: initialAction.count)
//        }
    }
    
    /**
     どてんこ
     どてんこプレイヤーの設定
     */
    func dtnkevent(Index: Int) {
        Vibration().vib01()
        let generator = UINotificationFeedbackGenerator()
        @State var isVibrationOn = false
        generator.notificationOccurred(.success)
        
        gamedtnk = true
        dtnkPlayer = players[Index]
        dtnkPlayerIndex = Index
        gamePhase = .dtnk
        challengeFlag[Index] = 3
        print("Bot \(Index) DOTENKO")
    }
    
        
    /**
     リベンジ challenge
     */
    func RevengeAction(Index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            // レートを上げる
            magunigication = 2 * magunigication
            // どてんこ更新
            lastPlayCardsPlayer = dtnkPlayer
            lastPlayCardsPlayer?.hand.removeAll()
            dtnkPlayer = players[Index]
            dtnkPlayerIndex = Index
            // 勝敗更新
            winloos()
            moveToNextPlayer(Index: Index)
        }
    }
    
    /**
     リベンジ challenge
     */
    func Revengefirst(Index: Int) {
        gamePhase = .revenge
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            // レートを上げる
            magunigication = 2 * magunigication
            // どてんこ更新
            lastPlayCardsPlayer = dtnkPlayer
            lastPlayCardsPlayer?.hand.removeAll()
            dtnkPlayer = players[Index]
            dtnkPlayerIndex = Index
            // 勝敗更新
            winloos()
        }
    }
    
    
    /**
     チャレンジ
     次のチャレンジャーのターンへ
     */
    func moveToNextPlayer(Index: Int){
        let nextPlayerIndex = (Index + 1) % players.count
        if nextPlayerIndex == dtnkPlayerIndex {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.gamePhase = .decisionrate_pre
            }
            return
        }
        // 次のプレイヤーの手番を開始
//        drawIndex(Index: nextPlayerIndex)
    }
    
    /**
     勝敗を決める
     */
    func winloos() {
        // 勝者・敗者の初期化
        winers.removeAll()
        loosers.removeAll()
        // SYOTENKO
        if currentPlayerIndex == 99 {
            winers.append(dtnkPlayer!)
            let otherPlayers = players.filter { $0.side != dtnkPlayer!.side }
            loosers.append(contentsOf: otherPlayers)
            // Revenge対策
            currentPlayerIndex = dtnkPlayerIndex
        } else if currentPlayerIndex == 88{
            loosers.append(burstPlayer!)
            let otherPlayers = players.filter { $0.side != burstPlayer!.side }
            winers.append(contentsOf: otherPlayers)
        }
        else {
            //　勝敗決定
            winers.append(dtnkPlayer!)
            loosers.append(lastPlayCardsPlayer!)
        }
    }
    
    /**
     ゲーム結果設定
     */
    func finishEvent() {
        // Score移動
        for winner in winers {
            winner.score += gameScore * loosers.count
        }
        for looser in loosers {
            looser.score -= gameScore * winers.count
        }
        // ゲーム結果情報
        let this_num = gamenum
        let this_rate = rate
        let this_magunigication = magunigication
        let this_decisionnum = decisionnum
        let this_score = this_rate * this_magunigication * this_decisionnum
        let this_winners = winers
        let this_looser = loosers
        
        let gameitem = GameResultItem(
            gamenum: this_num,
            rate: this_rate,
            magunigication: this_magunigication,
            decisionnum: this_decisionnum,
            gamescore: this_score,
            winners: this_winners,
            loosers: this_looser)
        
        // Player結果情報
        let sorted: [Player] = players.sorted(by: {
            return  $0.score > $1.score
        })
        
        let playerItems = sorted.enumerated().map { (index, player) -> PlayerResultItem in
            let rank = index + 1
            let item = PlayerResultItem(
                rank: rank,
                index: player.side - 1,
                iconUrl: player.icon_url,
                name: player.name,
                score: player.score,
                changed: 0
            )
            return item
        }
        // 結果画面の表示
        let scoreUiState = ResultState(gameitems: gameitem, playeritems: playerItems)
        appState.resultState = scoreUiState
    }
    
    //**********************************************************************************
    // About Player card Action
    //**********************************************************************************
    
    /**
     初期操作：カードを配る
     */
    func dealCards(completion: @escaping (Bool) -> Void) {
        
        for i in 0..<players.count*2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.2)) { [self] in
                if let card = self.deck.draw() {
                    players[i % players.count].hand.append(card)
                }
            }
        }
        completion(true)
    }
    
    /**
     最初のカードを配置する + 特定数字だったらレート上げる
     */
    func firstCard() {
        var cards: [Card] = []
        if let card = self.deck.draw() {
            cards.append(card)
            self.table.append(contentsOf: cards)
            if card.cardid.rate()[0] == 50 {
                self.magunigication = 2 * self.magunigication
                AnnounceLabel("RATE UP"){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.firstCard()
                    }
                }
            } else {
                gamePhase = .gamefirst
            }
        }
    }
    
    /**
     最終カードを決める時に引くやつ
     */
    func drawLastCard() {
        withAnimation {
            var cards: [Card] = []
            if let card = self.deck.draw() {
                cards.append(card)
                self.decisionCards.append(contentsOf: cards)
                switch card.cardid.rate()[1] {
                case 50:
                    self.magunigication = 2 * self.magunigication
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.drawLastCard()
                    }
                case 20:
                    let quick = winers
                    winers = loosers
                    loosers = quick
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.drawLastCard()
                    }
                case 30:
                    self.decisionnum = 30
                default:
                    self.decisionnum = decisionCards.last!.number
                }
            }
        }
    }
    
    /**
     カードを引く
     */
    func drawCard() {
        if players[currentPlayerIndex].hand.count >= 7 {
            print("maxcard")
        }
        else {
            if let card = deck.draw() {
                players[currentPlayerIndex].hand.append(card)
            }
            // deckが０の場合は再生成
            if (deck.cards.count < 1){
                // shuffle
                restorationeck()
            }
        }
    }
    
    /**
     カードを再生成する
     */
    func restorationeck() {
        //deckに戻す　一番上だけ残すため逆順で回す
        for i in (0..<table.count-1).reversed() {
            // new deckに追加
            deck.cards.append(table[i])
            // tableから削除する
            table.remove(at: i)
        }
        deck.shuffle()
        print("デッキが再構築されました")
    }
}
