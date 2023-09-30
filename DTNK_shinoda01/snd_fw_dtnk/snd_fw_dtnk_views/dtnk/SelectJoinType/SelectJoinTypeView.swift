


import SwiftUI

struct SelectJoinTypeView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack{
                
                BunnerView(geo: geo)

                // back
                Button(action: {
                    Router().setBasePages(stack: [.home])
                }) {
                    Image(ImageName.Common.back.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                }
                .frame(maxHeight: 40)
                .position(x: UIScreen.main.bounds.width * 0.10, y:  geo.size.height * 0.10)
                

                VStack(spacing: 70) {
                    Button(action: {
                        HomeController().onTapPageBtn(page: .gameSetting)
                        HomeController().selectGameType(gameType: .create)
                    }) {
                        Btnwb(btnText: "ルームを作る", btnTextSize: 30, btnWidth: Constants.scrWidth * 0.8, btnHeight: 60)
                    }
                    .buttonStyle(PressBtn())

                    
                    Button(action: {
                        HomeController().onTapPageBtn(page: .room)
                        HomeController().selectGameType(gameType: .participate)
                    }) {
                        Btnwb(btnText: "ルームに参加する", btnTextSize: 30, btnWidth:  Constants.scrWidth * 0.8, btnHeight: 60)
                    }
                    .buttonStyle(PressBtn())

                }
                .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.60 )
            }
        }
    }
}
