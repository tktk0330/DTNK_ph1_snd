

import SwiftUI

struct GameEventView: View {
    
    var game: GameUIState
    var myside: Int
    var geo: GeometryProxy
    var fbms: FirebaseManager? = nil

    var body: some View {
        // ゲーム数アナウンス
        if game.gamePhase == .dealcard {
            GmaeNumAnnounce(gameNum: game.gameNum, gameTarget: game.gameTarget)
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height / 2)
        }
        // 開始ボタン
        if game.startFlag && !game.AnnounceFlg && appState.room.roomData.hostID == game.players[myside].id {
            Button(action: {
                if game.gamevsInfo == .vsBot {
                    game.startFlag = false
                    game.gamePhase = .countdown
                } else {
                    game.startFlag = false
                    fbms!.setGamePhase(gamePhase: .countdown) { result in }
                }
                
            }) {
                Text("Start!")
                    .font(.custom(FontName.font01, size: 30))
            }
            .buttonStyle(ShadowButtonStyle())
            .frame(width: Constants.scrWidth * 0.7, height: 100)
            .blinkEffect(animating: true)
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
        }
        
        if game.startFlag && !game.AnnounceFlg && game.gamePhase == .dealcard && appState.room.roomData.hostID != game.players[myside].id {
            ZStack {
                Rectangle()
                    .fill(Color.black.opacity(0.7))
                    .frame(width: UIScreen.main.bounds.width, height: 130)
                
                Text("Hostがゲームを開始するまでお待ちください")
                    .font(.custom(FontName.MP_Bo, size: 15))
                    .foregroundColor(Color.white)
                    .padding(5)
                    .blinkEffect(animating: true)
                    .position(x: Constants.scrWidth * 0.5, y: geo.size.height * 0.5)
            }
        }

        // CountDown
        if game.gamePhase == .countdown {
            StartCountdownView()
                .scaleEffect(1.0)
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
        }
        // 仮想View 初期カード設置
        Text("").onReceive(game.$counter) { newValue in
            if newValue {
                game.gamePhase = .ratefirst
            }
        }
        
        
        Group {
            if game.gamePhase == .dtnk {
                if game.lastPlayerIndex == 99 {
                    GifViewCloser(gifName: GifName.Game.stnk.rawValue) {
                        
                    }
                    .scaleEffect(0.6)
                    .position(x: Constants.scrWidth * 0.5, y: Constants.scrHeight * 0.5)
                } else {
                    GifViewCloser(gifName: GifName.Game.dtnk.rawValue) {
                        
                    }
                    .scaleEffect(0.6)
                    .position(x: Constants.scrWidth * 0.5, y: Constants.scrHeight * 0.5)
                }
            }
            // RevengeinMain
            if game.gamePhase == .revengeInMain {
                GifViewCloser(gifName: GifName.Game.revenge.rawValue) {
                    
                }
                .scaleEffect(0.80)
                .position(x: Constants.scrWidth * 0.5, y: Constants.scrHeight * 0.5)
            }
            // バースト注意文言
            if  game.players[myside].hand.count == Constants.burstCount && (game.gamePhase == .gamefirst_sub || game.gamePhase == .main) {
                BurstCoutionView(text:"Burst Caution").position(x: geo.size.width * 0.68, y: geo.size.height * 1.08)
            }
            // BurstView
            if game.gamePhase == .burst {
                BurstView()
                    .position(x: Constants.scrWidth * 0.5, y: Constants.scrHeight * 0.5)
            }
            // チャレンジ可否ポップ
            if game.gamePhase == .q_challenge {
                ChallengePopView()
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
                    .transition(.move(edge: .top))
                    .animation(.default, value: game.gamePhase == .q_challenge)
            }
            if game.gamePhase == .challenge {
                MovingImage()
            }
            if game.gamePhase == .result {
                ResultView()
            }
            if game.gamePhase == .waiting {
                WaitingView()
            }
        }
    }
}
