
import SwiftUI


struct ScorePlayerItem: View {
    @StateObject var playerResult: PlayerResultItem
    var body: some View {
        GeometryReader { geo in
            
            HStack(spacing: 10) {
                
                Text(String(playerResult.rank))
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .frame(width: geo.size.width * 0.1)

                
                Image(playerResult.iconUrl)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .frame(width: geo.size.width * 0.1)


                
                Text(playerResult.name)
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .minimumScaleFactor(0.3)
                    .frame(width: geo.size.width * 0.3)


                
                Text(String(playerResult.score))
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .minimumScaleFactor(0.3)
                    .frame(width: geo.size.width * 0.3)

            }
            .position(x: UIScreen.main.bounds.width / 2)

        }
    }
}


struct ScoreItem: View {
    let player: Player
    
    var body: some View {
        GeometryReader { geo in
            
            HStack(spacing: 10) {
                
                Text("X")
                    .font(.system(size: 20))
                    .foregroundColor(Color.white)
                    .frame(width: geo.size.width * 0.1)
                //                    .border(Color.red)
                
                Image(player.icon_url)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                //                    .border(Color.red)
                
                Text(player.name)
                    .font(.system(size: 25))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .frame(width: geo.size.width * 0.6)
                //                    .border(Color.red)
                
                Text(String(player.score))
                    .font(.system(size: 20))
                    .foregroundColor(Color.white)
                    .frame(width: geo.size.width * 0.3)
                //                    .border(Color.red)
                
            }
            .frame(width: geo.size.width)
//            .border(Color.red)
        }
    }
}
