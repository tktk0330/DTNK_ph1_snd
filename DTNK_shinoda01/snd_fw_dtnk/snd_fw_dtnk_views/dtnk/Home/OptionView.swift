/**
 Option画面
 */

import SwiftUI

struct OptionView: View {
    @State private var button1Colored = false
    @State private var button2Colored = false
    @State private var button3Colored = false
    @State private var text: String = ""
    
    @StateObject var home: HomeState = appState.home

    
    var body: some View {
        GeometryReader { geo in
            ZStack {
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
                Text("Option")
                    .font(.custom(FontName.font01, size: 45))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.15)
                
                
                VStack(spacing: 15) {
                    
                    Button(action: {
                        home.mode = .edittingIcon
                    }) {
                        Image(appState.account.loginUser.iconURL)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
                    }
                    
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
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.28)
                
            }
            
            ZStack{
                Rectangle()
                    .foregroundColor(Color.casinolightgreen) // バーの色を設定
                    .frame(height: 410) // バーの高さを指定
                    .edgesIgnoringSafeArea(.top) // バーがセーフエリアの上に表示されるようにする
                
                VStack(spacing: 30) {

                    Button(action: {
                        button1Colored.toggle()
                    }) {
                        Text("♪ SE")
                            .modifier(optionUnitModifier(color: button1Colored))
                    }
                    
                    Button(action: {
                        button2Colored.toggle()
                    }) {
                        Text("📢 BGM")
                            .modifier(optionUnitModifier(color: button2Colored))
                    }
                    
                    Button(action: {
                        button3Colored.toggle()
                    }) {
                        Text("📱 Vibration")
                            .modifier(optionUnitModifier(color: button3Colored))
                    }
                }
            }
            .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.65)
            
            // アイコン変更
            if home.mode == .edittingIcon {
                IconSelectView()
            }
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
            .foregroundColor(color ? Color.black : Color.white)
            .border(Color.clear, width: 2)
            .font(.custom(FontName.font01,size: 30))
            .cornerRadius(20)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(color ? Color.pushcolor : Color.casinoGreen)
                    .shadow(color: Color.casinoShadow, radius: 1, x: 5, y: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.clear, lineWidth: 2)
            )
    }
}
