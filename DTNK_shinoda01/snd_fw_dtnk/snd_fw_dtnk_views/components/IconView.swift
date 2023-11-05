


import SwiftUI

struct IconView: View {
    var iconURL: String
    var size: CGFloat

    @State private var userImage: Image?

    private let imageCache = ImageCache.shared

    var body: some View {
        iconImage
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .aspectRatio(contentMode: .fit) // この行で画像のアスペクト比が保たれます。
            .frame(width: size, height: size)
            .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
            .onAppear {
                if iconURL.starts(with: "https://firebasestorage.googleapis.com") {
                    downloadImage(url: iconURL)
                }
            }
    }

    var iconImage: Image {
        if let cachedImage = imageCache.getImage(forKey: iconURL) {
            return Image(uiImage: cachedImage)
        } else if iconURL.starts(with: "https://firebasestorage.googleapis.com") {
            return userImage ?? Image("")
        } else {
            return Image(iconURL)
        }
    }

    func loadImage(url: String) {
        if let cachedImage = imageCache.getImage(forKey: url) {
            userImage = Image(uiImage: cachedImage)
        } else {
            downloadImage(url: url)
        }
    }

    func downloadImage(url: String) {
        guard let imageURL = URL(string: url) else {
            log("Invalid URL.")
            return
        }

        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                let squareImage = uiImage.croppedToSquare() ?? uiImage
                DispatchQueue.main.async {
                    self.userImage = Image(uiImage: squareImage)
                }
                self.imageCache.saveImage(squareImage, forKey: url)
            } else {
                log("Failed to download image.")
            }
        }.resume()
    }
}

class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()

    func saveImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func removeImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }

}

extension UIImage {
    func croppedToSquare() -> UIImage? {
        let minLength = min(size.width, size.height)
        let offsetX = (size.width - minLength) / 2.0
        let offsetY = (size.height - minLength) / 2.0
        let squareRectangle = CGRect(x: offsetX, y: offsetY, width: minLength, height: minLength)
        
        if let cgImage = cgImage?.cropping(to: squareRectangle) {
            return UIImage(cgImage: cgImage)
        }
        
        return nil
    }
}
