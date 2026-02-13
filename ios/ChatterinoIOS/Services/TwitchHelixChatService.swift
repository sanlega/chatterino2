import Foundation

final class TwitchHelixChatService: ChatService {
    private let accessTokenProvider: () -> String?

    init(accessTokenProvider: @escaping () -> String?) {
        self.accessTokenProvider = accessTokenProvider
    }

    func fetchChannels() async throws -> [Channel] {
        // TODO(MVP): usar endpoint real (siguiendo estrategia del core de Chatterino)
        // Placeholder para permitir wiring incremental.
        throw NSError(domain: "TwitchHelixChatService", code: 10,
                      userInfo: [NSLocalizedDescriptionKey: "fetchChannels real pendiente"])
    }

    func fetchMessages(channelId: String) async throws -> [ChatMessage] {
        _ = channelId
        // TODO(MVP): conectar a transporte real de chat (IRC/WebSocket/eventos del core).
        throw NSError(domain: "TwitchHelixChatService", code: 11,
                      userInfo: [NSLocalizedDescriptionKey: "fetchMessages real pendiente"])
    }

    func sendMessage(channelId: String, text: String) async throws {
        _ = channelId
        _ = text
        guard accessTokenProvider() != nil else {
            throw NSError(domain: "TwitchHelixChatService", code: 12,
                          userInfo: [NSLocalizedDescriptionKey: "Token no disponible"])
        }
        // TODO(MVP): envío real de mensaje por API/IRC del core.
    }
}
