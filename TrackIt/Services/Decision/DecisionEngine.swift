import Foundation

final class DecisionEngine {
    static let shared = DecisionEngine()
    
    private init() {}
    
    func determineFlow(for context: UserContext) -> DecisionResult {
        print("DecisionEngine: Received UserContext")
        print("   - Locale: \(context.locale)")
        print("   - Timezone: \(context.timezone)")
        print("   - Language: \(context.language)")
        print("   - IsFirstLaunch: \(context.isFirstLaunch)")
        
        guard context.isFirstLaunch else {
            print("DecisionEngine: Not first launch → skipPaywall")
            return DecisionResult(flowType: .skipPaywall)
        }
        
        print("DecisionEngine: First launch → calculating flow")
        let flowType = evaluateFlow(context: context)
        return DecisionResult(flowType: flowType)
    }
    
    private func evaluateFlow(context: UserContext) -> FlowType {
        let regionCode = extractRegionCode(from: context.locale)
        let timezoneOffset = getTimezoneOffset(context.timezone)
        let languageCode = extractLanguageCode(from: context.language)
        
        print("DecisionEngine: Extracted values")
        print("   - Region Code: \(regionCode)")
        print("   - Timezone Offset: \(timezoneOffset) hours")
        print("   - Language Code: \(languageCode)")
        
        let score = calculateScore(
            region: regionCode,
            timezone: timezoneOffset,
            language: languageCode
        )
        
        print("DecisionEngine: Calculated Score = \(score)")
        
        if score >= 70 {
            print("DecisionEngine: Score >= 70 → showPaywall")
            return .showPaywall
        } else if score >= 40 {
            let content = AlternativeContent(
                headline: generateAlternativeHeadline(for: languageCode),
                ctaText: generateAlternativeCTA(for: languageCode)
            )
            print("DecisionEngine: Score >= 40 (but < 70) → alternativeContent")
            print("   - Headline: \(content.headline)")
            print("   - CTA Text: \(content.ctaText)")
            return .alternativeContent(content)
        } else {
            print("DecisionEngine: Score < 40 → skipPaywall")
            return .skipPaywall
        }
    }
    
    private func extractRegionCode(from locale: String) -> String {
        let components = locale.components(separatedBy: "_")
        return components.last ?? locale
    }
    
    private func extractLanguageCode(from language: String) -> String {
        let components = language.components(separatedBy: "-")
        return components.first ?? language
    }
    
    private func getTimezoneOffset(_ timezone: String) -> Int {
        guard let tz = TimeZone(identifier: timezone) else { return 0 }
        let seconds = tz.secondsFromGMT()
        return seconds / 3600
    }
    
    private func calculateScore(region: String, timezone: Int, language: String) -> Int {
        var score = 0
        var regionPoints = 0
        var timezonePoints = 0
        var languagePoints = 0
        
        let highValueRegions = ["US", "CA", "GB", "AU", "DE", "FR", "IT", "ES", "NL", "SE", "NO", "DK"]
        if highValueRegions.contains(region) {
            regionPoints = 40
            score += 40
        } else {
            regionPoints = 20
            score += 20
        }
        
        let europeanTimezones = Array(-2...3)
        if europeanTimezones.contains(timezone) {
            timezonePoints = 25
            score += 25
        } else if timezone >= -8 && timezone <= -5 {
            timezonePoints = 30
            score += 30
        } else {
            timezonePoints = 15
            score += 15
        }
        
        let englishLanguages = ["en"]
        if englishLanguages.contains(language) {
            languagePoints = 20
            score += 20
        } else {
            languagePoints = 10
            score += 10
        }
        
        print("   DecisionEngine: Score breakdown")
        print("      - Region: \(region) → \(regionPoints) points")
        print("      - Timezone: \(timezone) → \(timezonePoints) points")
        print("      - Language: \(language) → \(languagePoints) points")
        print("      - Total: \(score) points")
        
        return min(score, 100)
    }
    
    private func generateAlternativeHeadline(for language: String) -> String {
        switch language.lowercased() {
        case "en":
            return "Unlock\nPremium Features"
        case "ru":
            return "Откройте\nпремиум функции"
        case "uk":
            return "Розблокуйте\nпреміум функції"
        case "de":
            return "Premium-Funktionen\nfreischalten"
        case "fr":
            return "Débloquer les\nfonctionnalités premium"
        case "es":
            return "Desbloquear\nfunciones premium"
        default:
            return "Unlock\nPremium Features"
        }
    }
    
    private func generateAlternativeCTA(for language: String) -> String {
        switch language.lowercased() {
        case "en":
            return "Try Premium"
        case "ru":
            return "Попробовать Premium"
        case "uk":
            return "Спробувати Premium"
        case "de":
            return "Premium testen"
        case "fr":
            return "Essayer Premium"
        case "es":
            return "Probar Premium"
        default:
            return "Try Premium"
        }
    }
}
