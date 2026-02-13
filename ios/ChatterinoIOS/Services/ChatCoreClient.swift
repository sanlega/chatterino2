import Foundation

/// Wrapper Swift del bridge C/C++.
/// Nota: requiere exponer `ChatCoreBridgeC.h` en el bridging header del target.
final class ChatCoreClient {
    func isAuthenticatedFromCore() -> Bool {
        // TODO: activar al conectar bridging header de Xcode target.
        // let handle = chatcore_create()
        // defer { chatcore_destroy(handle) }
        // return chatcore_is_authenticated(handle) == 1
        return false
    }
}
