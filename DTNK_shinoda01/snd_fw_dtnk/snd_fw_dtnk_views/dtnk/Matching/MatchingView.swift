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
            Image(iconUrl)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .aspectRatio(contentMode: .fit)
                .padding(5)
                .frame(width: 60, height: 60)
            
            Text(nickname)
                .font(.custom(FontName.font01, size: 40))
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .padding(5)
                .frame(width: 200)

        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 80)
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
                BunnerView(geo: geo)

                // back
                // TODO: 戻るときのロジック＆アナウンス
                Button(action: {
                    //                    MatchingController().backMatching(room: room.roomData, user: appState.account.loginUser)
                    Router().setBasePages(stack: [.room])
                }) {
                    Image(ImageName.Common.back.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                }
                .position(x: UIScreen.main.bounds.width * 0.10, y:  geo.size.height * 0.10)
                
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
                    }
                }
                
                if room.roommode == .waiting {
                    WaitingLoadingView()
                }

            }
            .onAppear {
                if matching.vsInfo == 01 {
                    MatchingController().onRequest()
                } else {
                    // 参加者の監視
                    room.updateParticipants(roomID: room.roomData.roomID)
                }
//                MatchingController().vsFriendsMatching()
            }
            .onDisappear {

            }
        }
    }
}
