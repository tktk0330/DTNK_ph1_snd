/**
 カスタムフォント使い方　.font(.custom(FontName.font01, size: 45))
 */

import SwiftUI

// 浮いてる感じのボタン
struct ShadowButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { proxy in
            configuration.label
                .foregroundColor(Color.white)
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(gradient:
                                Gradient(colors: [
                                    Color(red: 0.0, green: 0.6, blue: 1.0),
                                    Color(red: 0.0, green: 0.5, blue: 1.0)
                                ]), startPoint: .top, endPoint: .bottom))
                        .shadow(color: Color(.sRGBLinear, white: 0, opacity: configuration.isPressed ? 0.5 : 0.3),
                                radius: configuration.isPressed ? 2 : 10,
                                y: configuration.isPressed ? 1 : 5)
                )
                .contentShape(Rectangle())
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }
    
}

// 浮いてる感じのボタン
struct PressBtn: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.90 : 1.0)
    }
}

struct Btnaction: View {
    var btnText: String
    var btnTextSize: CGFloat
    var btnWidth: CGFloat
    var btnHeight: CGFloat
    var btnColor: Color
    
    var body: some View {
        
        Text(btnText)
            .font(.custom(FontName.MP_EB, size: btnTextSize))
            .fontWeight(.heavy)
            .padding()
            .frame(width: btnWidth, height: btnHeight)
            .foregroundColor(Color.white)
            .background(btnColor)
            .cornerRadius(10)
            .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)

    }
}

struct Btnwb: View {
    var btnText: String
    var btnTextSize: CGFloat
    var btnWidth: CGFloat
    var btnHeight: CGFloat
    var btnColor: Color = Color.casinoGreen
    
    var body: some View {
        
        Text(btnText)
            .font(.custom(FontName.font01, size: btnTextSize))
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

struct Btnwb01: View {
    var btnText: String
    var btnTextSize: CGFloat
    var btnWidth: CGFloat
    var btnHeight: CGFloat
    
    var body: some View {
        
        Text(btnText)
            .font(.custom(FontName.font01, size: btnTextSize))
            .foregroundColor(Color.white)
            .fontWeight(.bold)
            .bold()
            .padding()
            .frame(width: btnWidth, height: btnHeight)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.casinoGreen)
                    .shadow(color: Color.casinoShadow, radius: 1, x: 5, y: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white, lineWidth: 5)
            )
    }
}

// ゲーム種類ボタン
struct Btnlgb: View {
    
    var imageName: String
    var btnText: String
    var btnTextSize: CGFloat
    var btnWidth: CGFloat
    var btnHeight: CGFloat
    var judge: Bool // vsbot vsfriendで画像大きさ変える
    
    
    var body: some View {
        
        HStack (spacing: 20) {
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: judge ? Constants.scrWidth * 0.2 : Constants.scrWidth * 0.3, height: judge ? Constants.scrWidth * 0.2 : Constants.scrWidth * 0.3)

            Text(btnText)
                .font(.custom(FontName.font01, size: btnTextSize))
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .bold()
        }
        .padding()
        .frame(width: btnWidth, height: btnHeight)
        .background(
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.casinoGreen)
                .shadow(color: Color.casinoShadow, radius: 1, x: 10, y: 20)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 100)
                .stroke(Color.casinoLightGreen, lineWidth: 10)
        )
    }
}

