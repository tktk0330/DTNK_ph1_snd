


import SwiftUI


struct GameHelpGroupView: View {
    
    var game: GameUIState
    var geo: GeometryProxy
    
    var body: some View {
        if game.gameMode == .option {
            GameHelpView()
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
        }
        if game.gameMode == .rule {
            GameHelpUnitView()
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
        }
        if game.gameMode == .exit {
            GameExitView()
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.5)
        }
    }
}


struct GameHelpView: View {
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    GameMainController().setMode(mode: .base)
                }
            
            VStack(spacing: 40) {
                Button(action: {
                    GameMainController().setMode(mode: .rule)
                }) {
                    Btngo(btnText: "ルールを確認する", btnTextSize: 20, btnWidth: Constants.scrWidth * 0.6, btnHeight: 60)
                }
                
                Button(action: {
                    GameMainController().exitRoom(info: appState.gameUIState.gamevsInfo!)
                }) {
                    Btngo(btnText: "ルームを退出する", btnTextSize: 20, btnWidth: Constants.scrWidth * 0.6, btnHeight: 60)
                }
                
                Button(action: {
                    GameMainController().setMode(mode: .base)
                }) {
                    Btngo(btnText: "ゲームに戻る", btnTextSize: 20, btnWidth: Constants.scrWidth * 0.6, btnHeight: 60)
                }
            }
            .frame(width: Constants.scrWidth * 0.8, height: Constants.scrHeight * 0.45)
            .background(Color.black.opacity(0.85))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.6), lineWidth: 20)
            )
            .cornerRadius(20)
        }
    }
}

struct GameHelpUnitView: View {
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    GameMainController().setMode(mode: .base)
                }
            
            VStack(spacing: 5) {
                
                HStack(spacing: 15) {
                    Button(action: {
                        GameMainController().setMode(mode: .option)
                    }) {
                        Image(ImageName.Common.back.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                    }
                    Text("Rule")
                        .font(.custom(FontName.font01, size: 25))
                        .foregroundColor(Color.white)
                }
                .padding(.top, 30)
                
                VStack(alignment: .leading, spacing: 0) {
                    ScrollView {
                        BorderedListView(content: AnyView(
                            RuleScreen()
                        ))
                    }
                    .scaleEffect(0.755)
                }
            }
            .frame(width: Constants.scrWidth * 0.8, height: Constants.scrHeight * 0.45)
            .background(Color.black.opacity(0.85))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.6), lineWidth: 20)
            )
            .cornerRadius(20)
        }
    }
}

struct GameExitView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 50) {
                Text("ゲームが終了されました")
                    .font(.custom(FontName.MP_EB, size: 20))
                    .foregroundColor(Color.white)
                
                Button(action: {
                    GameMainController().exitRoomParticipate()
                }) {
                    Btngo(btnText: "退出する", btnTextSize: 20, btnWidth: Constants.scrWidth * 0.6, btnHeight: 60)
                }
            }
            .frame(width: Constants.scrWidth * 0.8, height: Constants.scrHeight * 0.45)
            .background(Color.black.opacity(0.85))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.6), lineWidth: 20)
            )
            .cornerRadius(20)
        }
    }
}



struct Btngo: View {
    var btnText: String
    var btnTextSize: CGFloat
    var btnWidth: CGFloat
    var btnHeight: CGFloat
    var btnColor: Color = Color.casinoGreen
    
    var body: some View {
        
        Text(btnText)
            .font(.custom(FontName.MP_EB, size: btnTextSize))
            .foregroundColor(Color.white)
            .fontWeight(.bold)
            .bold()
            .padding()
            .frame(width: btnWidth, height: btnHeight)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(btnColor)
                    .shadow(color: Color.casinoShadow, radius: 1, x: 5, y: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white, lineWidth: 5)
            )
    }
}
