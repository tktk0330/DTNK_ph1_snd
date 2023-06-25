
import SwiftUI

struct IconView: View {
    
    let player: Player
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width:150, height: 60)

            
            HStack{
                Image(player.icon_url)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                
                
                VStack{
                    Text(player.name)
                    Text("\(player.score >= 0 ? "+" : "")\(player.score)p")
                }
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)

            }
        }
        .scaledToFit()
        .scaleEffect(0.75)

    }
}

struct BotIconView: View {

    
    let player: Player
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color.white.opacity(0.3))
                .shadow(color: .gray, radius: 10, x: 0, y: 5)
                .frame(width:70, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            
            VStack(spacing: 0){
                
                Text("\(player.score)p")
                    .minimumScaleFactor(0.1)
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .frame(width: 70)

                Image(player.icon_url)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                
                
//                VStack{
                    Text(player.name)
                    .minimumScaleFactor(0.01)
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .frame(width: 70)


//                }
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 80)

            }
        }
        .scaledToFit()
        .scaleEffect(0.75)

    }}


