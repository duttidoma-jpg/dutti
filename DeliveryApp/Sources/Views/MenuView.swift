import SwiftUI

struct MenuView: View {
    let restaurant: Restaurant
    @StateObject var vm: MenuVM
    @EnvironmentObject var cart: CartVM

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        _vm = StateObject(wrappedValue: MenuVM(restaurant: restaurant))
    }

    var body: some View {
        List(vm.items) { item in
            HStack {
                VStack(alignment: .leading) {
                    Text(item.title)
                    Text("\(item.price) ₽")
                }
                Spacer()
                Button("＋") { cart.add(item: item) }
            }
        }
        .navigationTitle(restaurant.name)
        .toolbar {
            NavigationLink("Корзина (\(cart.items.count))") {
                CartView()
            }
        }
    }
}
