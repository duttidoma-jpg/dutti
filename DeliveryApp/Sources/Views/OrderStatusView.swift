import SwiftUI

struct OrderStatusView: View {
    @StateObject var vm: OrderStatusVM
    private let statuses: [OrderStatus] = [.paid, .accepted, .cooking, .readyForDelivery, .assigned, .pickedUp, .delivered]

    init(orderId: String) {
        _vm = StateObject(wrappedValue: OrderStatusVM(orderId: orderId))
    }

    var body: some View {
        List {
            ForEach(statuses, id: \.self) { status in
                HStack {
                    Circle()
                        .fill(index(of: status) <= currentIndex ? Color.green : Color.gray)
                        .frame(width: 12, height: 12)
                    Text(label(for: status))
                }
            }
        }
        .navigationTitle("Статус заказа")
    }

    private var currentIndex: Int {
        guard let current = vm.order?.status else { return 0 }
        return index(of: current)
    }

    private func index(of status: OrderStatus) -> Int {
        statuses.firstIndex(of: status) ?? 0
    }

    private func label(for status: OrderStatus) -> String {
        switch status {
        case .paid: return "Оплачен"
        case .accepted: return "Принят"
        case .cooking: return "Готовится"
        case .readyForDelivery: return "Готов к доставке"
        case .assigned: return "Курьер назначен"
        case .pickedUp: return "Забран курьером"
        case .delivered: return "Доставлен"
        default: return status.rawValue
        }
    }
}
