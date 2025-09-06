import Foundation

final class MenuVM: ObservableObject {
    let restaurant: Restaurant
    @Published var items: [MenuItem] = []

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        load()
    }

    private func load() {
        if let url = Bundle.main.url(forResource: "menu", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let list = try? JSONDecoder().decode([MenuItem].self, from: data) {
            items = list.filter { $0.restaurantID == restaurant.id }
        }
    }
}
