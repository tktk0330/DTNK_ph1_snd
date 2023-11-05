/**
 ルーム選択画面
 */

import SwiftUI

struct SelectJoinTypeView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack{

                // back
                BackButton(backPage: .home, geo: geo)

                VStack(spacing: 70) {
                    Button(action: {
                        HomeController().onTapPageBtn(page: .gameSetting)
                        HomeController().selectGameType(gameType: .create)
                    }) {
                        Btn_jt_gb(btnText: "ルームを作る", btnTextSize: 30, btnWidth: Constants.scrWidth * 0.8, btnHeight: 60)
                    }
                    .buttonStyle(PressBtn())

                    
                    Button(action: {
                        HomeController().onTapPageBtn(page: .room)
                        HomeController().selectGameType(gameType: .participate)
                    }) {
                        Btn_jt_gb(btnText: "ルームに参加する", btnTextSize: 30, btnWidth:  Constants.scrWidth * 0.8, btnHeight: 60)
                    }
                    .buttonStyle(PressBtn())

                }
                .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.50)
            }
        }
    }
}
