//
//  MatchingView.swift
//  Dtnk-ver002
//
//  Created by Takuma Shinoda on 2023/05/26.
//

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
                .font(.system(size: 40))
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .padding(5)
                .frame(width: 200)

        }
        .frame(width: 350, height: 80)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 5)
        )
    }
    
    //マッチング中の表示
    func placeHolder() -> some View  {
        return HStack {
            Text("募集中")
                .font(.system(size: 20))
            ProgressView()
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: 80)
        .background(Color.gray)
        .cornerRadius(12)
    }


    var body: some View {
        GeometryReader { geo in
            ZStack{
                // 広告用
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                
                Text("VS BOT")
                    .font(.system(size: 50))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.15)
                
                Text("MATCHING...")
                    .font(.system(size: 40))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.25)
                
                VStack(spacing: 20) {
                    ForEach(0..<4) { index in
                        if room.roomData.participants.count > index {
                            item(nickname: room.roomData.participants[index], iconUrl: "")
                        } else {
                            placeHolder()
                        }
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.60)

            }
            .onAppear {
                room.updateParticipants()
//                MatchingController().onRequest()
                MatchingController().vsFriendsMatching()
            }
        }
    }
}
