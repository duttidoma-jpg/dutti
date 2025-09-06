import Foundation

enum PaymentMethod: String, Codable, CaseIterable, Identifiable {
    case sbpLink = "SBP_LINK"

    var id: String { rawValue }
}

