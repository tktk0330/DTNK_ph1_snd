


import SwiftUI
import SwiftyGif

struct GifView: UIViewRepresentable {
    let gifName: String
    
    func makeUIView(context: Context) -> UIImageView {
        let gifImageView = UIImageView()
        do {
            let gif = try UIImage(gifName: gifName)
            gifImageView.setGifImage(gif)
        } catch {
            print(error)
        }
        return gifImageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {}
}
