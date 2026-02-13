import SwiftUI

@main
struct ChatterinoIOSApp: App {
    @StateObject private var vm = AppViewModel(
        auth: ServiceFactory.makeAuthService(),
        chat: ServiceFactory.makeChatService()
    )

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(vm)
                .task {
                    await vm.bootstrap()
                }
        }
    }
}
