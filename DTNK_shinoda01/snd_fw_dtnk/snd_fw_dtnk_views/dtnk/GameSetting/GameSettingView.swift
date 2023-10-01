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
                BunnerView(geo: geo)
                
                // back
                BackButton(backPage: .home, geo: geo)

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
                    
                    HStack(spacing: 30) {
                        Button(action: {
                            home.mode = .gameNum
                        }) {
                            settingUnitView(imageName: ImageName.Setting.gameNum.rawValue, text: "ゲーム数", nowItem: String(account.loginUser.gameNum))
                        }
                        .modifier(settingUnitModifier())
                        
                        Button(action: {
                            home.mode = .joker
                        }) {
                            settingUnitView(imageName: ImageName.Setting.gameJorker.rawValue, text: "Jorker", nowItem: String(account.loginUser.gameJorker))
                        }
                        .modifier(settingUnitModifier())
                    }
                    
                    HStack(spacing: 30) {
                        Button(action: {
                            home.mode = .rate
                        }) {
                            settingUnitView(imageName: ImageName.Setting.gameRate.rawValue, text: "Rate", nowItem: String(account.loginUser.gameRate))
                        }
                        .modifier(settingUnitModifier())
                        
                        Button(action: {
                            home.mode = .max
                        }) {
                            untilSettingUnitView(imageName: ImageName.Setting.gameMaximum.rawValue, text: "上限", nowItem: String(account.loginUser.gameMaximum))
                        }
                        .modifier(untilSettingUnitModifier())
                    }
                    
                    HStack(spacing: 30) {
                        Button(action: {
                            home.mode = .uprate
                        }) {
                            untilSettingUnitView(imageName: ImageName.Setting.gameUpRate.rawValue, text: "重ね", nowItem: String(account.loginUser.gameUpRate))
                        }
                        .modifier(untilSettingUnitModifier())
                        
                        Button(action: {
                            home.mode = .deck
                        }) {
                            untilSettingUnitView(imageName: ImageName.Setting.gameDeck.rawValue, text: "サイクル", nowItem: String(account.loginUser.gameDeckMaximum))
                        }
                        .modifier(untilSettingUnitModifier())
                    }
                }
                .padding()
                .navigationBarTitle("Button Grid")
                
                if home.vsInfo == .vsBot {
                    Button(action: {
                        // TODO: ライフ処理
                        HomeController().onTapStart(gamenum: account.loginUser.gameNum, rate: account.loginUser.gameRate, jorker: account.loginUser.gameJorker)
                        SoundMng.shared.playSound(soundName: SoundName.SE.btn_positive.rawValue)
                    }) {
                        Btnwb(btnText: "Start", btnTextSize: 30, btnWidth: 200, btnHeight: 50)
                    }
                    .position(x: Constants.scrWidth / 2, y:  Constants.scrHeight * 0.80)

                } else {
                    Button(action: {
                        // TODO: ライフ処理
                        Router().pushBasePage(pageId: .room)
                        SoundMng.shared.playSound(soundName: SoundName.SE.btn_positive.rawValue)
                    }) {
                        Btnwb(btnText: "Next", btnTextSize: 30, btnWidth: 200, btnHeight: 50)
                    }
                    .position(x: Constants.scrWidth / 2, y:  Constants.scrHeight * 0.80)
                }
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
    let nowItem: String
    
    var body: some View {
        HStack(spacing: 0) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Constants.scrWidth / 12, height: Constants.scrWidth / 12)
                .padding(5)
            
            Spacer()
            
            VStack(spacing: 5) {
                Text(text)
                    .font(.custom(FontName.font01, size: 15))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(nowItem)
                    .font(.custom(FontName.font01, size: 15))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding(10)
    }
}

// 項目Modifire
struct settingUnitModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(5)
            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 10, y: 10)
            .frame(width: Constants.scrWidth * 0.40, height: Constants.scrHeight / 9)
            .background(Color.plusDarkGreen)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)
    }
}

// 未実装のもの
struct untilSettingUnitView: View {
    let imageName: String
    let text: String
    let nowItem: String
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Constants.scrWidth / 12, height: Constants.scrWidth / 12)
                    .padding(5)
                
                Spacer()
                
                VStack(spacing: 5) {
                    Text(text)
                        .font(.custom(FontName.font01, size: 15))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(nowItem)
                        .font(.custom(FontName.font01, size: 15))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                Spacer()
            }
            
            Text("ComingSoon")
                .font(.custom(FontName.font01, size: 15))
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .rotationEffect(.degrees(20)) // テキストを斜めにする
            
        }
        .padding(10)
    }
}

struct untilSettingUnitModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(5)
            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 10, y: 10)
            .frame(width: Constants.scrWidth * 0.40, height: Constants.scrHeight / 9)
            .background(Color.gray)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)
            .disabled(true)
    }
}

