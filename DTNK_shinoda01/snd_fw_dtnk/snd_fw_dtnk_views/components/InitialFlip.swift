/**
出せる人がいなかった時にランダムで決めるView
 
 */

import SwiftUI

/**
 ランダムフリップView
 
 InitialPlayer
 Player name
 
 */
struct InitialFlip: View {

    let player: [Player]
    let initialIndex: Int

    @State private var timer: Timer?
    @State var index: Int = 0
    @State var count = 0
    let viewModel: InitialFlipViewModel
    
    var remainingPlayers: [Player] {
        var remaining = player
        remaining.remove(at: initialIndex)
        remaining.shuffle()
        remaining.insert(player[initialIndex], at: remaining.count)
        return remaining
    }

    var name: [String] {
        remainingPlayers.map { $0.name }
    }


    init(player: [Player], initialIndex: Int) {
        self.player = player
        self.viewModel = InitialFlipViewModel()
        self.initialIndex = initialIndex
        self.index = initialIndex
        self.viewModel.text = String(name[index])
        
    }


    var body: some View {
        ZStack {
            InitialFlipView(viewModel: viewModel)
                .onAppear {
                    timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                        if count < 11 {
                            count += 1
                            index = (index + 1) % name.count
                            viewModel.text = String(name[index])

                        } else {
                            timer?.invalidate()
                            timer = nil
                        }
                    }
                }
        }
    }
}


enum InitialFlipType {
    case top
    case bottom
    
    var padding: Edge.Set {
        switch self {
        case .top:
            return .bottom
        case .bottom:
            return .top
        }
    }
}

struct InitialFlipPartsView: View {
    
    private let text: String
    private let type: InitialFlipType
    private let size: CGFloat = 100
    
    init(text: String, type: InitialFlipType) {
        self.text = text
        self.type = type
    }
    
    var body: some View {
        ZStack {
//            Color(red: 51/255, green: 51/255, blue: 51/255)
            Color.white
            
            Text(text)
                .font(.system(size: size*2))
                .fontWeight(.heavy)
                .foregroundColor(.plusDarkGreen)
                .minimumScaleFactor(0.01)
                .padding([.leading, .trailing], size*0.1)
        }
        .frame(width: size*3, height: size*1.2)
        .cornerRadius(size*0.1)
        .padding(type.padding, -size*0.6)
        .clipped()
    }
}

struct InitialFlipView: View {
    @ObservedObject var viewModel: InitialFlipViewModel
    
    init(viewModel: InitialFlipViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                InitialFlipPartsView(text: viewModel.newValue ?? "", type: .top)
                InitialFlipPartsView(text: viewModel.oldValue ?? "", type: .top)
                    .rotation3DEffect(.init(degrees: viewModel.animateTop ? -90 : 0),
                                      axis: (1, 0, 0),
                                      anchor: .bottom,
                                      perspective: 0.5)
            }
            // 横棒
            Color.plusDarkGreen
                .frame(width: 300 ,height: 2)
            ZStack {
                InitialFlipPartsView(text: viewModel.oldValue ?? "", type: .bottom)
                InitialFlipPartsView(text: viewModel.newValue ?? "", type: .bottom)
                    .rotation3DEffect(.init(degrees: viewModel.animateBottom ? 0 : 90),
                                      axis: (1, 0, 0),
                                      anchor: .top,
                                      perspective: 0.5)
            }
        }
    }
}

class InitialFlipViewModel: ObservableObject, Identifiable {
    
    private let durarion = 0.3
    
    var text: String? {
        didSet { updateTexts(old: oldValue, new: text) }
    }
    
    @Published var newValue: String?
    @Published var oldValue: String?
    
    @Published var animateTop: Bool = false
    @Published var animateBottom: Bool = false
    
    func updateTexts(old: String?, new: String?) {
        guard old != new else { return }
        oldValue = old
        animateTop = false
        animateBottom = false
        
        withAnimation(Animation.easeIn(duration: durarion)) { [weak self] in
            self?.newValue = new
            self?.animateTop = true
        }
        
        withAnimation(Animation.easeOut(duration: durarion).delay(durarion)) { [weak self] in
            self?.animateBottom = true
        }
    }
}
