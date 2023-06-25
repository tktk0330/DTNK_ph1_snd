//
//  GameRuleView.swift
//  Dtnk-ver002
//
//  Created by Takuma Shinoda on 2023/06/12.
//

import SwiftUI

struct GameRuleView: View {
    var body: some View {
        ZStack{
            
            Color.plusDarkGreen
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            ScrollView {
                VStack {
                    Text("ルールの記載")
                        .font(.system(size: 20))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                    
                    
                    Button(action: {
                        HomeController().onTapBack()
                    }) {
                        Text("BACK")
                            .font(.system(size: 25))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .bold()
                            .padding()
                            .frame(width: 170, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.yellow, lineWidth: 3)
                            )
                    }
                }
            }
        }
    }
}

