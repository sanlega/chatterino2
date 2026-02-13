import SwiftUI

struct ChatView: View {
    @EnvironmentObject var vm: AppViewModel
    let channel: AppViewModel.Channel
    @State private var input = ""

    var body: some View {
        VStack(spacing: 0) {
            List(vm.messages) { msg in
                VStack(alignment: .leading, spacing: 4) {
                    Text(msg.author).font(.caption).foregroundStyle(.secondary)
                    Text(msg.text)
                }
                .padding(.vertical, 2)
            }

            HStack {
                TextField("Escribe un mensaje", text: $input)
                    .textFieldStyle(.roundedBorder)
                Button("Enviar") {
                    vm.send(text: input)
                    input = ""
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(10)
            .background(.ultraThinMaterial)
        }
        .navigationTitle("#\(channel.name)")
        .navigationBarTitleDisplayMode(.inline)
    }
}
