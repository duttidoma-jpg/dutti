import Foundation

final class PaymentService {
    private let api = ApiClient.shared

    func startSBPPayment(orderId: String, amount: Int, currency: String = "RUB", openURL: @escaping (URL) -> Void) async -> (String?, Bool) {
        struct CreateReq: Encodable { let orderId: String; let amount: Int; let currency: String }
        struct CreateResp: Decodable { let paymentId: String; let payUrl: String }
        struct StatusReq: Encodable { let paymentId: String }
        struct StatusResp: Decodable { let status: String }
        do {
            let create: CreateResp = try await api.post("payments/sbp/create", body: CreateReq(orderId: orderId, amount: amount, currency: currency))
            if let url = URL(string: create.payUrl) { openURL(url) }
            var paid = false
            while !paid {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                let status: StatusResp = try await api.post("payments/sbp/status", body: StatusReq(paymentId: create.paymentId))
                paid = status.status == "PAID"
            }
            return (create.paymentId, true)
        } catch {
            print("Payment error", error)
            return (nil, false)
        }
    }
}
