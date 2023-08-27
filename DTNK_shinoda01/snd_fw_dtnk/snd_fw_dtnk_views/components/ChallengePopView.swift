/**
 チャレンジ可否ポップアップ
 */

import SwiftUI

struct ChallengePopView: View {
    
    let Index: Int
    let vsInfo: vsInfo

    var body: some View {
        GeometryReader { geo in
            
            Image("challenge-2") // Replace with your image name
                .resizable()
                .aspectRatio(contentMode: .fit)
                .position(x: geo.size.width / 2, y: geo.size.height * 0.20)

            Text("説明文をここに書いてください")
                .font(.system(size: 20))
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .padding(5)
                .position(x: geo.size.width / 2, y: geo.size.height * 0.35 )

            
            // 参加可否通知を送る
            HStack(spacing: 20) {
                
                Button(action: {
                    if vsInfo == .vsFriend {
                        GameFriendEventController().moveChallenge(index: appState.gameUIState.myside, ans: .nochallenge)
                    } else {
                        GameBotController().moveChallenge(Index: Index, ans: .nochallenge)
                    }
                }) {
                    Btnaction(btnText: "辞退", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightBlue)
                }
                
                Button(action: {
                    if vsInfo == .vsFriend {
                        GameFriendEventController().moveChallenge(index: appState.gameUIState.myside, ans: .challenge)
                    } else {
                        GameBotController().moveChallenge(Index: Index, ans: .challenge)
                    }
                }) {
                    Btnaction(btnText: "参加", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.3, btnHeight: 60, btnColor: Color.dtnkLightRed)
                }
            }
            .position(x: geo.size.width / 2, y: geo.size.height * 0.75)
            
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



struct CallengePopView: View {
    
    //    @StateObject var game: GameUiState = appState.gameUiState
    //    let index: Int
    
    var body: some View {
        GeometryReader { geo in
            
            //            Text("Let's Move On To The Next Stage!​")
            //                .font(.system(size: 20))
            //                .foregroundColor(Color.white)
            //                .fontWeight(.bold)
            //                .padding(5)
            //                .position(x: geo.size.width / 2, y: geo.size.height / 4)
            //
            //            HStack(spacing: 10) {
            //
            //                Button(action: {
            //                    // TODO: REVENGE処理に変える
            //                    if game.dtnkJudge(playerAllCards: game.players[0].hand, table: game.table) {
            //                        game.Revengefirst(Index: 0)
            //                        game.challengeFlag[0] = 3
            //                    } else {
            //                        // challenge
            //                        game.challengeFlag[0] = 1
            //                    }
            //                }) {
            //                    Text(game.dtnkJudge(playerAllCards: game.players[0].hand, table: game.table) ? "REVENGE" : "CHALLENGE")
            //                        .font(.system(size: 18))
            //                        .foregroundColor(Color.white)
            //                        .fontWeight(.bold)
            //                        .bold()
            //                        .padding(3)
            //                        .frame(width: 150, height: 50)
            //                        .overlay(
            //                            RoundedRectangle(cornerRadius: 10)
            //                                .stroke(Color.white, lineWidth: 3)
            //                        )
            //                }
            //
            //                Button(action: {
            //                    game.challengeFlag[0] = 2
            //                }) {
            //                    Text("RETIRE")
            //                        .font(.system(size: 18))
            //                        .foregroundColor(Color.white)
            //                        .fontWeight(.bold)
            //                        .bold()
            //                        .padding(3)
            //                        .frame(width: 150, height: 50)
            //                        .overlay(
            //                            RoundedRectangle(cornerRadius: 10)
            //                                .stroke(Color.white, lineWidth: 3)
            //                        )
            //                }
            //            }
            //            .position(x: geo.size.width / 2, y: geo.size.height * 0.7)
            //        }
            //        .frame(width: 350, height: 200)
            //        .background(
            //            Color.black.opacity(0.85)
            //            )
            //        .cornerRadius(20)
            //        .overlay(
            //            RoundedRectangle(cornerRadius: 10)
            //                .stroke(Color.white, lineWidth: 3)
            //        )
        }
    }
}

