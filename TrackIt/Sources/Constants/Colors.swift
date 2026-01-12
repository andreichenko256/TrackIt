import UIKit

enum Colors {
    static let primary = UIColor(red: 90/255, green: 169/255, blue: 230/255, alpha: 1)
    
    enum Gradients {
        static let primaryBg = [
            UIColor.systemBlue.withAlphaComponent(0.2).cgColor,
            UIColor.white.cgColor
        ]
    }
}
