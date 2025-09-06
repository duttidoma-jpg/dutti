import Foundation

struct Restaurant: Identifiable, Codable {
    let id: String
    let name: String
    let address: String
    let photoURL: URL
    let etaMinutes: Int
    let openUntil: String
}
