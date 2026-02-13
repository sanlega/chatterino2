import Foundation
import AuthenticationServices

@MainActor
final class TwitchOAuthService: NSObject, AuthService {
    private let tokenKey = "twitch_access_token"
    private let clientId: String
    private let redirectURI: String

    init(clientId: String, redirectURI: String) {
        self.clientId = clientId
        self.redirectURI = redirectURI
    }

    var isAuthenticated: Bool {
        KeychainStore.load(key: tokenKey) != nil
    }

    func signIn() async throws {
        // MVP: placeholder PKCE flow.
        // Implementación real: ASWebAuthenticationSession + code_verifier/code_challenge + token exchange.
        guard !clientId.isEmpty, !redirectURI.isEmpty else {
            throw NSError(domain: "TwitchOAuthService", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Missing Twitch OAuth config"])
        }
        throw NSError(domain: "TwitchOAuthService", code: 2,
                      userInfo: [NSLocalizedDescriptionKey: "OAuth real no implementado aún"])
    }

    func signOut() {
        KeychainStore.remove(key: tokenKey)
    }
}
