import SwiftUI

struct RootView: View {
    @EnvironmentObject var vm: AppViewModel

    var body: some View {
        Group {
            switch vm.route {
            case .login:
                LoginView()
            case .channels:
                ChannelsView()
            case .chat(let channel):
                ChatView(channel: channel)
            }
        }
        .overlay(alignment: .top) {
            if let error = vm.errorText {
                Text(error)
                    .padding(10)
                    .background(.red.opacity(0.9))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.top, 8)
            }
        }
    }
}
