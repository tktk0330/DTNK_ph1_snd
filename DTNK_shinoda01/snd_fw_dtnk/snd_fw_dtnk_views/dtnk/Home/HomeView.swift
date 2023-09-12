/**
 Home
 
 アカウント編集
 ゲーム選択
 ルール選択
 その他Info share

 */

import SwiftUI

struct HomeView: View {
    
    @StateObject var home: HomeState = appState.home
    @StateObject var heartsController: HeartsRecoverController = HeartsRecoverController.shared
    @State private var showAlert = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                // 広告用
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                
                // Account
                AccountView()
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.15)
                       
                // Life
                HStack {
                                    VStack {
                                        if appState.home.heartsData.heartsCount <= 4 {
                                            // タイマーの残り時間を表示
                                            Text(String(format: "%.0f", max(appState.home.heartsData.remainingTime, 0)))
                                                .foregroundColor(.black)
                                                .font(.system(size: 30, weight: .bold))
                                        } else {
                                            Text(" ")
                                                .font(.system(size: 30, weight: .bold))
                                        }

                                        HStack(spacing: 10) {
                                            ForEach(0..<5) { index in
                                                Image(systemName: "heart.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 30, height: 30)
                                                    .foregroundColor(index < appState.home.heartsData.heartsCount ? .red : .gray)
                                            }

                                            Button(action: {
//                                                if appState.home.heartsData.heartsCount < 5 { // 上限を5に制限
                                                                    print("ハートの購入処理")
                                                                    appState.home.heartsData.heartsCount -= 1
                                              //  }
                                            }) {
                                                Image(ImageName.Home.healbox.rawValue)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 30, height: 30)
                                            }
                                        }
                                    }
                                }
                                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.27)
                                .onAppear {
                                    if appState.home.heartsData.heartsCount != 5 {
                                        heartsController.stopTimer()
                                        print("タイマーストップview")
                                        // ハートの回復タイマーを開始
                                        heartsController.startTimer()
                                        print("タイマー始動view")
                                    }
                                }
                          
                // Game List
                VStack (spacing: 40){
                    Button(action: {
                        HomeController().hasHeartSoloPlay()
                    }) {
                        Btnlgb(imageName: ImageName.Home.vsbots.rawValue, btnText: "ひとりでDOTENKO", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.90, btnHeight: 120)
                    }
                    
                    Button(action: {
                        HomeController().hasHeartMultiPlay()
                    }) {
                        Btnlgb(imageName:  ImageName.Home.vsfriends.rawValue, btnText: "みんなでDOTENKO", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.90, btnHeight: 120)
                    }

                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.58)
                .alert(isPresented: $home.heartsData.showAlert) {
                            Alert(title: Text("ハートが足りません"),
                                  message: Text("ハートを回復してください。"),
                                  dismissButton: .default(Text("OK")))
                        }

                // Info List
                HStack(spacing: 20) {
                    Button(action: {
                        HomeController().onTapRule()
                    }) {
                        Btnwb(btnText: "Rule", btnTextSize: 15, btnWidth: 100, btnHeight: 40)
                    }
                    Button(action: {
                        HomeController().onTapOption()
                    }) {
                        Btnwb(btnText: "Option", btnTextSize: 15, btnWidth: 100, btnHeight: 40)
                    }
                    Button(action: {
                        HomeController().onTapShop()
                    }) {
                        Btnwb(btnText: "Shop", btnTextSize: 15, btnWidth: 100, btnHeight: 40)
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.90)
             
                Group{
                    if home.mode == .edittingNickname {
                        EditNicknameView()
                    }
                    
                    if home.mode == .edittingIcon {
                        SelectIconView()
                    }
                    
                    if home.mode == .checkrule {
                        GameRuleView()
                            .transition(.move(edge: .bottom))
                            .animation(.default, value: home.mode == .checkrule)
                    }
                    
                    if home.mode == .checkshop{
                        ShopView()
                    }
                    
                    if home.mode == .checkoption {
                        OptionView()
                    }
                    
                    if home.mode == .gamesetting {
                        GameSettingView()
                            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
                    }
                }
            }
        }
    }
    


}
