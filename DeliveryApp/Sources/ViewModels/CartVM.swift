import Foundation

final class CartVM: ObservableObject {
    @Published var items: [CartItem] = []
    private let paymentService = PaymentService()
    private let telegramService = TelegramService()

    func add(item: MenuItem) {
        if let idx = items.firstIndex(where: { $0.item.id == item.id }) {
            items[idx].qty += 1
        } else {
            items.append(CartItem(item: item, qty: 1))
        }
    }

    var total: Int {
        items.reduce(0) { $0 + $1.item.price * $1.qty }
    }

    func checkout(openURL: @escaping (URL) -> Void, profile: ProfileVM) async -> String? {
        let orderId = UUID().uuidString
        let result = await paymentService.startSBPPayment(orderId: orderId, amount: total, openURL: openURL)
        if result.1 {
            let orderItems = items.map { OrderItem(id: $0.item.id, title: $0.item.title, qty: $0.qty, price: $0.item.price) }
            let order = Order(id: orderId, restaurantId: items.first?.item.restaurantID ?? "", items: orderItems, total: total, payment: Payment(method: "SBP_LINK", status: .paid, paymentId: result.0), customer: profile.customer, status: .paid)
            await telegramService.sendOrder(order: order)
            if ApiClient.shared.mockMode {
                MockServer.shared.store(order: order)
            }
            await MainActor.run { self.items = [] }
            return orderId
        }
        return nil
    }
}
