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
        let fromInfo = (Bundle.main.object(forInfoDictionaryKey: "TWITCH_CLIENT_ID") as? String) ?? ""
        if !fromInfo.isEmpty, fromInfo != "$(TWITCH_CLIENT_ID)" { return fromInfo }
        return "ihae39qdr5zg5sf5sz28ak58cjcl8u"
    }

    static var twitchRedirectURI: String {
        let fromInfo = (Bundle.main.object(forInfoDictionaryKey: "TWITCH_REDIRECT_URI") as? String) ?? ""
        if !fromInfo.isEmpty, fromInfo != "$(TWITCH_REDIRECT_URI)" { return fromInfo }
        return "chatterinoios://auth"
    }
}
