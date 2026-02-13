import Foundation

@MainActor
final class AppViewModel: ObservableObject {
    @Published var route: AppRoute = .login
    @Published var channels: [Channel] = []
    @Published var messages: [ChatMessage] = []
    @Published var isLoading = false
    @Published var errorText: String?

    private let auth: AuthService
    private let chat: ChatService

    init(auth: AuthService = MockAuthService(),
         chat: ChatService = MockChatService()) {
        self.auth = auth
        self.chat = chat
        self.route = auth.isAuthenticated ? .channels : .login
    }

    func bootstrap() async {
        if auth.isAuthenticated {
            await loadChannels()
            route = .channels
        }
    }

    func login() async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await auth.signIn()
            await loadChannels()
            route = .channels
        } catch {
            errorText = "No se pudo iniciar sesión"
        }
    }

    func loadChannels() async {
        do {
            channels = try await chat.fetchChannels()
        } catch {
            errorText = "No se pudieron cargar canales"
        }
    }

    func open(channel: Channel) async {
        isLoading = true
        defer { isLoading = false }
        do {
            messages = try await chat.fetchMessages(channelId: channel.id)
            route = .chat(channel)
        } catch {
            errorText = "No se pudo abrir el canal"
        }
    }

    func send(text: String, in channel: Channel) async {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        do {
            try await chat.sendMessage(channelId: channel.id, text: text)
            messages.append(.init(author: "you", text: text))
        } catch {
            errorText = "No se pudo enviar el mensaje"
        }
    }

    func logout() {
        auth.signOut()
        channels = []
        messages = []
        route = .login
    }
}
