import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var vm: ProfileVM

    var body: some View {
        Form {
            Section {
                TextField("Имя", text: $vm.name)
                TextField("Телефон", text: $vm.phone)
                TextField("Адрес", text: $vm.address)
            }
            Button("Обновить геолокацию") {
                vm.updateLocation()
            }
            .buttonStyle(.bordered)
        }
        .navigationTitle("Профиль")
        .onDisappear { vm.save() }
    }
}
