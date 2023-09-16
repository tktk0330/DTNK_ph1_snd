/**
 ライフ画面
 */


import SwiftUI

struct LifeView: View {
    
    @StateObject var account: AccountState = appState.account
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func timeString(from seconds: Int) -> String {
        let minutesPart: Int = seconds / 60
        let secondsPart: Int = seconds % 60
        return String(format: "%02d:%02d", minutesPart, secondsPart)
    }

    var body: some View {
        
        VStack() {
            
            Text("\(timeString(from: appState.account.loginUser.lifeTime))")
                .font(.custom(FontName.font01, size: 15))
                .foregroundColor(Color.white)
                .onReceive(timer) { _ in
                    HomeController().lifeCoundDown()
                }
            
            HStack(spacing: 10) {
                HStack() {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: "heart.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(index < account.loginUser.life ? .red : .gray)
                    }
                }
                
                Button(action: {
                    log("ハートの購入：　現在はライフを一個消費させます")
                    HomeController().useLife() { result in }
                }) {
                    Image(ImageName.Home.healbox.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
            }
        }
    }
    
}
