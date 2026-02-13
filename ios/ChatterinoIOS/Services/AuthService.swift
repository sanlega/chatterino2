import Foundation

protocol AuthService {
    var isAuthenticated: Bool { get }
    var accessToken: String? { get }
    func signIn() async throws
    func signOut()
}

final class MockAuthService: AuthService {
    private let tokenKey = "twitch_access_token"

    var isAuthenticated: Bool {
        KeychainStore.load(key: tokenKey) != nil
    }

    var accessToken: String? {
        KeychainStore.load(key: tokenKey)
    }

    func signIn() async throws {
        try await Task.sleep(nanoseconds: 400_000_000)
        KeychainStore.save(key: tokenKey, value: "mock_token")
    }

    func signOut() {
        KeychainStore.remove(key: tokenKey)
        KeychainStore.remove(key: "twitch_refresh_token")
        KeychainStore.remove(key: "twitch_login")
        KeychainStore.remove(key: "twitch_user_id")
    }
}
