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
    // Hardcode temporal para eliminar dudas de lectura de configuración.
    // Cuando OAuth quede estable, volvemos a leer desde Config.xcconfig/Info.plist.
    static var twitchClientID: String { "ly5unwrgvyb238l3ia9ndgmtmcoq3g" }
    static var twitchClientSecret: String { "" } // app pública
    static var twitchRedirectURI: String { "https://sanlega.github.io/chatterinoios-oauth-relay/" }
    static var twitchCallbackScheme: String { "chatterinoios" }
}
