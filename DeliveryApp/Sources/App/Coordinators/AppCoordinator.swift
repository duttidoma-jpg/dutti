import SwiftUI

final class AppCoordinator: ObservableObject {
    @Published var path: [Route] = []

    @ViewBuilder
    func build(_ route: Route) -> some View {
        switch route {
        case .home:
            HomeView()
        case .auth:
            AuthView()
        }
    }
}

