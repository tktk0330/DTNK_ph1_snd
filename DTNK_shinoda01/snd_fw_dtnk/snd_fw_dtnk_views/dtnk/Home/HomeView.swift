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
                HStack() {
                    ForEach(0..<5) {_ in
                        Image(systemName: "heart.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.30)
                
                
                // Game List
                VStack (spacing: 40){
                    Button(action: {
                        HomeController().onTapPlay()
                    }) {
                        Btnlgb(imageName: ImageName.Home.vsbots.rawValue, btnText: "ひとりでDOTENKO", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.90, btnHeight: 120)
                    }
                    
                    Button(action: {
                        Router().pushBasePage(pageId: .room)
                    }) {
                        Btnlgb(imageName:  ImageName.Home.vsfriends.rawValue, btnText: "みんなでDOTENKO", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.90, btnHeight: 120)
                    }

                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.58)

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
