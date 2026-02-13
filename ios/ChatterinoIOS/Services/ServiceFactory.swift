import Foundation

enum ServiceFactory {
    static func makeAuthService() -> AuthService {
#if USE_REAL_SERVICES
        return TwitchOAuthService(
            clientId: AppConfig.twitchClientID,
            clientSecret: AppConfig.twitchClientSecret,
            redirectURI: AppConfig.twitchRedirectURI,
            callbackScheme: AppConfig.twitchCallbackScheme
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
        return "ly5unwrgvyb238l3ia9ndgmtmcoq3g"
    }

    static var twitchClientSecret: String {
        let fromInfo = (Bundle.main.object(forInfoDictionaryKey: "TWITCH_CLIENT_SECRET") as? String) ?? ""
        if !fromInfo.isEmpty, fromInfo != "$(TWITCH_CLIENT_SECRET)" { return fromInfo }
        return ""
    }

    static var twitchRedirectURI: String {
        let fromInfo = (Bundle.main.object(forInfoDictionaryKey: "TWITCH_REDIRECT_URI") as? String) ?? ""
        if !fromInfo.isEmpty, fromInfo != "$(TWITCH_REDIRECT_URI)" { return fromInfo }
        return "https://sanlega.github.io/chatterinoios-oauth-relay/"
    }

    static var twitchCallbackScheme: String {
        let fromInfo = (Bundle.main.object(forInfoDictionaryKey: "TWITCH_CALLBACK_SCHEME") as? String) ?? ""
        if !fromInfo.isEmpty, fromInfo != "$(TWITCH_CALLBACK_SCHEME)" { return fromInfo }
        return "chatterinoios"
    }
}
