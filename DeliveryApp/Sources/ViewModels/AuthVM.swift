import Foundation

final class AuthVM: ObservableObject {
    @Published var isAuthenticated = false
    private let service: AuthService

    init(service: AuthService = AuthService()) {
        self.service = service
    }

    func login() {
        isAuthenticated = true
    }
}

