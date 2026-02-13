import Foundation

final class AppViewModel: ObservableObject {
    enum Route {
        case login
        case channels
        case chat(Channel)
    }

    struct Channel: Identifiable, Hashable {
        let id: String
        let name: String
        let viewers: Int
    }

    struct ChatMessage: Identifiable, Hashable {
        let id = UUID()
        let author: String
        let text: String
    }

    @Published var route: Route = .login
    @Published var channels: [Channel] = [
        .init(id: "shroud", name: "shroud", viewers: 54231),
        .init(id: "ibai", name: "ibai", viewers: 81234),
        .init(id: "auronplay", name: "auronplay", viewers: 102230)
    ]
    @Published var messages: [ChatMessage] = [
        .init(author: "system", text: "MVP bootstrap: chat mock activo")
    ]

    func login() {
        // TODO: reemplazar por OAuth Twitch real (bridge)
        route = .channels
    }

    func open(channel: Channel) {
        messages = [
            .init(author: "system", text: "Entraste en #\(channel.name)"),
            .init(author: "mod", text: "Bienvenido al chat")
        ]
        route = .chat(channel)
    }

    func send(text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        messages.append(.init(author: "you", text: text))
    }

    func logout() {
        route = .login
    }
}
