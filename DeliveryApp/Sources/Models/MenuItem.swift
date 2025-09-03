import Foundation

struct MenuItem: Identifiable, Codable {
    let id: String
    let restaurantID: String
    let title: String
    let price: Int
    let photoURL: URL
}
