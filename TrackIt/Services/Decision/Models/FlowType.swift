import Foundation

enum FlowType {
    case showPaywall
    case skipPaywall
    case alternativeContent(AlternativeContent)
}
