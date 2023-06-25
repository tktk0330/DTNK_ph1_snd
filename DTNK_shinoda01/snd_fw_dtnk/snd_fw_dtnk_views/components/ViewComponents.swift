/**
 Btnのデザインをまとめる
 
 
 */

import SwiftUI

struct ViewComponents: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct actionBtnView: View {
    
    let text: String
    
    var body: some View {
     
        Text(text)
            .font(.system(size: 25))
            .foregroundColor(Color.white)
            .fontWeight(.bold)
            .bold()
            .padding()
            .frame(width: 100, height: 50)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.yellow, lineWidth: 3)
            )
    }
}

struct initialActionBtnView: View {
    
    let text: String
    
    var body: some View {
     
        Text(text)
            .font(.system(size: 20))
            .foregroundColor(Color.white)
            .fontWeight(.bold)
            .bold()
            .padding()
            .frame(width: 100, height: 100)
            .overlay(
                Circle()
                    .stroke(Color.yellow, lineWidth: 3)
            )
    }
}
