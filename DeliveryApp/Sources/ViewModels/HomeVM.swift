import Foundation

final class HomeVM: ObservableObject {
    @Published var restaurants: [Restaurant] = []

    func load() {
        if let url = Bundle.main.url(forResource: "restaurants", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let list = try? JSONDecoder().decode([Restaurant].self, from: data) {
            restaurants = list
        }
    }
}
