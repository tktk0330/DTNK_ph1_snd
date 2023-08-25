//
//  OptionView.swift
//  Dtnk-ver002
//
//  Created by Takuma Shinoda on 2023/06/12.
//



import SwiftUI

extension Color{
    static let pushcolor = Color(red: 194/255, green: 194/255, blue: 194/255)
    static let casinolightgreen = Color(red: 195/255, green: 242/255, blue: 203/255)
}

struct OptionView: View {
    @State private var button1Colored = false
    @State private var button2Colored = false
    @State private var button3Colored = false
    @State private var text: String = ""
    
    var body: some View {
        
        GeometryReader { geo in
            VStack {
                
                // 広告用
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                
                
                VStack {
                    Button(action: {
                        Router().setBasePages(stack: [.home])
                    }) {
                        Image(ImageName.Common.back.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40)
                    }
                    .position(x: UIScreen.main.bounds.width * 0.10, y:  geo.size.height * 0.01)
                    
                    
                    Text("Option")
                        .font(.custom(FontName.font01, size: 45))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                        .padding(5)
                        .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.01)
                    
                    
                }
                
                Rectangle()
                    .foregroundColor(Color.clear)
                    .frame(height: 100)
                
                
                HStack{
                    Text("^_^   ")
                        .foregroundColor(Color.white)
                    
                    TextField("User Name", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(5)
                        .frame(width: 300)
                    
                }
                Rectangle()
                    .foregroundColor(Color.clear)
                    .frame(height: 30)
                
                ZStack{
                    Rectangle()
                        .foregroundColor(Color.casinolightgreen) // バーの色を設定
                        .frame(height: 410) // バーの高さを指定
                        .edgesIgnoringSafeArea(.top) // バーがセーフエリアの上に表示されるようにする
                    
                    VStack{
                        ZStack{
                            
                            //影
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.black.opacity(0.25))
                                .frame(width: 335, height: 95)
                                .offset(x: 5, y: 10)
                            
                            //ボタン
                            Button(action: {
                                button1Colored.toggle()
                            }) {
                                Text("♪ SE")
                                    .frame(width: 300, height: 60)
                                    .padding()
                                    .background(button1Colored ? Color.pushcolor : Color.casinoGreen)
                                    .foregroundColor(button1Colored ? Color.black : Color.white)
                                    .border(Color.clear, width: 2)
                                    .font(.custom(FontName.font01,size: 30))
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.clear, lineWidth: 2)
                                    )
                                
                            }
                        }
                            Rectangle()
                                .foregroundColor(Color.clear)
                                .frame(height: 15)
                            
                        ZStack{
                            
                            //影
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.black.opacity(0.25))
                                .frame(width: 335, height: 95)
                                .offset(x: 5, y: 10)
                            
                            //ボタン
                            Button(action: {
                                button2Colored.toggle()
                            }) {
                                Text("📢 BGM")
                                    .frame(width: 300, height: 60)
                                    .padding()
                                    .background(button2Colored ? Color.pushcolor : Color.casinoGreen)
                                    .foregroundColor(button2Colored ? Color.black : Color.white)
                                    .border(Color.clear, width: 2)
                                    .font(.custom(FontName.font01,size: 30))
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.clear, lineWidth: 2)
                                    )
                                
                            }
                        }
                        
                            Rectangle()
                                .foregroundColor(Color.clear)
                                .frame(height: 15)
                            
                        ZStack{
                            
                            //影
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.black.opacity(0.25))
                                .frame(width: 335, height: 95)
                                .offset(x: 5, y: 10)
                            
                            //ボタン
                            Button(action: {
                                button3Colored.toggle()
                            }) {
                                Text("📱 Vibration")
                                    .frame(width: 300, height: 60)
                                    .padding()
                                    .background(button3Colored ? Color.pushcolor : Color.casinoGreen)
                                    .foregroundColor(button3Colored ? Color.black : Color.white)
                                    .border(Color.clear, width: 2)
                                    .font(.custom(FontName.font01,size: 30))
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.clear, lineWidth: 2)
                                    )
                                
                            }
                        }
                        }
                    }
                }
            }
        }
    }

