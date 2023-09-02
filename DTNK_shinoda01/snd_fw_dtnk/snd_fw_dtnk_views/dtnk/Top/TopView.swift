


import SwiftUI

struct TopView: View {
    var body: some View {
        GeometryReader { geo in
            // 広告用
            Rectangle()
                .foregroundColor(Color.white.opacity(0.3))
                .shadow(color: .gray, radius: 10, x: 0, y: 5)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)

            Text("DOTENKO")
                .font(.custom(FontName.font01, size: UIScreen.main.bounds.width * 0.15))
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .padding(5)
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.20)

            Image(ImageName.Top.topicon.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300)
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.50)

            Button(action: {
                // Home画面へ
                TopController().onTapPlay()
                print(UIScreen.main.bounds.width)
                print(UIScreen.main.bounds.height)
            }) {
                Btnwb(btnText: "Tap", btnTextSize: 30, btnWidth: 200, btnHeight: 50)
            }
            .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.80)
            .blinkEffect(animating: true)
        }
    }
}
