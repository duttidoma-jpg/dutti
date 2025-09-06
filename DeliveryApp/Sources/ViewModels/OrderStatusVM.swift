import Foundation

final class OrderStatusVM: ObservableObject {
    @Published var order: Order?
    private let orderId: String

    init(orderId: String) {
        self.orderId = orderId
        Task { await poll() }
    }

    func poll() async {
        while true {
            do {
                let o: Order = try await ApiClient.shared.get("orders/\(orderId)")
                await MainActor.run { self.order = o }
                if o.status == .delivered { break }
            } catch {
                break
            }
            try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
        }
    }
}
