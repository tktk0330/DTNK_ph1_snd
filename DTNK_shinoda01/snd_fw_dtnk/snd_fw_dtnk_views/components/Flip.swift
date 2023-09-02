/**
 
 */

import SwiftUI


struct Flip<Front: View, Back: View>: View {
    /// 0..<360
    let degree: Double
    let front: Front
    let back: Back

    init(degree: Double,
         front: Front,
         back: Back) {
        self.degree = degree
        self.front = front
        self.back = back
    }

    var body: some View {
        ZStack {
            if (degree < 90) || (270 < degree) {
                front
            } else {
                back
            }
        }
    }
}


struct FlipView: View {
    
    let text: String
    
    @State private var isFront = false
    var body: some View {
        VStack{
            Button(action: {
                isFront.toggle()
            }, label: {
                Text("Flip Card")
            })
            
            Flip_01(isFront: isFront,
                 front: {
                Image(text)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60)
                    .transition(.scale(scale: 1))
            },
                 back: {
                Image("back-1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60)
                    .transition(.scale(scale: 1))
            })
        }
    }
}


struct Flip_01<Front: View, Back: View>: View {
    var isFront: Bool
    @State var canShowFrontView: Bool
    let duration: Double
    let front: () -> Front
    let back: () -> Back
    
    init(isFront: Bool,
         duration: Double = 1.0,
         @ViewBuilder front: @escaping () -> Front,
         @ViewBuilder back: @escaping () -> Back) {
        self.isFront = isFront
        self._canShowFrontView = State(initialValue: isFront)
        self.duration = duration
        self.front = front
        self.back = back
    }
    
    var body: some View {
        ZStack {
            if self.canShowFrontView {
                front()
            }
            else {
                back()
                    .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
            }
        }
        .onChange(of: isFront) { value in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration/2.0) {
                self.canShowFrontView = value
            }
        }
        .rotation3DEffect(
            isFront ? Angle(degrees: 0) : Angle(degrees: 180),
            axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)),
            anchor: .center,
            perspective: 0.1
        )
        .animation(.easeInOut(duration: duration), value: isFront)
    }
}
