/**
 MatchingViwe
*/

import SwiftUI

struct MatchingView: View {
    
    @StateObject var matching: MatchingState = appState.matching
    @StateObject var room: RoomState = appState.room
    
    //プレイヤー
    func item(nickname: String, iconUrl: String) -> some View {
                
        return HStack {
            
            IconView(iconURL: iconUrl, size: 60)
            
            Text(nickname)
                .font(.custom(FontName.MP_Bo, size: 40))
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .padding(5)
                .lineLimit(1)
                .minimumScaleFactor(0.2)
                .frame(width: 200)
        }
        .frame(width: Constants.scrWidth * 0.9, height: 80)
        .cornerRadius(25)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.casinoGreen)
                .shadow(color: Color.casinoShadow, radius: 1, x: 5, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white, lineWidth: 5)
        )
    }
    
    //マッチング中の表示
    func placeHolder() -> some View  {
        return HStack(spacing: 20) {
            Text("募集中")
                .font(.custom(FontName.font01, size: 20))
                .foregroundColor(Color.white)
                .fontWeight(.bold)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.casinoLightGreen))
                .scaleEffect(1.5)
        }
        .frame(width:  UIScreen.main.bounds.width * 0.9, height: 80)
        .cornerRadius(12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black.opacity(0.80))
                .shadow(color: Color.casinoShadow, radius: 1, x: 5, y: 10)
        )
    }

    var body: some View {
        GeometryReader { geo in
            ZStack{
                
                if matching.vsInfo == 02 && !room.startFlg {
                    // back
                    Button(action: {
                        
                        Router().setBasePages(stack: [.home])
                        
                        // 友達対戦の時
                        if !room.roomData.hostID.isEmpty && room.roomData.hostID == appState.account.loginUser.userID {
                            // matchingflgを2に設定
                            RoomFirebaseManager.shared.updateMatchingFlg(roomID: room.roomData.roomID, value: 2)  { result in
                                if result {
                                    FirebaseManager.shared.deleteGamedata(roomID: room.roomData.roomID) { result in
                                    }
                                }
                            }
                        } else if !room.roomData.hostID.isEmpty {
                            RoomFirebaseManager.shared.leaveRoom(roomID: room.roomData.roomID, participantID: appState.account.loginUser.userID) { result in
                                if result {
                                    log("ルーム退出しました")
                                } else {
                                    log("ルーム退出エラー", level: .error)
                                }
                            }
                            
                        }
                        
                    }) {
                        Image(ImageName.Common.back.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40)
                    }
                    .position(x: Constants.scrWidth * 0.10, y:  geo.size.height * 0.13)
                }
                
                // title
                Text("Matching")
                    .font(.custom(FontName.font01, size: 45))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.15)
                
                VStack(spacing: 20) {
                    ForEach(0..<4) { index in
                        if matching.players.count > index {
                            item(nickname: matching.players[index].name, iconUrl:  matching.players[index].icon_url)
                        } else {
                            placeHolder()
                        }
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.55)
                
                
                // gameStartBtn
                if matching.players.count == 4 {
                    if appState.account.loginUser.userID == room.roomData.hostID {
                        Button(action: {
                            room.roommode = .waiting
                            MatchingController().onTapStart(players: matching.players, roomID: room.roomData.roomID)
                        }) {
                            Btnwb(btnText: "OK", btnTextSize: 30, btnWidth: 200, btnHeight: 60)
                        }
                        .position(x: UIScreen.main.bounds.width * 0.5, y: geo.size.height * 0.90)
                    } else {
                        Text("Hostがゲームを開始するまでお待ちください")
                            .font(.custom(FontName.MP_Bo, size: 15))
                            .foregroundColor(Color.white)
                            .padding(5)
                            .blinkEffect(animating: true)
                            .position(x: UIScreen.main.bounds.width * 0.5, y: geo.size.height * 0.25)
                    }
                }
                
                if room.roommode == .waiting {
                    WaitingLoadingView()
                }
                if room.roommode == .exit {
                    RoomExitView()
                }

            }
            .onAppear {
                room.roommode = .base

                if matching.vsInfo == 01 {
                    // vs Bot
                    MatchingController().onRequest()
                } else {
                    // vs Friend
                    // 参加者の監視
                    room.updateParticipants(roomID: room.roomData.roomID)
                }
            }
            .onDisappear {

            }
        }
    }
}
