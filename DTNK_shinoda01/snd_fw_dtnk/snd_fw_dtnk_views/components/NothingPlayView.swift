/**
 最初に誰も出せなかった時ランダムで決定する
 
 */


import SwiftUI

enum FlipType {
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

struct FlipPartsView: View {
    
    private let text: String
    private let type: FlipType
    private let size: CGFloat = 100
    
    init(text: String, type: FlipType) {
        self.text = text
        self.type = type
    }
    
    var body: some View {
        ZStack {
            Color(red: 51/255, green: 51/255, blue: 51/255)
            
            Text(text)
                .font(.system(size: size*2))
                .fontWeight(.heavy)
                .foregroundColor(.plusDarkGreen)
                .minimumScaleFactor(0.01)
                .padding([.leading, .trailing], size*0.1)
        }
        .frame(width: size, height: size*1.2)
        .cornerRadius(size*0.1)
        .padding(type.padding, -size*0.6)
        .clipped()
    }
}

struct FirstFlipView: View {
    @ObservedObject var viewModel: FlipViewModel
    
    init(viewModel: FlipViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                FlipPartsView(text: viewModel.newValue ?? "", type: .top)
                FlipPartsView(text: viewModel.oldValue ?? "", type: .top)
                    .rotation3DEffect(.init(degrees: viewModel.animateTop ? -90 : 0),
                                      axis: (1, 0, 0),
                                      anchor: .bottom,
                                      perspective: 0.5)
            }
            Color.black
                .frame(height: 2)
            ZStack {
                FlipPartsView(text: viewModel.oldValue ?? "", type: .bottom)
                FlipPartsView(text: viewModel.newValue ?? "", type: .bottom)
                    .rotation3DEffect(.init(degrees: viewModel.animateBottom ? 0 : 90),
                                      axis: (1, 0, 0),
                                      anchor: .top,
                                      perspective: 0.5)
            }
        }
    }
}

class FlipViewModel: ObservableObject, Identifiable {
    
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

struct NothingPlayView: View {
    @State var count = 0
    let viewModel: FlipViewModel
    
    init() {
        self.viewModel = FlipViewModel()
        self.viewModel.text = String(self.count)
    }
    
    var body: some View {
        ZStack {
            FirstFlipView(viewModel: viewModel)
                .onTapGesture {
                    count += 1
                    viewModel.text = String(count)
                }
        }
        .padding(100)
        .background(Color.white)
    }
}
