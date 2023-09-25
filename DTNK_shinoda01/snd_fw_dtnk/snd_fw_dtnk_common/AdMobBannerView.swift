//
//  AdMobBannerView.swift
//  DTNK_shinoda01
//
//  Created by Takuma Shinoda on 2023/09/25.
//

import SwiftUI

struct AdMobBannerView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AdTestView: View {
    var geo: GeometryProxy
    var body: some View {
        // 広告用
        Rectangle()
            .foregroundColor(Color.white.opacity(0.3))
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(Color.casinoGreen)
            .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
    }
}

