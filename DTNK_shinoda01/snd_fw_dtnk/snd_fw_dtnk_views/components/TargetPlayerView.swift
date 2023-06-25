//
//  TargetPlayerView.swift
//  Dtnk-ver002
//
//  Created by Takuma Shinoda on 2023/06/20.
//

import SwiftUI

struct TargetPlayerView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack() {
            ForEach(0..<1) { index in
                Circle()
                    .foregroundColor(.yellow)
                    .frame(width: 80, height: 80)
                    .scaleEffect(isAnimating ? 2.0 : 1.0)
                    .opacity(isAnimating ? 0.0 : 1.0)
                    .animation(
                        Animation.linear(duration: 0.7)
                            .delay(Double(index) * 0.07)
                            .repeatForever(autoreverses: false)
                    , value: isAnimating)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

