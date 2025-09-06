import SwiftUI

@main
struct DeliveryAppApp: App {
    @StateObject var coordinator = AppCoordinator()
    @StateObject var cartVM = CartVM()
    @StateObject var profileVM = ProfileVM()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.build(.home)
                    .navigationDestination(for: Route.self) { route in
                        coordinator.build(route)
                    }
            }
            .environmentObject(coordinator)
            .environmentObject(cartVM)
            .environmentObject(profileVM)
        }
    }
}
