/**
 チャレンジ可否ポップアップ
 */

import SwiftUI

struct ChallengePopView: View {
    
    @StateObject var game: GameUIState = appState.gameUIState

    var body: some View {
        GeometryReader { geo in
            
            Image("challenge-2") // Replace with your image name
                .resizable()
                .aspectRatio(contentMode: .fit)
                .position(x: geo.size.width / 2, y: geo.size.height * 0.20)

            Text("追加でカードを引くことでどてんこ返しできる可能性があります。")
                .font(.system(size: 20))
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .padding(20)
                .position(x: geo.size.width / 2, y: geo.size.height * 0.40)
            
            if game.gamevsInfo == .vsFriend && (game.dtnkPlayerIndex == game.myside || game.dtnkFlg[0] == 1) {
                
                WaitingChallengePopView()
                    .onAppear{
                        //　vsFriend 他の人が決まるまで待機
                        if game.gamevsInfo == .vsFriend {
                            GameFriendEventController().moveChallenge(index: appState.gameUIState.myside, ans: .challenge)
                        }
                    }
            } else if game.gamevsInfo == .vsBot && game.dtnkFlg[game.myside] == 1 {
                WaitingChallengePopView()
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                            game.challengeAnswers[game.myside] = .challenge
                        }
                    }
            } else {
                // 参加可否通知を送る
                HStack(spacing: 20) {
                    
                    Button(action: {
                        game.gamePhase = .waiting
                        if game.gamevsInfo == .vsFriend {
                            GameFriendEventController().moveChallenge(index: appState.gameUIState.myside, ans: .nochallenge)
                        } else {
                            GameBotController().moveChallenge(Index: game.myside, ans: .nochallenge)
                        }
                    }) {
                        Btnaction(btnText: "辞退", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightBlue)
                    }
                    // 返せる時
                    if GameBotController().dtnkJudge(myside: game.myside, playerAllCards: game.players[game.myside].hand, table: game.table) != Constants.dtnkCode {
                        Button(action: {
                            if game.gamevsInfo == .vsFriend {
//                                GameFriendEventController().revengeQuick(Index: game.myside, dtnkPlayer: game.players[game.myside])
                                GameFriendEventController().revengeInMain(Index: game.myside)

                            } else {
                                GameBotController().revengeFirst(Index: game.myside)
                            }
                        }) {
                            Btnaction(btnText: "どてんこ返し", btnTextSize: 10, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightRed)
                        }
                        
                    } else {
                        // 参加する
                        Button(action: {
                            game.gamePhase = .waiting
                            if game.gamevsInfo == .vsFriend {
                                GameFriendEventController().moveChallenge(index: appState.gameUIState.myside, ans: .challenge)
                            } else {
                                GameBotController().moveChallenge(Index: game.myside, ans: .challenge)
                            }
                        }) {
                            Btnaction(btnText: "参加", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightRed)
                        }
                    }
                }
                .position(x: geo.size.width / 2, y: geo.size.height * 0.75)
            }
            
        }
        .frame(width: 350, height: 350)
        .background(Color.black.opacity(0.85))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 3)
        )
    }
}
