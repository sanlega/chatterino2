import Foundation
import AuthenticationServices
import CryptoKit
import UIKit

final class TwitchOAuthService: NSObject, AuthService, ASWebAuthenticationPresentationContextProviding {
    private let tokenKey = "twitch_access_token"
    private let refreshTokenKey = "twitch_refresh_token"

    private let clientId: String
    private let redirectURI: String

    private var authSession: ASWebAuthenticationSession?

    init(clientId: String, redirectURI: String) {
        self.clientId = clientId
        self.redirectURI = redirectURI
    }

    var isAuthenticated: Bool {
        KeychainStore.load(key: tokenKey) != nil
    }

    var accessToken: String? {
        KeychainStore.load(key: tokenKey)
    }

    func signIn() async throws {
        guard !clientId.isEmpty, !redirectURI.isEmpty else {
            throw NSError(domain: "TwitchOAuthService", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Falta TWITCH_CLIENT_ID o TWITCH_REDIRECT_URI"])
        }

        let codeVerifier = Self.randomURLSafeString(length: 64)
        let codeChallenge = Self.sha256Base64URL(codeVerifier)
        let state = Self.randomURLSafeString(length: 24)

        var comps = URLComponents(string: "https://id.twitch.tv/oauth2/authorize")!
        comps.queryItems = [
            .init(name: "response_type", value: "code"),
            .init(name: "client_id", value: clientId),
            .init(name: "redirect_uri", value: redirectURI),
            .init(name: "scope", value: "chat:read chat:edit user:read:email"),
            .init(name: "state", value: state),
            .init(name: "code_challenge", value: codeChallenge),
            .init(name: "code_challenge_method", value: "S256"),
        ]

        guard let authURL = comps.url else {
            throw NSError(domain: "TwitchOAuthService", code: 2,
                          userInfo: [NSLocalizedDescriptionKey: "No se pudo construir URL OAuth"])
        }

        let callbackScheme = URL(string: redirectURI)?.scheme

        let callbackURL: URL = try await withCheckedThrowingContinuation { cont in
            let session = ASWebAuthenticationSession(url: authURL,
                                                     callbackURLScheme: callbackScheme) { url, error in
                if let error {
                    cont.resume(throwing: error)
                    return
                }
                guard let url else {
                    cont.resume(throwing: NSError(domain: "TwitchOAuthService", code: 3,
                                                  userInfo: [NSLocalizedDescriptionKey: "OAuth cancelado"]))
                    return
                }
                cont.resume(returning: url)
            }
            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = false
            self.authSession = session
            session.start()
        }

        guard let callbackComps = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
              let queryItems = callbackComps.queryItems,
              let code = queryItems.first(where: { $0.name == "code" })?.value,
              let returnedState = queryItems.first(where: { $0.name == "state" })?.value,
              returnedState == state
        else {
            throw NSError(domain: "TwitchOAuthService", code: 4,
                          userInfo: [NSLocalizedDescriptionKey: "Respuesta OAuth inválida"])
        }

        var request = URLRequest(url: URL(string: "https://id.twitch.tv/oauth2/token")!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyPairs: [String: String] = [
            "client_id": clientId,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectURI,
            "code_verifier": codeVerifier,
        ]
        request.httpBody = bodyPairs
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
            .data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            let text = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "TwitchOAuthService", code: 5,
                          userInfo: [NSLocalizedDescriptionKey: "Token exchange falló: \(text)"])
        }

        struct TokenResponse: Decodable {
            let access_token: String
            let refresh_token: String?
        }

        let token = try JSONDecoder().decode(TokenResponse.self, from: data)
        KeychainStore.save(key: tokenKey, value: token.access_token)
        if let refresh = token.refresh_token {
            KeychainStore.save(key: refreshTokenKey, value: refresh)
        }
    }

    func signOut() {
        KeychainStore.remove(key: tokenKey)
        KeychainStore.remove(key: refreshTokenKey)
        KeychainStore.remove(key: "twitch_login")
        KeychainStore.remove(key: "twitch_user_id")
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        for scene in UIApplication.shared.connectedScenes {
            if let winScene = scene as? UIWindowScene,
               let win = winScene.windows.first(where: { $0.isKeyWindow }) {
                return win
            }
        }
        return ASPresentationAnchor()
    }

    private static func randomURLSafeString(length: Int) -> String {
        let chars = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return String((0..<length).map { _ in chars.randomElement()! })
    }

    private static func sha256Base64URL(_ input: String) -> String {
        let digest = SHA256.hash(data: Data(input.utf8))
        let data = Data(digest)
        return data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
