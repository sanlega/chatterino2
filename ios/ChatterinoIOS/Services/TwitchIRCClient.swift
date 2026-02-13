import Foundation
import Network

final class TwitchIRCClient {
    private var connection: NWConnection?
    private let queue = DispatchQueue(label: "twitch.irc.client")
    private var onMessage: ((ChatMessage) -> Void)?

    func connect(oauthToken: String, nickname: String, channel: String,
                 onMessage: @escaping (ChatMessage) -> Void) {
        disconnect()
        self.onMessage = onMessage

        let host = NWEndpoint.Host("irc.chat.twitch.tv")
        let port = NWEndpoint.Port(rawValue: 6697)!
        let tls = NWProtocolTLS.Options()
        let params = NWParameters(tls: tls)

        let conn = NWConnection(host: host, port: port, using: params)
        self.connection = conn

        conn.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                self?.sendRaw("CAP REQ :twitch.tv/tags twitch.tv/commands")
                self?.sendRaw("PASS oauth:\(oauthToken)")
                self?.sendRaw("NICK \(nickname)")
                self?.sendRaw("JOIN #\(channel.lowercased())")
                self?.receiveLoop()
            default:
                break
            }
        }
        conn.start(queue: queue)
    }

    func sendChatMessage(_ text: String, channel: String) {
        sendRaw("PRIVMSG #\(channel.lowercased()) :\(text)")
    }

    func disconnect() {
        connection?.cancel()
        connection = nil
    }

    private func sendRaw(_ line: String) {
        guard let conn = connection else { return }
        let data = (line + "\r\n").data(using: .utf8)!
        conn.send(content: data, completion: .contentProcessed { _ in })
    }

    private func receiveLoop() {
        connection?.receive(minimumIncompleteLength: 1, maximumLength: 8192) { [weak self] data, _, isComplete, _ in
            guard let self else { return }
            if let data, let text = String(data: data, encoding: .utf8) {
                self.handleIncoming(text)
            }
            if !isComplete {
                self.receiveLoop()
            }
        }
    }

    private func handleIncoming(_ chunk: String) {
        for raw in chunk.split(separator: "\n") {
            let line = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            if line.hasPrefix("PING ") {
                let payload = line.replacingOccurrences(of: "PING", with: "PONG")
                sendRaw(payload)
                continue
            }
            guard line.contains(" PRIVMSG ") else { continue }

            var author = "unknown"
            if let displayNameRange = line.range(of: "display-name=") {
                let rest = line[displayNameRange.upperBound...]
                author = rest.split(separator: ";").first.map(String.init) ?? author
            } else if let bang = line.firstIndex(of: "!") {
                author = String(line.dropFirst().prefix(upTo: bang))
            }

            let parts = line.components(separatedBy: " PRIVMSG ")
            guard parts.count >= 2,
                  let idx = parts[1].firstIndex(of: ":") else { continue }
            let messageText = String(parts[1][parts[1].index(after: idx)...])

            DispatchQueue.main.async { [weak self] in
                self?.onMessage?(.init(author: author, text: messageText))
            }
        }
    }
}
