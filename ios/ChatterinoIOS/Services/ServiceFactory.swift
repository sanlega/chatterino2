import Foundation

enum ServiceFactory {
    static func makeAuthService() -> AuthService {
#if USE_REAL_SERVICES
        return TwitchOAuthService(
            clientId: AppConfig.twitchClientID,
            redirectURI: AppConfig.twitchRedirectURI
        )
#else
        return MockAuthService()
#endif
    }

    static func makeChatService() -> ChatService {
#if USE_REAL_SERVICES
        return TwitchHelixChatService(clientId: AppConfig.twitchClientID, accessTokenProvider: {
            KeychainStore.load(key: "twitch_access_token")
        })
#else
        return MockChatService()
#endif
    }
}

enum AppConfig {
    static var twitchClientID: String {
        (Bundle.main.object(forInfoDictionaryKey: "TWITCH_CLIENT_ID") as? String) ?? ""
    }

    static var twitchRedirectURI: String {
        (Bundle.main.object(forInfoDictionaryKey: "TWITCH_REDIRECT_URI") as? String) ?? ""
    }
}
