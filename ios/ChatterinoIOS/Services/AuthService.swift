import Foundation

protocol AuthService {
    var isAuthenticated: Bool { get }
    func signIn() async throws
    func signOut()
}

final class MockAuthService: AuthService {
    private let tokenKey = "twitch_access_token"

    var isAuthenticated: Bool {
        KeychainStore.load(key: tokenKey) != nil
    }

    func signIn() async throws {
        try await Task.sleep(nanoseconds: 400_000_000)
        KeychainStore.save(key: tokenKey, value: "mock_token")
    }

    func signOut() {
        KeychainStore.remove(key: tokenKey)
    }
}
