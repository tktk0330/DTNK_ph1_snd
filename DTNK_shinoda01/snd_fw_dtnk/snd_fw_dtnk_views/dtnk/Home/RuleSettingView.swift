
import SwiftUI

struct RuleSettingView: View {
   
        let gamenum = [1, 2, 3, 5, 10]
        @State private var selec_1=4

        let gamerate = [1, 2, 5, 10, 50, 100]
        @State private var selec_2=3
    
        let gamejorker = [0, 2, 4]
        @State private var selec_3=2
    
    //@ObservedObject var gameSettings: GameSettingsModel

    
    // TODO: その他要素
    
    var body: some View {
        GeometryReader { geo in
            
                        // 裏
                        ZStack{
                            // 表
                            ZStack{
                                VStack(spacing: 70){
                                    VStack{
                                        if (appState.home.ruleSet == 1){
                                            HStack() {
                                                Text("GAME")
                                                    .font(.system(size: 25))
                                                    .foregroundColor(Color.white)
                                                    .fontWeight(.bold)
                                                    .bold()
                                                    .padding(3)
                                                    .frame(width: 100)
                                                
                                                Picker(selection: $selec_1, label: Text("")) {
                                                    ForEach(gamenum.indices, id: \.self) { index in
                                                        Text(String(gamenum[index]))
                                                    }
                                                }
                                                .pickerStyle(SegmentedPickerStyle())
                                                .frame(width: 200)
                                                
                                            }}
                                        if (appState.home.ruleSet == 3){
                                            HStack() {
                                                Text("RATE")
                                                    .font(.system(size: 25))
                                                    .foregroundColor(Color.white)
                                                    .fontWeight(.bold)
                                                    .bold()
                                                    .padding(3)
                                                    .frame(width: 100)
                                                
                                                
                                                Picker(selection: $selec_2, label: Text("")) {
                                                    ForEach(gamerate.indices, id: \.self) { index in
                                                        Text(String(gamerate[index]))
                                                    }
                                                }
                                                .pickerStyle(SegmentedPickerStyle())
                                                .frame(width: 200)
                                                
                                            }}
                                        if (appState.home.ruleSet == 2){
                                            HStack() {
                                                Text("JOKER")
                                                    .font(.system(size: 25))
                                                    .foregroundColor(Color.white)
                                                    .fontWeight(.bold)
                                                    .bold()
                                                    .padding(3)
                                                    .frame(width: 100)
                                                
                                                Picker(selection: $selec_3, label: Text("")) {
                                                    ForEach(gamejorker.indices, id: \.self) { index in
                                                        Text(String(gamejorker[index]))
                                                    }
                                                }
                                                .pickerStyle(SegmentedPickerStyle())
                                                .frame(width: 200)
                                                
                                            }
                                        }
                                        if (appState.home.ruleSet == 4){
                                            HStack() {
                                                Text("MAX")
                                                    .font(.system(size: 25))
                                                    .foregroundColor(Color.white)
                                                    .fontWeight(.bold)
                                                    .bold()
                                                    .padding(3)
                                                    .frame(width: 100)
                                                
//                                                Picker(selection: $selec_3, label: Text("")) {
//                                                    ForEach(gamejorker.indices, id: \.self) { index in
//                                                        Text(String(gamejorker[index]))
//                                                    }
//                                                }
//                                                .pickerStyle(SegmentedPickerStyle())
//                                                .frame(width: 200)
                                                
                                            }
                                        }
                                        if (appState.home.ruleSet == 5){
                                            HStack() {
                                                Text("KASANE")
                                                    .font(.system(size: 25))
                                                    .foregroundColor(Color.white)
                                                    .fontWeight(.bold)
                                                    .bold()
                                                    .padding(3)
                                                    .frame(width: 100)
                                                
//                                                Picker(selection: $selec_3, label: Text("")) {
//                                                    ForEach(gamejorker.indices, id: \.self) { index in
//                                                        Text(String(gamejorker[index]))
//                                                    }
//                                                }
//                                                .pickerStyle(SegmentedPickerStyle())
//                                                .frame(width: 200)
                                                
                                            }
                                        }
                                        if (appState.home.ruleSet == 6){
                                            HStack() {
                                                Text("CYCLE")
                                                    .font(.system(size: 25))
                                                    .foregroundColor(Color.white)
                                                    .fontWeight(.bold)
                                                    .bold()
                                                    .padding(3)
                                                    .frame(width: 100)
                                                
//                                                Picker(selection: $selec_3, label: Text("")) {
//                                                    ForEach(gamejorker.indices, id: \.self) { index in
//                                                        Text(String(gamejorker[index]))
//                                                    }
//                                                }
//                                                .pickerStyle(SegmentedPickerStyle())
//                                                .frame(width: 200)
                                                
                                            }
                                        }
                                    }
            
                                    Button(action: {
                                                    // 選択された値をGameSettingsModelに格納
//                                        gameSettings.selectedGameNumber = gamenum[selec_1]
//                                        gameSettings.selectedRate = gamerate[selec_2]
//                                        gameSettings.selectedJorker = gamejorker[selec_3]
                                        
                                        Router().pushBasePage(pageId: .gameSet)
                                    }) {
                                        Text("BUCK")
                                            .font(.system(size: 25))
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                            .bold()
                                            .padding(3)
                                            .frame(width: 150, height: 50)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.white, lineWidth: 3)
                                            )
                                    }
            
                                }
            
                            }
                            .frame(width: 350, height: 500)
                            .background(
                               Color.black.opacity(0.90)
                            )
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 3)
                            )
                        }
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    }
                    .background(
                    Color.clear
                        .onTapGesture {
                            Router().pushBasePage(pageId: .gameSet)
                        }
                )
                    .edgesIgnoringSafeArea(.all)
                }
            }

            
 

//extension Color {
//    static let yellowGreen = Color(red: 210 / 255.0, green: 255 / 255.0, blue: 210 / 255.0) // RGB値で色を定義
//}
