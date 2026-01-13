import UIKit

final class UserDefaultsStorage: UserDefaultsStoring {
    static let shared = UserDefaultsStorage()
    private let defaults: UserDefaults

    private init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func get<T: Decodable>(_ key: UserDefaultsKey) -> T? {
        guard let data = defaults.data(forKey: key.rawValue) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func set<T: Encodable>(_ value: T?, for key: UserDefaultsKey) {
        if let value {
            let data = try? JSONEncoder().encode(value)
            defaults.set(data, forKey: key.rawValue)
        } else {
            defaults.removeObject(forKey: key.rawValue)
        }
    }
}

enum UserDefaultsKey: String {
    case isOnboardingShown
    case isPremiumUser
}
