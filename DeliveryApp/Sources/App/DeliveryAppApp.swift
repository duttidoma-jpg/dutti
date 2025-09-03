import SwiftUI

@main
struct DeliveryAppApp: App {
    @StateObject var cartVM = CartVM()
    @StateObject var profileVM = ProfileVM()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
            .environmentObject(cartVM)
            .environmentObject(profileVM)
        }
    }
}
