/**
 ルール設定詳細
 */

import SwiftUI

struct GameSettingUnitView: View {
    
    var mode: HomeMode
    
    // TODO: マスタへ
    let gameNum = [1, 2, 3, 5, 10]
    @State private var pickGameNum = appState.account.loginUser.gameNum
    
    let gameJorker = [0, 2, 4]
    @State private var pickGameJorker = appState.account.loginUser.gameJorker
    
    let gameRate = [1, 2, 5, 10, 50, 100]
    @State private var pickGameRate = appState.account.loginUser.gameRate
    
    let gameMaximum = [0, 2, 4]
    @State private var pickGameMaximum = appState.account.loginUser.gameMaximum
    
    let gameUpRate = [0, 3, 4]
    @State private var pickgameUpRate = appState.account.loginUser.gameUpRate
    
    let gameDeckMaximum = [0, 2, 4]
    @State private var pickGameDeckMaximum = appState.account.loginUser.gameDeckMaximum
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                ZStack{
                    VStack() {
                        
                        if mode == .gameNum {
                            
                            VStack(spacing: 30) {
                                CustomPickerView(
                                    title: "ゲーム数",
                                    choices: gameNum,
                                    selectedChoice: $pickGameNum,
                                    updateAction: { newValue in
                                        HomeController().updateGameSetting(keyPath: \.gameNum, item: "gameNum", value: newValue)
                                    }
                                )
                                
                                Text("ゲームを何ターンするか決めます。")
                                    .font(.custom(FontName.font01, size: 15))
                                    .foregroundColor(Color.white)
                            }
                            
                        } else if mode == .joker {
                            
                            CustomPickerView(
                                title: "Joekr",
                                choices: gameJorker,
                                selectedChoice: $pickGameJorker,
                                updateAction: { newValue in
                                    HomeController().updateGameSetting(keyPath: \.gameJorker, item: "gameJorker", value: newValue)
                                }
                            )
                            Text("説明 \(appState.account.loginUser.gameJorker)")
                                .font(.custom(FontName.font01, size: 15))
                                .foregroundColor(Color.white)
                            
                        } else if mode == .rate {
                                                        
                            CustomPickerView(
                                title: "Rate",
                                choices: gameRate,
                                selectedChoice: $pickGameRate,
                                updateAction: { newValue in
                                    HomeController().updateGameSetting(keyPath: \.gameRate, item: "gameRate", value: newValue)
                                }
                            )
                            Text("説明 \(appState.account.loginUser.gameRate)")
                                .font(.custom(FontName.font01, size: 15))
                                .foregroundColor(Color.white)
                            
                        } else if mode == .max {
                            
                            CustomPickerView(
                                title: "max",
                                choices: gameMaximum,
                                selectedChoice: $pickGameMaximum,
                                updateAction: { newValue in
                                    HomeController().updateGameSetting(keyPath: \.gameMaximum, item: "gameMaximum", value: newValue)
                                }
                            )
                            Text("説明 \(appState.account.loginUser.gameMaximum)")
                                .font(.custom(FontName.font01, size: 15))
                                .foregroundColor(Color.white)

                        } else if mode == .uprate {
                            
                            CustomPickerView(
                                title: "UpRate",
                                choices: gameUpRate,
                                selectedChoice: $pickgameUpRate,
                                updateAction: { newValue in
                                    HomeController().updateGameSetting(keyPath: \.gameUpRate, item: "gameUpRate", value: newValue)
                                }
                            )
                            Text("説明 \(appState.account.loginUser.gameUpRate)")
                                .font(.custom(FontName.font01, size: 15))
                                .foregroundColor(Color.white)

                        } else if mode == .deck {
                            
                            CustomPickerView(
                                title: "deck",
                                choices: gameDeckMaximum,
                                selectedChoice: $pickGameDeckMaximum,
                                updateAction: { newValue in
                                    HomeController().updateGameSetting(keyPath: \.gameDeckMaximum, item: "gameDeckMaximum", value: newValue)
                                }
                            )
                            Text("説明 \(appState.account.loginUser.gameDeckMaximum)")
                                .font(.custom(FontName.font01, size: 15))
                                .foregroundColor(Color.white)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.90, height: geo.size.height * 0.35)
                    .background(
                        Color.black.opacity(0.90)
                    )
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 3)
                    )
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    
                    
                    Button(action: {
                        appState.home.mode = .noEditting
                    }) {
                        Btnwb(btnText: "Buck", btnTextSize: 20, btnWidth: 120, btnHeight: 50)
                    }
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.80)
                    
                }
                .background(
                    Color.black.opacity(0.50)
                        .onTapGesture {
                            //
                        }
                )
            }
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
    }
}

// title & picker
struct CustomPickerView: View {
    var title: String
    var choices: [Int]
    @Binding var selectedChoice: Int
    var updateAction: (Int) -> Void

    var body: some View {
        VStack {
            Text(title)
                .font(.custom(FontName.font01, size: 30))
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .padding(20)

            Picker(selection: $selectedChoice, label: Text("")) {
                ForEach(choices, id: \.self) { choice in
                    Text(String(choice))
                        .font(.custom(FontName.font01, size: 5))

                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 200)
            .onReceive([self.selectedChoice].publisher.first()) { newValue in
                updateAction(newValue)
            }
        }
    }
}

