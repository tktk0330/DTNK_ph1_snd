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
                Text("Rule")
                    .font(.custom(FontName.font01, size: 45))
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
                                print("ゲーム数")
                                // ボタンがタップされた時のアクション
                                
//                                    Picker(selection: $selec_1, label: Text("")) {
//                                        ForEach(gamenum.indices, id: \.self) { index in
//                                            Text(String(gamenum[index]))
//                                        }
//                                    }
//                                    .pickerStyle(SegmentedPickerStyle())
//                                    .frame(width: 200)
                            }) {
                                VStack(spacing: 2) {
                                    Image("number")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geo.size.width / 12, height: geo.size.width / 12) // 画像のサイズを調整
                                    
                                    Text("ゲーム数")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .padding(10)
                            }
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 10, y: 10)
                            .frame(width: geo.size.width / 3, height: geo.size.height / 8) // ボタンのサイズを調整
                            .background(Color.plusDarkGreen)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)
                            

                            Button(action: {
                                // ボタンがタップされた時のアクション
//                                Picker(selection: $selec_3, label: Text("")) {
//                                ForEach(gamejorker.indices, id: \.self) { index in
//                                Text(String(gamejorker[index]))
//                                }
//                                }
//                                .pickerStyle(SegmentedPickerStyle())
                                //.frame(width: 200)
                            }) {
                                VStack(spacing: 2) {
                                    Image("jorker")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geo.size.width / 12, height: geo.size.width / 12) // 画像のサイズを調整
                                    Text("Jorker")
                                        .font(.system(size: 15))
                                        .fontWeight(.black)
                                        .foregroundColor(.white)
                                }
                                .padding(0)
                            }
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 10, y: 10)
                            .frame(width: geo.size.width / 3, height: geo.size.height / 8) // ボタンのサイズを調整
                            .background(Color.plusDarkGreen)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)
                        }
                        
                            HStack(spacing: 40) {
                                Button(action: {
                                    // ボタンがタップされた時のアクション
//                                    Picker(selection: $selec_2, label: Text("")) {
//                                    ForEach(gamerate.indices, id: \.self) { index in
//                                    Text(String(gamerate[index]))
//                                    }
//                                    }
//                                    .pickerStyle(SegmentedPickerStyle())
                                    //.frame(width: 200)
                                    
                                }) {
                                    VStack(spacing: 2) {
                                        Image("rate")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geo.size.width / 12, height: geo.size.width / 12) // 画像のサイズを調整
                                    Text("Rate")
                                        .font(.system(size: 15))
                                        .fontWeight(.black)
                                        .foregroundColor(.white)
                                }
                                .padding(0)
                            }
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 10, y: 10)
                            .frame(width: geo.size.width / 3, height: geo.size.height / 8) // ボタンのサイズを調整
                            .background(Color.plusDarkGreen)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)

                            Button(action: {
                                // ボタンがタップされた時のアクション
                            }) {
                                VStack(spacing: 2) {
                                    Image("max")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geo.size.width / 12, height: geo.size.width / 12) // 画像のサイズを調整
                                    Text("上限")
                                        .font(.system(size: 15))
                                        .fontWeight(.black)
                                        .foregroundColor(.white)
                                        
                                }
                                .padding(0)
                            }
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 10, y: 10)
                            .frame(width: geo.size.width / 3, height: geo.size.height / 8) // ボタンのサイズを調整
                            .background(Color.plusDarkGreen)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)

                        }
                        
                        HStack(spacing: 40) {
                            Button(action: {
                                // ボタンがタップされた時のアクション
                            }) {
                                VStack(spacing: 2) {
                                    Image("uprate")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geo.size.width / 12, height: geo.size.width / 12) // 画像のサイズを調整
                                    Text("重ね")
                                        .font(.system(size: 15))
                                        .fontWeight(.black)
                                        .foregroundColor(.white)
                                        
                                }
                                .padding(0)
                            }
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 10, y: 10)
                            .frame(width: geo.size.width / 3, height: geo.size.height / 8) // ボタンのサイズを調整
                            .background(Color.plusDarkGreen)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)

                            Button(action: {
                                // ボタンがタップされた時のアクション
                            }) {
                                VStack(spacing: 2) {
                                    Image("deck")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geo.size.width / 12, height: geo.size.width / 12) // 画像のサイズを調整
                                    Text("デッキサイクル")
                                        .font(.system(size: 15))
                                        .fontWeight(.black)
                                        .foregroundColor(.white)
                                        
                                }
                                .padding(0)
                            }
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 10, y: 10)
                            .frame(width: geo.size.width / 3, height: geo.size.height / 8) // ボタンのサイズを調整
                            .background(Color.plusDarkGreen)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)
                            
                        }
                    }
                    .padding()
                    .navigationBarTitle("Button Grid")
                    
                
                Button(action: {
                   HomeController().onTapStart(gamenum: gamenum[selec_1], rate: gamerate[selec_2], jorker: gamejorker[selec_3])
                    appState.home.heartsData.heartsCount -= 1
                }) {
                    Btnwb(btnText: "Start", btnTextSize: 30, btnWidth: 200, btnHeight: 50)
                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.875)
                
                
                }
            }
        }
    }

