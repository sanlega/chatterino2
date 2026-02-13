import SwiftUI

struct LoginView: View {
    @EnvironmentObject var vm: AppViewModel

    var body: some View {
        VStack(spacing: 18) {
            Text("Chatterino iOS")
                .font(.largeTitle).bold()

            Text("MVP · Login Twitch")
                .foregroundStyle(.secondary)

            Button("Continuar") {
                vm.login()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
