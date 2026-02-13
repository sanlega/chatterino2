import Foundation

struct Channel: Identifiable, Hashable {
    let id: String
    let name: String
    let viewers: Int
}

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let author: String
    let text: String
    let date: Date = .init()
}

enum AppRoute: Hashable {
    case login
    case channels
    case chat(Channel)
}
