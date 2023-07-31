//
//  ButtonText.swift
//  DTNK_shinoda01
//
//                      .font(.custom(FontName.font01, size: 45))
//

import SwiftUI


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

