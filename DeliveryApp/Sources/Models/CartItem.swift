import Foundation

struct CartItem: Identifiable {
    let id = UUID()
    let item: MenuItem
    var qty: Int
}
