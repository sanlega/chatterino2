import Foundation

protocol ChatService {
    func fetchChannels() async throws -> [Channel]
    func fetchMessages(channelId: String) async throws -> [ChatMessage]
    func sendMessage(channelId: String, text: String) async throws
}

final class MockChatService: ChatService {
    func fetchChannels() async throws -> [Channel] {
        try await Task.sleep(nanoseconds: 250_000_000)
        return [
            .init(id: "ibai", name: "ibai", viewers: 81234),
            .init(id: "auronplay", name: "auronplay", viewers: 102230),
            .init(id: "shroud", name: "shroud", viewers: 54231)
        ]
    }

    func fetchMessages(channelId: String) async throws -> [ChatMessage] {
        try await Task.sleep(nanoseconds: 120_000_000)
        return [
            .init(author: "system", text: "Conectado a #\(channelId)"),
            .init(author: "mod", text: "MVP iOS en progreso")
        ]
    }

    func sendMessage(channelId: String, text: String) async throws {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        _ = channelId
    }
}
