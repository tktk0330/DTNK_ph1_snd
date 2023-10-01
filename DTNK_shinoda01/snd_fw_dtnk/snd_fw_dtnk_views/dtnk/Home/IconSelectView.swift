/**
 IconSelect
 */

import SwiftUI

struct IconSelectView: View {
    
    @State private var hsSpacing: CGFloat = 50
    @State private var iconSize: CGFloat = 70
    @State private var iconURL = appState.account.loginUser.iconURL

    // フォルダから選択
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?

    
    var body: some View {
        GeometryReader { geo in
            // 裏
            ZStack{
                // 表
                ZStack{
                    VStack(spacing: 40) {
                        
                        // NowIcon
                        Image(iconURL)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: iconSize, height: iconSize)
                            .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
                        
                        // 上段
                        HStack(spacing: hsSpacing) {
                            Button(action: {
                                iconURL = ImageName.Icon.bot1.rawValue
                            }) {
                                Image(ImageName.Icon.bot1.rawValue)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: iconSize, height: iconSize)
                                    .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
                            }

                            Button(action: {
                                iconURL = ImageName.Icon.bot2.rawValue
                            }) {
                                Image(ImageName.Icon.bot2.rawValue)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: iconSize, height: iconSize)
                                    .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
                            }

                            Button(action: {
                                iconURL = ImageName.Icon.bot3.rawValue
                            }) {
                                Image(ImageName.Icon.bot3.rawValue)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: iconSize, height: iconSize)
                                    .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
                            }
                        }
                        
                        // 下段
                        HStack(spacing: hsSpacing) {
                            Button(action: {
                                iconURL = ImageName.Icon.bot4.rawValue
                            }) {
                                Image(ImageName.Icon.bot4.rawValue)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: iconSize, height: iconSize)
                                    .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
                            }

                            Button(action: {
                                iconURL = ImageName.Icon.bot5.rawValue
                            }) {
                                Image(ImageName.Icon.bot5.rawValue)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: iconSize, height: iconSize)
                                    .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
                            }

                            Button(action: {
                                
                            }) {
                                Btnaction(btnText: "?", btnTextSize: 15, btnWidth:  70, btnHeight: 70, btnColor: Color.dtnkLightBlue)
                            }

                        }
                                                
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.90, height: geo.size.height * 0.40)
                    .background(
                        Color.black.opacity(0.90)
                    )
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 3)
                    )
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)


                    HStack(spacing: 40) {
                        Button(action: {
                            HomeController().onTapBackMode()
                        }) {
                            Btnwb(btnText: "戻る", btnTextSize: 20, btnWidth: 120, btnHeight: 50)
                        }

                        Button(action: {
                            HomeController().updateIcon(iconURL: iconURL)
                            SoundMng.shared.playSound(soundName: SoundName.SE.btn_positive.rawValue)
                        }) {
                            Btnwb(btnText: "更新", btnTextSize: 20, btnWidth: 120, btnHeight: 50)

                        }
                    }
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.80)
                }
                .background(
                    Color.black.opacity(0.50)
                        .onTapGesture {
                            RoomController().onCloseMenu()
                        }
                )
            }
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
    }
}
