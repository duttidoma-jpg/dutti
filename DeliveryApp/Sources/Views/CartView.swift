import SwiftUI

struct CartView: View {
    @EnvironmentObject var cart: CartVM
    @EnvironmentObject var profile: ProfileVM
    @Environment(\.openURL) var openURL
    @State private var orderId: String?
    @State private var showStatus = false

    var body: some View {
        VStack {
            List {
                ForEach(cart.items) { item in
                    HStack {
                        Text("\(item.item.title) x\(item.qty)")
                        Spacer()
                        Text("\(item.item.price * item.qty) ₽")
                    }
                }
            }
            Text("Сумма: \(cart.total) ₽")
            Button("Оплатить через СБП") {
                Task {
                    let id = await cart.checkout(openURL: { openURL($0) }, profile: profile)
                    if let id { self.orderId = id; showStatus = true }
                }
            }
            .buttonStyle(.borderedProminent)
            NavigationLink(destination: OrderStatusView(orderId: orderId ?? ""), isActive: $showStatus) { EmptyView() }
        }
        .padding()
        .navigationTitle("Корзина")
    }
}
