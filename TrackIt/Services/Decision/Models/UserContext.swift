import Foundation

struct UserContext {
    let locale: String
    let timezone: String
    let language: String
    let isFirstLaunch: Bool
}

extension UserContext {
    static func current() -> UserContext {
        let locale = Locale.current.identifier
        let timezone = TimeZone.current.identifier
        let language = Locale.preferredLanguages.first ?? "en"
        let storage = UserDefaultsStorage.shared
        
        let isAppFirstLaunchValue: Bool = storage.get(UserDefaultsKey.isAppFirstLaunch) ?? true
        let isFirstLaunch = isAppFirstLaunchValue
        
        print("UserContext.current(): Checking first launch")
        print("   - isAppFirstLaunch from UserDefaults: \(isAppFirstLaunchValue)")
        print("   - isFirstLaunch: \(isFirstLaunch)")
        
        return UserContext(
            locale: locale,
            timezone: timezone,
            language: language,
            isFirstLaunch: isFirstLaunch
        )
    }
    
    static func markAppLaunched() {
        let storage = UserDefaultsStorage.shared
        storage.set(false, for: .isAppFirstLaunch)
        print("UserContext: App marked as launched (isAppFirstLaunch = false)")
    }
}
