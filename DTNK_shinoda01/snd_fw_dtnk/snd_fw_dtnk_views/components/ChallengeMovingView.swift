//
//  ChallengeMovingView.swift
//  DTNK_shinoda01
//
//  Created by Takuma Shinoda on 2023/08/06.
//

import SwiftUI

struct MovingImage: View {
    @State private var offset: CGFloat = 0

    let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(0..<2) { _ in
                    HStack(spacing: 12) {  // Adjust this to set the gap between images
                        ForEach(0..<3) { _ in
                            Image("challenge-2") // Replace with your image name
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .frame(width: geometry.size.width)
                }
            }
            .offset(x: self.offset, y:  geometry.size.height * 0.08)
            .onAppear {
                self.offset = geometry.size.width
            }
            .onReceive(self.timer) { _ in
                self.offset -= 3
                if -self.offset >= geometry.size.width {
                    self.offset = 0 // If the first HStack reaches the left end, reset offset to 0
                }
            }
        }
//        .frame(height: 50) // Adjust the height
    }
}
