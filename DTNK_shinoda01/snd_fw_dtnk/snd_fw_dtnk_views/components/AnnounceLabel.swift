


import SwiftUI


import SwiftUI

func AnnounceLabel(_ text: String, duration: Double = 0.5, completion: (() -> Void)? = nil) {
    DispatchQueue.main.async {
        let label = UILabel()
        label.text = text
        label.textColor = .UIColorDarkGreen
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 55)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        guard let window = UIApplication.shared.windows.first,
              let windowScene = window.windowScene else {
            return
        }
        
        window.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: window.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 400),
            label.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        label.alpha = 0.0
        label.transform = CGAffineTransform(translationX: -window.frame.width, y: 0)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
            label.alpha = 1.0
            label.transform = .identity
        }, completion: { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
                    label.alpha = 0.0
                    label.transform = CGAffineTransform(translationX: window.frame.width, y: 0)
                }) { (_) in
                    label.removeFromSuperview()
                    completion?() // アニメーション完了後に次のアクションを実行
                }
            }
        })
    }
}