extension Color {
    static let yellowGreen = Color(red: 210 / 255.0, green: 255 / 255.0, blue: 210 / 255.0) // RGB値で色を定義
}
//            // 裏
//            ZStack{
//                // 表
//                ZStack{
//                    VStack(spacing: 70){
//                        VStack{
//                            HStack() {
//                                Text("GAME")
//                                    .font(.system(size: 30))
//                                    .foregroundColor(Color.white)
//                                    .fontWeight(.bold)
//                                    .bold()
//                                    .padding(3)
//                                    .frame(width: 100)
//
//
//                                Picker(selection: $selec_1, label: Text("")) {
//                                    ForEach(gamenum.indices, id: \.self) { index in
//                                        Text(String(gamenum[index]))
//                                    }
//                                }
//                                .pickerStyle(SegmentedPickerStyle())
//                                .frame(width: 200)
//
//                            }
//
//                            HStack() {
//                                Text("RATE")
//                                    .font(.system(size: 30))
//                                    .foregroundColor(Color.white)
//                                    .fontWeight(.bold)
//                                    .bold()
//                                    .padding(3)
//                                    .frame(width: 100)
//
//
//                                Picker(selection: $selec_2, label: Text("")) {
//                                    ForEach(gamerate.indices, id: \.self) { index in
//                                        Text(String(gamerate[index]))
//                                    }
//                                }
//                                .pickerStyle(SegmentedPickerStyle())
//                                .frame(width: 200)
//
//                            }
//
//                            HStack() {
//                                Text("JOKER")
//                                    .font(.system(size: 27))
//                                    .foregroundColor(Color.white)
//                                    .fontWeight(.bold)
//                                    .bold()
//                                    .padding(3)
//                                    .frame(width: 100)
//
//                                Picker(selection: $selec_3, label: Text("")) {
//                                    ForEach(gamejorker.indices, id: \.self) { index in
//                                        Text(String(gamejorker[index]))
//                                    }
//                                }
//                                .pickerStyle(SegmentedPickerStyle())
//                                .frame(width: 200)
//
//                            }
//
//                            HStack() {
//                                Text("MAXIMUM")
//                                    .font(.system(size: 30))
//                                    .foregroundColor(Color.white)
//                                    .fontWeight(.bold)
//                                    .bold()
//                                    .padding(3)
//                            }
//
//                            Text("TEST")
//                                .font(.system(size: 30))
//                                .foregroundColor(Color.white)
//                                .fontWeight(.bold)
//                                .bold()
//                                .padding(3)
//
//                            Text("TEST")
//                                .font(.system(size: 30))
//                                .foregroundColor(Color.white)
//                                .fontWeight(.bold)
//                                .bold()
//                                .padding(3)
//                        }
//
//                        Button(action: {
//                            HomeController().onTapStart(gamenum: gamenum[selec_1], rate: gamerate[selec_2], jorker: gamejorker[selec_3])
//                            appState.home.heartsData.heartsCount -= 1
//                        }) {
//                            Text("START")
//                                .font(.system(size: 30))
//                                .foregroundColor(Color.white)
//                                .fontWeight(.bold)
//                                .bold()
//                                .padding(3)
//                                .frame(width: 150, height: 50)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.white, lineWidth: 3)
//                                )
//                        }
//
//                    }
//
//                }
//                .frame(width: 350, height: 500)
//                .background(
//                    Color.black.opacity(0.90)
//                )
//                .cornerRadius(20)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.white, lineWidth: 3)
//                )
//            }
//            .position(x: geo.size.width / 2, y: geo.size.height / 2)
//
//        }
//        .background(
//            Color.black.opacity(0.50)
//                .onTapGesture {
//                    Router().onCloseMenu()
//                }
//        )
//
//        .edgesIgnoringSafeArea(.all)
//        .frame(maxWidth: .infinity,
//               maxHeight: .infinity)
//    }
//}
