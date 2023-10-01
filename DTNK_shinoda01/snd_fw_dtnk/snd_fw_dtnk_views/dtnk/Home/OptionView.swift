/**
 Option画面
 */

import SwiftUI

struct OptionView: View {
    
    @StateObject var home: HomeState = appState.home
    @StateObject var account: AccountState = appState.account
    @State private var text: String = ""
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // admob
                BunnerView(geo: geo)
                // back
                BackButton(backPage: .home, geo: geo, keyboardHeight: keyboardHeight)
                
                // title
                Text("Option")
                    .font(.custom(FontName.font01, size: 45))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.15 + keyboardHeight)
                
                VStack(spacing: 15) {
                    
                    Button(action: {
                        home.mode = .edittingIcon
                        SoundMng.shared.playSound(soundName: SoundName.SE.btn_positive.rawValue)
                    }) {
                        Image(appState.account.loginUser.iconURL)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
                    }
                    .buttonStyle(PressBtn())
                    
                    HStack() {
                        TextField(appState.account.loginUser.name, text: $text)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(5)
                            .frame(width: 250)
                            .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
                        
                        
                        Button(action: {
                            HomeController().updateName(newName: text)
                        }) {
                            Btnaction(btnText: "更新", btnTextSize: 15, btnWidth:  70, btnHeight: 35, btnColor: Color.dtnkLightBlue)
                        }
                        .buttonStyle(PressBtn())
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.28 + keyboardHeight * 2)
            }
            
            ZStack{
                Rectangle()
                    .foregroundColor(Color.casinolightgreen)
                    .frame(height: 410)
                    .edgesIgnoringSafeArea(.top)
                
                VStack(spacing: 30) {

                    Button(action: {
                        account.loginUser.se.toggle()
                        HomeController().updateOption(keyPath: \.se, item: "se", value: account.loginUser.se)
                    }) {
                        optionUnitView(ImageName: ImageName.Option.se.rawValue, optionName: "SE")
                            .modifier(optionUnitModifier(color: account.loginUser.se))
                    }
                    .buttonStyle(PressBtn())
                    
                    Button(action: {
                        account.loginUser.sound.toggle()
                        HomeController().updateOption(keyPath: \.sound, item: "sound", value: account.loginUser.sound)
                    }) {
                        optionUnitView(ImageName: ImageName.Option.sound.rawValue, optionName: "Sound")
                            .modifier(optionUnitModifier(color: account.loginUser.sound))
                    }
                    .buttonStyle(PressBtn())
                    
                    Button(action: {
                        account.loginUser.vibration.toggle()
                        HomeController().updateOption(keyPath: \.vibration, item: "vibration", value: account.loginUser.vibration)
                    }) {
                        optionUnitView(ImageName: ImageName.Option.vibration.rawValue, optionName: "Vibration")
                            .modifier(optionUnitModifier(color: account.loginUser.vibration))
                    }
                    .buttonStyle(PressBtn())

                }
            }
            .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.65 + keyboardHeight * 5)
            
            // アイコン変更
            if home.mode == .edittingIcon {
                IconSelectView()
            }
        }
        .onAppear {
            // キーボード対応
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notif in
                let value = notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let height = value.height
                keyboardHeight = height / 10
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                keyboardHeight = 0
            }
        }
    }
}

// 項目View
struct optionUnitView: View {
    
    let ImageName: String
    let optionName: String
    
    var body: some View {
        HStack() {
            Image(ImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding(.leading, 20)
            Spacer()
            Text(optionName)
            Spacer()
        }
    }
}

// 項目Modifire
struct optionUnitModifier: ViewModifier {
        
    let color: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(width: 300, height: 60)
            .padding()
            .foregroundColor(color ? Color.white : Color.black)
            .border(Color.clear, width: 2)
            .font(.custom(FontName.font01,size: 30))
            .cornerRadius(20)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(color ? Color.casinoGreen : Color.pushcolor)
                    .shadow(color: Color.casinoShadow, radius: 1, x: 5, y: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.clear, lineWidth: 2)
            )
    }
}
