import SwiftUI

struct ChannelsView: View {
    @EnvironmentObject var vm: AppViewModel

    var body: some View {
        NavigationStack {
            List(vm.channels) { channel in
                Button {
                    vm.open(channel: channel)
                } label: {
                    HStack {
                        Text("#\(channel.name)")
                        Spacer()
                        Text("\(channel.viewers)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Canales")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Salir") { vm.logout() }
                }
            }
        }
    }
}
