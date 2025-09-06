import Foundation

final class StorageService {
    func save<T: Codable>(_ object: T, forKey key: String) {}
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? { nil }
}

