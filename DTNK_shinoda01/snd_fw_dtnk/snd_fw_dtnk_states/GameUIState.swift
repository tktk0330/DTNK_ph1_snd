/**
 Game State
 */

import SwiftUI

class GameUIState: ObservableObject {
    
    // ID
    @Published var gameID: String = ""
    // Game
    @Published var gameNum: Int = 1
    // TargetGame
    @Published var gameTarget: Int = 1
    // vsInfo
    @Published var gamevsInfo: vsInfo?
    // ゲーム状態を示す
    @Published var gamePhase: GamePhase = .dealcard {
        didSet {
            gamePhaseAction(vsInfo: gamevsInfo!, phase: gamePhase)
        }
    }
    @Published var deck: [CardId] = []
    @Published var cardUI: [N_Card] = cards
    @Published var table: [CardId] = [] {
        didSet {
            if gamevsInfo == .vsBot {
                checkBotDtnk()
            }
        }
    }
    @Published var jorker: Int = 2
    @Published var players: [Player_f] = []
    @Published var myside: Int = 99
    // 現在プレイしている人
    @Published var currentPlayerIndex: Int = Constants.stnkCode {
        didSet {
            if gamevsInfo == .vsBot {
                botTurnAction(Index: currentPlayerIndex)
            }
        }
    }
    // 最後にカードを出した人
    @Published var lastPlayerIndex: Int = Constants.stnkCode
    // どてんこした人
    @Published var dtnkPlayer: Player_f?
    // どてんこした人のIndex
    @Published var dtnkPlayerIndex: Int = Constants.stnkCode
    // バーストした人
    @Published var burstPlayer: Player_f?
    // バーストした人のIndex
    @Published var burstPlayerIndex: Int = Constants.burstCode
    // 初め出せるか通知
    @Published var firstAnswers: [FirstAnswers] = Array(repeating: FirstAnswers.initial, count: 4) {
        didSet {
            if gamevsInfo == .vsBot && firstAnswers.allSatisfy({ $0 == FirstAnswers.pass }) {
                judgeFirstPlayer()
            }
        }
    }
    // チャレンジ通知
    @Published var challengeAnswers: [ChallengeAnswer] = Array(repeating: ChallengeAnswer.initial, count: 4) {
        didSet {
            if gamevsInfo == .vsBot && challengeAnswers.allSatisfy({ $0 != ChallengeAnswer.initial }) {
                gamePhase = .challenge
            }
        }
    }
    // 完了通知
    @Published var nextGameAnnouns: [NextGameAnnouns] = Array(repeating: NextGameAnnouns.initial, count: 4)
    // 裏のカードたち
    @Published var decisionScoreCards: [CardId] = []
    // 初期レート
    @Published var initialRate: Int = 1
    // 上昇レート
    @Published var ascendingRate: Int = 1
    // 勝者：オールの場合もある
    @Published var winners: [Player_f] = []
    // 負者：オールの場合もある
    @Published var losers: [Player_f] = []
    // ゲームスコア
    @Published var gameScore: Int = 1
    // レートアップカード
    @Published var rateUpCard: String? = nil
    // initialFlipの仮変数
    @Published var initialPlayerIndex: Int? = nil
    // どてんこ返し [返した人　返された人]
    @Published var revengerIndex: [Int] = []
    // FB必要なし
    @Published var counter: Bool = false   // カウンター
    @Published var startFlag: Bool = false // startBtn
    @Published var AnnounceFlg = false     // 実行中 true 非表示中　false
    @Published var turnFlg: Int = 0        // 0: canDraw 1: canPass
    @Published var dtnkFlg: Int = 0        // 0: no 1: dtnked
    @Published var regenerationDeckFlg: Int = 0        // 0: no 1: dtnked



