import Foundation

protocol UserDefaultsStoring {
    func get<T: Decodable>(_ key: UserDefaultsKey) -> T?
    func set<T: Encodable>(_ value: T?, for key: UserDefaultsKey)
}
