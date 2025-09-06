import Foundation

struct OrderItem: Identifiable, Codable {
    let id: String
    let title: String
    let qty: Int
    let price: Int
}

struct Payment: Codable {
    let method: String
    var status: PaymentStatus
    var paymentId: String?
    enum PaymentStatus: String, Codable {
        case new = "NEW"
        case pending = "PENDING"
        case paid = "PAID"
        case cancelled = "CANCELLED"
    }
}

struct Customer: Codable {
    let name: String
    let phone: String
    let address: String?
    let lat: Double?
    let lng: Double?
}

enum OrderStatus: String, Codable {
    case new = "NEW"
    case pendingPayment = "PENDING_PAYMENT"
    case paid = "PAID"
    case accepted = "ACCEPTED"
    case cooking = "COOKING"
    case readyForDelivery = "READY_FOR_DELIVERY"
    case assigned = "ASSIGNED"
    case pickedUp = "PICKED_UP"
    case delivered = "DELIVERED"
}

struct Order: Identifiable, Codable {
    let id: String
    let restaurantId: String
    var items: [OrderItem]
    var total: Int
    var payment: Payment
    var customer: Customer
    var status: OrderStatus
}
