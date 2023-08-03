/**
 カスタムフォント使い方　.font(.custom(FontName.font01, size: 45))
 */

import SwiftUI


struct sample01: View {

@State private var isPressed = false

var body: some View {
    Button(action: {
        self.isPressed.toggle()
    }) {
        Text("Press Me")
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding(40)
            .background(
                ZStack {
                    Circle()
                        .fill(isPressed ? Color.red : Color.blue)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                    Circle()
                        .stroke(Color.gray, lineWidth: 4)
                        .blur(radius: 2)
                        .offset(x: 2, y: 2)
                        .mask(Circle().fill(LinearGradient(gradient: Gradient(colors: [Color.black, Color.clear]), startPoint: .bottom, endPoint: .top)))
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .blur(radius: 2)
                        .offset(x: -2, y: -2)
                        .mask(Circle().fill(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .top, endPoint: .bottom)))
                }
            )
    }
    .animation(.easeInOut)
}
}


// 浮いてる感じのボタン
struct ShadowButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { proxy in
            configuration.label
                .foregroundColor(Color.white)
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 8)
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

struct Btnaction: View {
    var btnText: String
    var btnTextSize: CGFloat
    var btnWidth: CGFloat
    var btnHeight: CGFloat
    var btnColor: Color
    
    var body: some View {
        
        Text(btnText)
            .font(.custom(FontName.font01, size: btnTextSize))
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

struct Btnlgb: View {
    var imageName: String
    var btnText: String
    var btnTextSize: CGFloat
    var btnWidth: CGFloat
    var btnHeight: CGFloat
    
    var body: some View {
        
        HStack (spacing: 20) {
            Image(imageName)
            
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

