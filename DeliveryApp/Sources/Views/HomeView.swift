import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeVM()
    @EnvironmentObject var profile: ProfileVM

    var body: some View {
        List {
            Section(header: Text(profile.address.isEmpty ? "Укажите адрес в профиле" : profile.address)) {
                ForEach(vm.restaurants) { r in
                    NavigationLink(destination: MenuView(restaurant: r)) {
                        RestaurantCard(restaurant: r)
                    }
                }
            }
        }
        .navigationTitle("Рестораны")
        .toolbar {
            NavigationLink(destination: ProfileView()) {
                Image(systemName: "person.circle")
            }
            NavigationLink(destination: CartView()) {
                Image(systemName: "cart")
            }
        }
        .onAppear { vm.load() }
    }
}
