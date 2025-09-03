import Foundation

final class ApiClient {
    static let shared = ApiClient()
    let baseURL: URL?
    var mockMode: Bool { baseURL == nil }

    private init() {
        if let urlString = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
           let url = URL(string: urlString), !urlString.isEmpty {
            baseURL = url
        } else {
            baseURL = nil
        }
    }

    func get<T: Decodable>(_ path: String) async throws -> T {
        if mockMode { return try await MockServer.shared.get(path) }
        guard let baseURL else { throw URLError(.badURL) }
        let url = baseURL.appendingPathComponent(path)
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }

    func post<T: Decodable, Body: Encodable>(_ path: String, body: Body) async throws -> T {
        if mockMode { return try await MockServer.shared.post(path, body: body) }
        guard let baseURL else { throw URLError(.badURL) }
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - MockServer

final class MockServer {
    static let shared = MockServer()
    private init() {}

    private var payments: [String: Bool] = [:]
    private var orders: [String: Order] = [:]

    func post<T: Decodable, Body: Encodable>(_ path: String, body: Body) async throws -> T {
        switch path {
        case "payments/sbp/create":
            let id = UUID().uuidString
            payments[id] = false
            Task {
                try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
                self.payments[id] = true
            }
            let resp = PaymentCreateResponse(paymentId: id, payUrl: "app://mockpay")
            return resp as! T
        case "payments/sbp/status":
            struct Req: Decodable { let paymentId: String }
            let data = try JSONEncoder().encode(body)
            let req = try JSONDecoder().decode(Req.self, from: data)
            let paid = payments[req.paymentId] ?? false
            let status = paid ? "PAID" : "PENDING"
            let resp = PaymentStatusResponse(status: status)
            return resp as! T
        case "telegram/sendOrder":
            // no-op
            return (EmptyResponse() as! T)
        default:
            throw URLError(.unsupportedURL)
        }
    }

    func get<T: Decodable>(_ path: String) async throws -> T {
        if path.hasPrefix("orders/") {
            let id = String(path.dropFirst("orders/".count))
            guard let order = orders[id] else { throw URLError(.fileDoesNotExist) }
            let data = try JSONEncoder().encode(order)
            return try JSONDecoder().decode(T.self, from: data)
        }
        throw URLError(.unsupportedURL)
    }

    func store(order: Order) {
        orders[order.id] = order
        progress(orderId: order.id)
    }

    private func progress(orderId: String) {
        let steps: [OrderStatus] = [.paid, .accepted, .cooking, .readyForDelivery, .assigned, .pickedUp, .delivered]
        for (idx, status) in steps.enumerated() {
            guard idx > 0 else { continue }
            Task { [weak self] in
                try? await Task.sleep(nanoseconds: UInt64(idx * 3) * 1_000_000_000)
                guard var o = self?.orders[orderId] else { return }
                o.status = status
                self?.orders[orderId] = o
            }
        }
    }

    struct PaymentCreateResponse: Codable {
        let paymentId: String
        let payUrl: String
    }
    struct PaymentStatusResponse: Codable {
        let status: String
    }
    struct EmptyResponse: Codable {}
}
