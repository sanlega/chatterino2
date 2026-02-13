import SwiftUI

struct RootView: View {
    @EnvironmentObject var vm: AppViewModel

    var body: some View {
        switch vm.route {
        case .login:
            LoginView()
        case .channels:
            ChannelsView()
        case .chat(let channel):
            ChatView(channel: channel)
        }
    }
}
