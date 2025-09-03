import SwiftUI

struct RestaurantCard: View {
    let restaurant: Restaurant

    var body: some View {
        HStack {
            AsyncImage(url: restaurant.photoURL) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: 80, height: 80)
            .clipped()
            VStack(alignment: .leading) {
                Text(restaurant.name).font(.headline)
                Text("до \(restaurant.openUntil)").font(.subheadline)
                Text("от \(restaurant.etaMinutes) мин").font(.subheadline)
            }
            Spacer()
        }
        .padding(4)
    }
}
