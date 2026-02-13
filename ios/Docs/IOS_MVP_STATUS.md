# iOS MVP - Estado y próximos pasos

Última actualización: 2026-02-13

## Estado actual del bloque

- [x] Proyecto iOS definido por `project.yml` (XcodeGen)
- [x] Scripts reproducibles para generar y validar estructura
- [x] Selección de servicios `mock/real` por flags de compilación
- [x] Documentación de arranque y checklist ejecutable

## Modo de servicios por compilación

- `Debug` -> `USE_MOCK_SERVICES`
- `Release` -> `USE_REAL_SERVICES`

La resolución de servicios está centralizada en `ChatterinoIOS/Services/ServiceFactory.swift`.

## Checklist ejecutable

```bash
cd ios
./scripts/generate_project.sh
./scripts/verify_structure.sh
```

Opcional (si estás en macOS con Xcode CLI instalado):

```bash
cd ios
xcodebuild -list -project ChatterinoIOS.xcodeproj
```

## Próximos pasos (siguiente bloque)

1. OAuth Twitch real (PKCE + `ASWebAuthenticationSession`) en `TwitchOAuthService`.
2. Wire real de chat (core C++ / bridge) en `TwitchHelixChatService` o servicio dedicado.
3. Añadir tests básicos de wiring para `ServiceFactory` (debug/release en CI).
4. Integrar `Config.xcconfig` real (secretos fuera del repo) y documentar rotación de credenciales.
