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
                    VStack(spacing: 50) {
                                                
                        Text("Room Name: \(room.roomData.roomName)")
                            .font(.system(size: 20))
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .bold()
                        
//                        Text("Creator: \(room.roomData)")
//                            .font(.system(size: 20))
//                            .foregroundColor(Color.white)
//                            .fontWeight(.bold)
//                            .bold()
                        
                        // errore
                        Text("\(room.error_message)")
                            .font(.system(size: 20))
                            .foregroundColor(Color.red)
                            .fontWeight(.bold)
                            .bold()
                        
                        HStack(spacing: 40) {
                            Button(action: {
                                RoomController().onCloseMenu()
                            }) {
                                Text("CANSEL")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                    .bold()
                                    .padding()
                                    .frame(width: 120, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 3)
                                    )
                            }
                            
                            Button(action: {
                                // 参加処理
                                room.join(user: appState.account.loginUser)
                            }) {
                                Text("JOIN")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                    .bold()
                                    .padding()
                                    .frame(width: 120, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 3)
                                    )
                            }
                        }
                    }
                    .frame(width: 350, height: 500)
                    .background(
                        Color.black.opacity(0.90)
                    )
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 3)
                    )
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
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
