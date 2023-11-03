/**
 
 GifView(gifName: GifName.Game.burtst.rawValue)

 */

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

struct GifViewCloser: UIViewRepresentable {
    
    let gifName: String
    let onFinishedPlaying: () -> Void
    
    func makeUIView(context: Context) -> UIImageView {
        let gifImageView = UIImageView()
        do {
            let gif = try UIImage(gifName: gifName)
            gifImageView.setGifImage(gif, loopCount: 1)
            gifImageView.delegate = context.coordinator
        } catch {
            print(error)
        }
        return gifImageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onFinishedPlaying: onFinishedPlaying)
    }
    
    class Coordinator: NSObject, SwiftyGifDelegate {
        
        let onFinishedPlaying: () -> Void
        
        init(onFinishedPlaying: @escaping () -> Void) {
            self.onFinishedPlaying = onFinishedPlaying
        }
        
        func gifDidStop(sender: UIImageView) {
            onFinishedPlaying() // GIFが終了したらクロージャーを呼び出す
        }
    }
}
