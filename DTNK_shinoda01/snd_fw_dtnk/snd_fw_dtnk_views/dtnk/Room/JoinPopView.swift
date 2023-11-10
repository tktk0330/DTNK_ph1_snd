/**
 参加可否を問うPOP
 */

import SwiftUI

struct JoinPopView: View {
    
    @StateObject var room: RoomState = appState.room
    
    var body: some View {
        GeometryReader { geo in
            // 裏
            ZStack{
                // 表
                ZStack{
                    VStack(spacing: 40) {
                        Text("見つかりました")
                            .font(.custom(FontName.font01, size: 25))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .bold()
                        
                        Text("Room Name: \(room.roomData.roomName)")
                            .font(.custom(FontName.font01, size: 25))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .bold()
                                                
                        // errore
                        Text("\(room.error_message)")
                            .font(.custom(FontName.font01, size: 25))
                            .foregroundColor(Color.red)
                            .fontWeight(.bold)
                            .bold()
                    }
                    .frame(width: Constants.scrWidth * 0.90, height: geo.size.height * 0.25)
                    .background(Color.black.opacity(0.90))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 3)
                    )
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        
                    HStack(spacing: 40) {
                        Button(action: {
                            room.error_message = ""
                            RoomController().onCloseMenu()
                        }) {
                            Btnwb(btnText: "Cansel", btnTextSize: 20, btnWidth: 120, btnHeight: 50)
                        }
                        
                        Button(action: {
                            room.error_message = ""
                            // 参加処理
                            room.join(user: appState.account.loginUser)
                        }) {
                            Btnwb(btnText: "Join", btnTextSize: 20, btnWidth: 120, btnHeight: 50)
                            
                        }
                    }
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.70)
                }
                .background(
                    Color.black.opacity(0.50)
                        .onTapGesture {
                            hideKeyboard()
                        }
                )
            }
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