    /**
     Botのターンを回す
     */
    func botTurnAction(Index: Int) {
        switch Index {
        case 1, 2, 3:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                GameBotController().botAction(Index: Index) { result in }
            }
        case 0:
            break;
        default:
            break;
        }
    }
    
    /**
     Phaseの操作　bot Friendで分ける
     */
    func gamePhaseAction(vsInfo: vsInfo, phase: GamePhase) {
        
        switch vsInfo {
        case .vsBot:
            switch phase {
            case .dealcard:
                // カード配る
                GameBotController().dealCards() { [self] result in
                    if result {
                        startFlag = true
                    }
                }
            case .gamenum:
                log("\(phase)")
            case .countdown:
                log("\(phase)")
            case .ratefirst:
                GameBotController().firstCard()
            case .gamefirst:
                GameBotController().BotGameInit()
            case .decisioninitialplayer:
                GameBotController().endFlip()
            case .gamefirst_sub:
                log("\(phase)")
            case .main:
                log("\(phase)")
            case .dtnk:
                log("\(phase)")
            case .burst:
                log("\(phase)")
            case .revenge:
                log("\(phase)")
            case .q_challenge:
                GameBotController().moveChallengeBot()
            case .challenge:
                GameBotController().challengeEvent()
            case .decisionrate_pre:
                GameBotController().preparationFinalPhase()
            case .decisionrate:
                log("\(phase)")
            case .result:
                log("\(phase)")
            case .other:
                log("\(phase)")
            case .waiting:
                log("\(phase)")
            }
            
        case .vsFriend:
            switch phase {
            case .dealcard:
                GameObserber(hostID: appState.room.roomData.hostID).dealFirst(players: players) { [self] result in
                    startFlag = true
                }
            case .gamenum:
                log("\(phase)")
            case .countdown:
                log("\(phase)")
            case .ratefirst:
                log("\(phase)")
            case .gamefirst:
                log("\(phase)")
            case .decisioninitialplayer:
                log("\(phase)")
            case .gamefirst_sub:
                log("\(phase)")
            case .main:
                log("\(phase)")
            case .dtnk:
                log("\(phase)")
            case .burst:
                log("\(phase)")
            case .revenge:
                log("\(phase)")
            case .q_challenge:
                log("\(phase)")
            case .challenge:
                GameObserber(hostID: appState.room.roomData.hostID).challengeEvent()
            case .decisionrate_pre:
                GameObserber(hostID: appState.room.roomData.hostID).preparationFinalPhase()
            case .decisionrate:
                log("\(phase)")
            case .result:
                log("\(phase)")
            case .other:
                log("\(phase)")
            case .waiting:
                log("\(phase)")
            }
        }
    }
    
    /**
     Botがどてんこできるか調査する
     */
    func checkBotDtnk() {
        for i in 1...3 {
            GameBotController().checkBotHand(Index: i, player: players[i])
        }
    }
    
    /**
     誰も出せなかった時、Hostから順にゲームを始める
     TODO：　誰も出せなかった時にランダムで最初のプレイヤーを決める
     */
    func judgeFirstPlayer() {
        //        let randomInitialPlayerIndex = Int.random(in: 0...3)
        //        currentPlayerIndex = randomInitialPlayerIndex
        //        gamePhase = .decisioninitialplayer
        log("誰も出せないのでホストから始める")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            currentPlayerIndex = 0
            gamePhase = .gamefirst_sub
        }
    }

    /**
     次のゲームの準備
     */
    func preparationNewGame(resetItem: GameResetItem, completion: @escaping (Bool) -> Void) {
        self.gameNum = resetItem.gameNum
        self.deck = resetItem.deck
        self.table = resetItem.table as? [CardId] ?? []
        for player in self.players {
            player.hand.removeAll()
        }
        self.currentPlayerIndex = resetItem.currentPlayerIndex
        self.lastPlayerIndex = resetItem.lastPlayerIndex
        self.dtnkPlayerIndex = resetItem.dtnkPlayerIndex
        self.dtnkPlayer = nil
        self.burstPlayerIndex = resetItem.burstPlayerIndex
        self.burstPlayer = nil
        self.ascendingRate = resetItem.ascendingRate
        self.decisionScoreCards = []
        self.challengeAnswers = resetItem.challengeAnswers.compactMap { ChallengeAnswer(rawValue: $0) }
        self.nextGameAnnouns = resetItem.nextGameAnnouns.compactMap { NextGameAnnouns(rawValue: $0) }
        self.firstAnswers = resetItem.firstAnswers.compactMap { FirstAnswers(rawValue: $0) }
        self.winners = []
        self.losers = []
        self.gameScore = resetItem.gameScore
        
        self.turnFlg = 0
        self.dtnkFlg = 0
        self.players[0].selectedCards = []
        completion(true)
    }
}

