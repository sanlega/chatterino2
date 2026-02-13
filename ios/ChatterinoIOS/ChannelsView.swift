import SwiftUI

struct ChannelsView: View {
    @EnvironmentObject var vm: AppViewModel

    var body: some View {
        NavigationStack {
            List(vm.channels) { channel in
                Button {
                    Task { await vm.open(channel: channel) }
                } label: {
                    HStack {
                        Text("#\(channel.name)")
                        Spacer()
                        Text("\(channel.viewers)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .overlay {
                if vm.channels.isEmpty {
                    ProgressView("Cargando canales...")
                }
            }
            .navigationTitle("Canales")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Recargar") { Task { await vm.loadChannels() } }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Salir") { vm.logout() }
                }
            }
        }
        .task {
            if vm.channels.isEmpty {
                await vm.loadChannels()
            }
        }
    }
}
