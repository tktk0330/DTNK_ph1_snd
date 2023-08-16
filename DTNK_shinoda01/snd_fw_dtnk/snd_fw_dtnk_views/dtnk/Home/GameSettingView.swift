//
//  GameSettingView.swift
//  Dtnk-ver002
//
//  Created by Takuma Shinoda on 2023/06/16.
//

import SwiftUI

struct GameSettingView: View {
    var heartsController = HeartsRecoverController.shared
    
    let gamenum = [1, 2, 3, 5, 10]
    @State private var selec_1 = 4
    
    let gamerate = [1, 2, 5, 10, 50, 100]
    @State private var selec_2 = 3
    
    let gamejorker = [0, 2, 4]
    @State private var selec_3 = 2
    
    
    // TODO: その他要素
    
    var body: some View {
        GeometryReader { geo in
            // 裏
            ZStack{
                // 表
                ZStack{
                    VStack(spacing: 70){
                        VStack{
                            HStack() {
                                Text("GAME")
                                    .font(.system(size: 30))
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

                            }
                            
                            HStack() {
                                Text("RATE")
                                    .font(.system(size: 30))
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

                            }
                            
                            HStack() {
                                Text("JOKER")
                                    .font(.system(size: 27))
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
                            
                            HStack() {
                                Text("MAXIMUM")
                                    .font(.system(size: 30))
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                    .bold()
                                    .padding(3)
                            }
                            
                            Text("TEST")
                                .font(.system(size: 30))
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .bold()
                                .padding(3)
                            
                            Text("TEST")
                                .font(.system(size: 30))
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .bold()
                                .padding(3)
                        }

                        Button(action: {
                            HomeController().onTapStart(gamenum: gamenum[selec_1], rate: gamerate[selec_2], jorker: gamejorker[selec_3])
                            appState.home.heartsData.heartsCount -= 1
                        }) {
                            Text("START")
                                .font(.system(size: 30))
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
            Color.black.opacity(0.50)
                .onTapGesture {
                    Router().onCloseMenu()
                }
        )

        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
    }
}
