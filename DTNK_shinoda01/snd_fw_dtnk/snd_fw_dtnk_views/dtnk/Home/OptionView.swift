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
        VStack {
            
            // 広告用
            Rectangle()
                .foregroundColor(Color.white.opacity(0.3))
                .frame(maxWidth: .infinity, maxHeight: 50)
                
            
            Rectangle()
                            .foregroundColor(Color.clear)
                            .frame(height: 20)
            
            HStack {
                Button(action: {
                    Router().setBasePages(stack: [.home])
                }) {
                    Image(ImageName.Common.back.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                }
                
                Divider().background(Color.clear).frame(height: 20) // nポイントの透明な線を挿入
                
                Text("      Option         ")
                    .font(.custom(FontName.font01,size: 30))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                
               
            }
            
            Divider().background(Color.clear).frame(height: 20) // nポイントの透明な線を挿入
            
            
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
                            .frame(height: 50)
            
            ZStack{
                Rectangle()
                                .foregroundColor(Color.casinolightgreen) // バーの色を設定
                                .frame(height: 350) // バーの高さを指定
                                .edgesIgnoringSafeArea(.top) // バーがセーフエリアの上に表示されるようにする
                
                VStack{
                Button(action: {
                    button1Colored.toggle()
                }) {
                    Text("♪ SE")
                        .frame(width: 300, height: 50)
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
                
                
                    Rectangle()
                                    .foregroundColor(Color.casinolightgreen)
                                    .frame(height: 10)
                
                Button(action: {
                    button2Colored.toggle()
                }) {
                    Text("📢 BGM")
                        .frame(width: 300, height: 50)
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
                
                    Rectangle()
                                    .foregroundColor(Color.casinolightgreen)
                                    .frame(height: 10)
                
                Button(action: {
                    button3Colored.toggle()
                }) {
                    Text("📱 振動")
                        .frame(width: 300, height: 50)
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

/*
import UIKit

class OptionView: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タップジェスチャーを四角形に追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(squareTapped))
        squareView.addGestureRecognizer(tapGesture)
    }
    
    @IBOutlet weak var squareView: UIView! // 四角形のUIView
    
    @objc func squareTapped() {
        performSegue(withIdentifier: "toInputNameVC", sender: nil)
    }
}

class InputNameViewController: UIViewController {
    @IBOutlet weak var playerNameTextField: UITextField!
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        if let playerName = playerNameTextField.text {
            performSegue(withIdentifier: "toNextVC", sender: playerName)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNextVC" {
            if let nextVC = segue.destination as? NextViewController,
               let playerName = sender as? String {
                nextVC.playerName = playerName
            }
        }
    }
}

class NextViewController: UIViewController {
    var playerName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let playerName = playerName {
            // playerNameを使用して画面に表示する処理を追加
        }
    }
}
*/

