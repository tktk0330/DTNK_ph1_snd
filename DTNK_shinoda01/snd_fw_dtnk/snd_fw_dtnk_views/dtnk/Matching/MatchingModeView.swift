


import SwiftUI

struct RoomExitView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 50) {
                Text("ホストによって\n部屋が削除されました")
                    .font(.custom(FontName.MP_Bo, size: 20))
                    .foregroundColor(Color.white)
                
                Button(action: {
                    // 遷移
                    Router().pushBasePage(pageId: .home)
                    appState.room.roommode = .base
                }) {
                    Btngo(btnText: "退出する", btnTextSize: 20, btnWidth: Constants.scrWidth * 0.6, btnHeight: 60)
                }
            }
            .frame(width: Constants.scrWidth * 0.8, height: Constants.scrHeight * 0.45)
            .background(Color.black.opacity(0.85))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.6), lineWidth: 20)
            )
            .cornerRadius(20)
        }
    }
}
