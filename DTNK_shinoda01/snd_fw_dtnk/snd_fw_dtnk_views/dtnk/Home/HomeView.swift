/**
 Home
 
 アカウント編集
 ゲーム選択
 ルール選択
 その他Info share

 */

import SwiftUI
import RealmSwift

struct HomeView: View {
    
    @StateObject var home: HomeState = appState.home
    @StateObject var account: AccountState = appState.account

    var body: some View {
        GeometryReader { geo in
            ZStack{
                // 広告用
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                
                // Account
                AccountView()
                    .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.15)
                       
                // Life
                HStack(spacing: 10) {
                    HStack {
                        ForEach(0..<5, id: \.self) { index in
                            Image(systemName: "heart.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(index < account.loginUser.life ? .red : .gray)
                        }
                    }
                    
                    Button(action: {
                        print("ハートの購入")

                        if let realm = try? Realm(), let user = realm.objects(RealmUser.self).first {
                            let manager = LifeManager(user: user)
                            if manager.consumeLifeForGame() {
                                print("\(appState.account.loginUser.life)")
                                // ゲームを開始
                                
                            } else {
                                // ライフが足りない場合のアラート
                                print("x")
                            }
                        }
                    }) {
                        Image(ImageName.Home.healbox.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.30)
                
                // Game List
                VStack (spacing: 40){
                    Button(action: {
                        HomeController().onTapPlay()
                    }) {
                        Btnlgb(imageName: ImageName.Home.vsbots.rawValue, btnText: "ひとりでDOTENKO", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.90, btnHeight: 120)
                    }
                    
                    Button(action: {
                        Router().pushBasePage(pageId: .room)
                    }) {
                        Btnlgb(imageName:  ImageName.Home.vsfriends.rawValue, btnText: "みんなでDOTENKO", btnTextSize: 25, btnWidth:  UIScreen.main.bounds.width * 0.90, btnHeight: 120)
                    }

                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.58)

                // Info List
                HStack(spacing: 20) {
                    Button(action: {
                        HomeController().onTapPageBtn(page: .rule)
                    }) {
                        Btnwb(btnText: "Rule", btnTextSize: 15, btnWidth: 100, btnHeight: 40)
                    }
                    Button(action: {
                        HomeController().onTapPageBtn(page: .option)
                    }) {
                        Btnwb(btnText: "Option", btnTextSize: 15, btnWidth: 100, btnHeight: 40)
                    }
                    Button(action: {
                        HomeController().onTapPageBtn(page: .shop)
                    }) {
                        Btnwb(btnText: "Shop", btnTextSize: 15, btnWidth: 100, btnHeight: 40)
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y:  geo.size.height * 0.90)
            }
        }
    }
}
