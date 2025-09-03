import Foundation

final class TelegramService {
    private let api = ApiClient.shared

    func sendOrder(order: Order) async {
        do {
            struct Empty: Codable {}
            _ = try await api.post("telegram/sendOrder", body: order) as Empty
        } catch {
            print("Telegram error", error)
        }
    }
}
