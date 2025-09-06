import Foundation

struct User: Codable {
    var name: String
    var phone: String
    var address: Address?
}

