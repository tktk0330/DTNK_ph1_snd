/**
 ゲーム設定画面
 */

import SwiftUI

struct GameSettingView: View {
    
    @StateObject var home: HomeState = appState.home
    @StateObject var account: AccountState = appState.account
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                // 広告用
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                
                // back
                Button(action: {
                    Router().setBasePages(stack: [.home])
                }) {
                    Image(ImageName.Common.back.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                }
                .position(x: UIScreen.main.bounds.width * 0.10, y:  geo.size.height * 0.10)
                
                // title
                Text("GameSetting")
                    .font(.custom(FontName.font01, size: 35))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.15)
                
                Rectangle()
                    .foregroundColor(Color.yellowGreen)
                    .frame(width: geo.size.width, height: geo.size.height / 1.75)
                    .offset(y: -geo.size.height / 350)
                
                VStack(spacing: 35) {
                    
                    HStack(spacing: 40) {
                        Button(action: {
                            home.mode = .gameNum
                        }) {
                            settingUnitView(imageName: "number", text: "ゲーム数")
                        }
                        .modifier(settingUnitModifier())
                        
                        Button(action: {
                            home.mode = .joker
                        }) {
                            settingUnitView(imageName: "jorker", text: "Jorker")
                        }
                        .modifier(settingUnitModifier())
                    }
                    
                    HStack(spacing: 40) {
                        Button(action: {
                            home.mode = .rate
                        }) {
                            settingUnitView(imageName: "rate", text: "Rate")
                        }
                        .modifier(settingUnitModifier())
                        
                        Button(action: {
                            home.mode = .max
                        }) {
                            settingUnitView(imageName: "max", text: "上限")
                        }
                        .modifier(settingUnitModifier())
                    }
                    
                    HStack(spacing: 40) {
                        Button(action: {
                            home.mode = .uprate
                        }) {
                            settingUnitView(imageName: "uprate", text: "重ね")
                        }
                        .modifier(settingUnitModifier())
                        
                        Button(action: {
                            home.mode = .deck
                        }) {
                            settingUnitView(imageName: "deck", text: "デッキサイクル")
                        }
                        .modifier(settingUnitModifier())
                    }
                }
                .padding()
                .navigationBarTitle("Button Grid")
                
                Button(action: {
                    // TODO: ライフ処理
                    HomeController().onTapStart(gamenum: account.loginUser.gameNum, rate: account.loginUser.gameRate, jorker: account.loginUser.gameJorker)
                }) {
                    Btnwb(btnText: "Start", btnTextSize: 30, btnWidth: 200, btnHeight: 50)
                }
                .position(x: Constants.scrWidth / 2, y:  Constants.scrHeight * 0.80)
            }
            
            // setting unit
            if home.mode != .noEditting && home.mode != .edittingNickname && home.mode != .edittingIcon {
                GameSettingUnitView(mode: home.mode)
            }
        }
    }
}

// 項目View
struct settingUnitView: View {
    let imageName: String
    let text: String
    
    var body: some View {
        VStack(spacing: 2) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Constants.scrWidth / 12, height: Constants.scrWidth / 12)

            Text(text)
                .font(.system(size: 15))
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding(10)
    }
}

// 項目Modifire
struct settingUnitModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 10, y: 10)
            .frame(width: Constants.scrWidth / 3, height: Constants.scrHeight / 9)
            .background(Color.plusDarkGreen)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)
    }
}
