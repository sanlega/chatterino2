import Foundation

final class TwitchHelixChatService: ChatService {
    private let accessTokenProvider: () -> String?
    private let clientId: String
    private let irc = TwitchIRCClient()

    private var currentChannel: String?

    init(clientId: String, accessTokenProvider: @escaping () -> String?) {
        self.clientId = clientId
        self.accessTokenProvider = accessTokenProvider
    }

    func fetchChannels() async throws -> [Channel] {
        guard !clientId.isEmpty else {
            throw NSError(domain: "TwitchHelixChatService", code: 10,
                          userInfo: [NSLocalizedDescriptionKey: "TWITCH_CLIENT_ID vacío"])
        }

        var req = URLRequest(url: URL(string: "https://api.twitch.tv/helix/streams?first=20")!)
        req.setValue(clientId, forHTTPHeaderField: "Client-Id")
        if let token = accessTokenProvider() {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: req)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            let text = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "TwitchHelixChatService", code: 11,
                          userInfo: [NSLocalizedDescriptionKey: "Error cargando canales: \(text)"])
        }

        struct StreamRow: Decodable {
            let user_login: String
            let viewer_count: Int
        }
        struct StreamsResponse: Decodable {
            let data: [StreamRow]
        }

        let decoded = try JSONDecoder().decode(StreamsResponse.self, from: data)
        return decoded.data.map {
            .init(id: $0.user_login.lowercased(), name: $0.user_login.lowercased(), viewers: $0.viewer_count)
        }
    }

    func fetchMessages(channelId: String) async throws -> [ChatMessage] {
        [
            .init(author: "system", text: "Conectando a #\(channelId) ...")
        ]
    }

    func startRealtime(channelId: String, onMessage: @escaping (ChatMessage) -> Void) async throws {
        guard let token = accessTokenProvider() else {
            throw NSError(domain: "TwitchHelixChatService", code: 12,
                          userInfo: [NSLocalizedDescriptionKey: "No hay token OAuth"])
        }

        let me = try await fetchCurrentUser(token: token)
        KeychainStore.save(key: "twitch_login", value: me.login)
        KeychainStore.save(key: "twitch_user_id", value: me.id)

        currentChannel = channelId
        irc.connect(oauthToken: token, nickname: me.login, channel: channelId, onMessage: onMessage)
    }

    func sendMessage(channelId: String, text: String) async throws {
        guard accessTokenProvider() != nil else {
            throw NSError(domain: "TwitchHelixChatService", code: 13,
                          userInfo: [NSLocalizedDescriptionKey: "Token no disponible"])
        }
        irc.sendChatMessage(text, channel: channelId)
    }

    func stopRealtime() {
        currentChannel = nil
        irc.disconnect()
    }

    private func fetchCurrentUser(token: String) async throws -> (id: String, login: String) {
        var req = URLRequest(url: URL(string: "https://api.twitch.tv/helix/users")!)
        req.setValue(clientId, forHTTPHeaderField: "Client-Id")
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: req)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            let text = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "TwitchHelixChatService", code: 14,
                          userInfo: [NSLocalizedDescriptionKey: "No se pudo leer usuario Twitch: \(text)"])
        }

        struct UserRow: Decodable { let id: String; let login: String }
        struct UsersResponse: Decodable { let data: [UserRow] }
        let decoded = try JSONDecoder().decode(UsersResponse.self, from: data)
        guard let user = decoded.data.first else {
            throw NSError(domain: "TwitchHelixChatService", code: 15,
                          userInfo: [NSLocalizedDescriptionKey: "Usuario Twitch no encontrado"])
        }
        return (user.id, user.login)
    }
}
