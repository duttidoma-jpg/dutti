import Foundation

final class ProfileVM: ObservableObject {
    @Published var name: String
    @Published var phone: String
    @Published var address: String
    @Published var lat: Double?
    @Published var lng: Double?
    private let locationService = LocationService()

    init() {
        let d = UserDefaults.standard
        name = d.string(forKey: "name") ?? ""
        phone = d.string(forKey: "phone") ?? ""
        address = d.string(forKey: "address") ?? ""
        lat = d.value(forKey: "lat") as? Double
        lng = d.value(forKey: "lng") as? Double
    }

    func save() {
        let d = UserDefaults.standard
        d.set(name, forKey: "name")
        d.set(phone, forKey: "phone")
        d.set(address, forKey: "address")
        d.set(lat, forKey: "lat")
        d.set(lng, forKey: "lng")
    }

    func updateLocation() {
        Task {
            if let coord = await locationService.request() {
                await MainActor.run {
                    self.lat = coord.latitude
                    self.lng = coord.longitude
                    self.save()
                }
            }
        }
    }

    var customer: Customer {
        Customer(name: name, phone: phone, address: address, lat: lat, lng: lng)
    }
}
