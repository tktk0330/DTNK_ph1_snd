
import SwiftUI


extension Color {
    static let casinoGreen = Color(red: 8/255, green: 82/255, blue: 20/255)
    static let casinoLightGreen = Color(red: 195/255, green: 242/255, blue: 203/255)
    static let dtnkLightRed = Color(red: 255/255, green: 45/255, blue: 85/255)
    static let dtnkLightYellow = Color(red: 255/255, green: 204/255, blue: 0/255)
    static let dtnkLightBlue = Color(red: 88/255, green: 86/255, blue: 214/255)
    static let dtnkBlue = Color(red: 2/255, green: 63/255, blue: 129/255)
    static let dtnkGreen01 = Color(red: 76/255, green: 271/255, blue: 100/255)
    static let casinoShadow = Color(red: 7/255, green: 61/255, blue: 14/255)

}

extension Color {
    static let plusAutoWhite = Color("AutoWhite")
    static let plusAutoBlack = Color("AutoBlack")
    static let plusRed = Color("CandyAppleRed")
    static let plusLightGreen = Color("LightGreen")
    static let plusDarkGreen = Color("DarkGreen")
    static let plusGold = Color("LemonGold")
    static let plusBlack = Color("ChocolateBlack")
    static let plusBlue = Color("BlueBerryBlue")
    static let plusblack = Color("Black")
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init( .sRGB,
                   red: Double((hex >> 16) & 0xff) / 255,
                   green: Double((hex >> 08) & 0xff) / 255,
                   blue: Double((hex >> 00) & 0xff) / 255,
                   opacity: alpha )
    }
}

extension Color {
    func hexString() -> String {
        return UIColor(self).toHexString()
    }
    
    init(hexString: String) {
        let uiColor = UIColor(hex: hexString)!
        self = Color(uiColor: uiColor)
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    func toHexString() -> String {
        var red: CGFloat     = 1.0
        var green: CGFloat   = 1.0
        var blue: CGFloat    = 1.0
        var alpha: CGFloat   = 1.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(String(Int(floor(red*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        let g = Int(String(Int(floor(green*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        let b = Int(String(Int(floor(blue*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        let a = Int(String(Int(floor(alpha*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        
        let result = String(r, radix: 16).padding(to: 2, with: "0")
        + String(g, radix: 16).padding(to: 2, with: "0")
        + String(b, radix: 16).padding(to: 2, with: "0")
        + String(a, radix: 16).padding(to: 2, with: "0")
        
        return result
    }
}

extension UIColor {
    static var UIColorDarkGreen: UIColor {
        return UIColor(Color("DarkGreen"))
    }
}
