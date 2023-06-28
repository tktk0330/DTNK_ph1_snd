/**
 Home
 
 アカウント編集
 ゲーム選択
 ルール選択
 その他Info share
 
 
 */


import SwiftUI

struct HomeView: View {
    
    @StateObject var homegamen: HomeState = appState.home
    
    
    let elements = [["0", ImageName.Home.vsbots.rawValue, "VS BOT"], ["1", ImageName.Home.vsfriends.rawValue, "VS FRIENDS"]]

    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                // 広告用
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                
                
                AccountView()
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.15)

                
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
                PhotosView(width: 300, height: 300) {
                    ForEach(elements, id: \.self) { ele in
                        Button(action: {
                            if ele[0] == "0" {
                                HomeController().onTapPlay()
                            } else {
                                Router().pushBasePage(pageId: .room)
                            }
                        }) {
                            ZStack{
                                Image(ele[1])
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 150)
                                    .padding(10)
                                    .scaledToFit()
                                
                                Text(ele[2])
                                    .font(.system(size: 40))
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                    .padding(5)
                            }
                        }
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 5)
                )
                .cornerRadius(10)
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.55)
                
                
                // Info List
                VStack(spacing: 20) {
                    HStack(spacing: 40) {
                        Button(action: {
                            HomeController().onTapRule()
                        }) {
                            Text("RULE")
                                .font(.system(size: 20))
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .bold()
                                .padding()
                                .frame(width: 120, height: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 3)
                                )
                        }
                        
                        Button(action: {
                            HomeController().onTapShop()
                            
                        }) {
                            Text("SHOP")
                                .font(.system(size: 20))
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .bold()
                                .padding()
                                .frame(width: 120, height: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 3)
                                )
                        }
                    }
                    HStack(spacing: 40) {
                        Button(action: {
                            HomeController().onTapOption()
                        }) {
                            Text("OPTION")
                                .font(.system(size: 20))
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .bold()
                                .padding()
                                .frame(width: 120, height: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 3)
                                )
                        }
                        Button(action: {
                        }) {
                            Text("OTHER")
                                .font(.system(size: 20))
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .bold()
                                .padding()
                                .frame(width: 120, height: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 3)
                                )
                        }
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.87)
             
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
