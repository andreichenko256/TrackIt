import Combine
import Foundation

final class PremiumManager: ObservableObject {
    static let shared = PremiumManager()
    private let key = "isPremium"

    @Published var isPremium: Bool = UserDefaults.standard.bool(forKey: "isPremium") {
        didSet {
            UserDefaults.standard.set(isPremium, forKey: key)
        }
    }

    private init() {}
}
