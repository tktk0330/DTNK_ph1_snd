/**
 Home
 
 アカウント
 ライフ
 ゲーム選択
 ルール
 オプション
 ショップ
 */

import SwiftUI

struct HomeView: View {
    
    @StateObject var home: HomeState = appState.home

    var body: some View {
        GeometryReader { geo in
            ZStack{
                // Account
                AccountView()
                    .position(x: Constants.scrWidth * 0.50, y:  geo.size.height * 0.25)
                     
                // TODO: Ph2
//                ZStack {
//                    // Life
//                    LifeView()
//                    Text("ComingSoon")
//                        .font(.custom(FontName.font01, size: Constants.scrWidth * 0.1))
//                        .fontWeight(.bold)
//                        .foregroundColor(Color.white)
//                        .rotationEffect(.degrees(10))
//
//                }
//                .position(x: Constants.scrWidth / 2, y:  geo.size.height * 0.27)
                
                // Game List
                VStack (spacing: 40){
                    Button(action: {
                        home.vsInfo = .vsBot
                        HomeController().onTapPageBtn(page: .gameSetting)
                    }) {
                        Btnlgb(imageName: ImageName.Home.vsbots.rawValue, btnText: "ひとりでDOTENKO", btnTextSize: 25, btnWidth: Constants.scrWidth * 0.90, btnHeight: 120, judge: true)
                    }
                    .buttonStyle(PressBtn())
                    
                    Button(action: {
                        home.vsInfo = .vsFriend
                        HomeController().onTapPageBtn(page: .selectJoinType)
                    }) {
                        Btnlgb(imageName:  ImageName.Home.vsfriends.rawValue, btnText: "みんなでDOTENKO", btnTextSize: 25, btnWidth: Constants.scrWidth * 0.90, btnHeight: 120, judge: false)
                    }
                    .buttonStyle(PressBtn())
                }
                .position(x: Constants.scrWidth * 0.50, y:  geo.size.height * 0.58)

                // Info List
                HStack(spacing: 50) {
                    Button(action: {
                        HomeController().onTapPageBtn(page: .rule)
                    }) {
                        Btnwb(btnText: "Rule", btnTextSize: 15, btnWidth: 100, btnHeight: 40)
                    }
                    .buttonStyle(PressBtn())

                    Button(action: {
                        HomeController().onTapPageBtn(page: .option)
                    }) {
                        Btnwb(btnText: "Option", btnTextSize: 15, btnWidth: 100, btnHeight: 40)
                    }
                    .buttonStyle(PressBtn())

                    // TODO: Ph2
//                    Button(action: {
//                        HomeController().onTapPageBtn(page: .shop)
//                    }) {
//                        Btnwb(btnText: "Shop", btnTextSize: 15, btnWidth: 100, btnHeight: 40)
//                    }
//                    .buttonStyle(PressBtn())

                }
                .position(x: Constants.scrWidth * 0.50, y:  geo.size.height * 0.90)
            }
        }
        .onAppear {
            HomeController().enterHome()
        }
        .onDisappear {
            HomeController().exitHome()
        }
    }
}
