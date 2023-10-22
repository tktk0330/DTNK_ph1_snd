


import SwiftUI

struct TopView: View {
    var body: some View {
        GeometryReader { geo in

            Text("DOTENKO")
                .font(.custom(FontName.font01, size: Constants.scrWidth * 0.15))
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .padding(5)
                .position(x: Constants.scrWidth / 2, y:  geo.size.height * 0.20)

            Image(ImageName.Top.topicon.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300)
                .position(x: Constants.scrWidth / 2, y:  geo.size.height * 0.50)

            Button(action: {
                // Home画面へ
                TopController().onTapPlay()
            }) {
                Btnwb(btnText: "Tap", btnTextSize: 30, btnWidth: 200, btnHeight: 50)
            }
            .buttonStyle(PressBtn())
            .position(x: Constants.scrWidth / 2, y:  geo.size.height * 0.80)
            .blinkEffect(animating: true)
        }
    }
}