var cards: [N_Card] = [
    
    N_Card(id: .back, location: .deck),
    
    N_Card(id: .spade1, location: .deck),
    N_Card(id: .spade2, location: .deck),
    N_Card(id: .spade3, location: .deck),
    N_Card(id: .spade4, location: .deck),
    N_Card(id: .spade5, location: .deck),
    N_Card(id: .spade6, location: .deck),
    N_Card(id: .spade7, location: .deck),
    N_Card(id: .spade8, location: .deck),
    N_Card(id: .spade9, location: .deck),
    N_Card(id: .spade10, location: .deck),
    N_Card(id: .spade11, location: .deck),
    N_Card(id: .spade12, location: .deck),
    N_Card(id: .spade13, location: .deck),
    
    N_Card(id: .diamond1, location: .deck),
    N_Card(id: .diamond2, location: .deck),
    N_Card(id: .diamond3, location: .deck),
    N_Card(id: .diamond4, location: .deck),
    N_Card(id: .diamond5, location: .deck),
    N_Card(id: .diamond6, location: .deck),
    N_Card(id: .diamond7, location: .deck),
    N_Card(id: .diamond8, location: .deck),
    N_Card(id: .diamond9, location: .deck),
    N_Card(id: .diamond10, location: .deck),
    N_Card(id: .diamond11, location: .deck),
    N_Card(id: .diamond12, location: .deck),
    N_Card(id: .diamond13, location: .deck),
    
    N_Card(id: .club1, location: .deck),
    N_Card(id: .club2, location: .deck),
    N_Card(id: .club3, location: .deck),
    N_Card(id: .club4, location: .deck),
    N_Card(id: .club5, location: .deck),
    N_Card(id: .club6, location: .deck),
    N_Card(id: .club7, location: .deck),
    N_Card(id: .club8, location: .deck),
    N_Card(id: .club9, location: .deck),
    N_Card(id: .club10, location: .deck),
    N_Card(id: .club11, location: .deck),
    N_Card(id: .club12, location: .deck),
    N_Card(id: .club13, location: .deck),

    N_Card(id: .heart1, location: .deck),
    N_Card(id: .heart2, location: .deck),
    N_Card(id: .heart3, location: .deck),
    N_Card(id: .heart4, location: .deck),
    N_Card(id: .heart5, location: .deck),
    N_Card(id: .heart6, location: .deck),
    N_Card(id: .heart7, location: .deck),
    N_Card(id: .heart8, location: .deck),
    N_Card(id: .heart9, location: .deck),
    N_Card(id: .heart10, location: .deck),
    N_Card(id: .heart11, location: .deck),
    N_Card(id: .heart12, location: .deck),
    N_Card(id: .heart13, location: .deck),

    // TODO: Jorker 4?
    N_Card(id: .blackJocker, location: .deck),
    N_Card(id: .whiteJocker, location: .deck),

]

enum CardLocation: Equatable {
    case deck
    case table
    // playerIndex　誰か [0 1 2 3]    cardIndex　何枚目か [0 1 2 3 4 5 6]
    case hand(playerIndex: Int, cardIndex: Int)
}
