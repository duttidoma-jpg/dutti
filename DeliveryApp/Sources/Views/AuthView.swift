import SwiftUI

struct AuthView: View {
    @StateObject var vm = AuthVM()

    var body: some View {
        VStack {
            Text("Auth View")
            Button("Sign In") {
                vm.login()
            }
        }
    }
}

#Preview {
    AuthView()
}
