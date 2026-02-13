# Chatterino iOS (MVP bootstrap)

Estado: **MVP en marcha**.

## Qué está implementado ya

- Shell iOS SwiftUI funcional
- Flujo: `Login -> Canales -> Chat`
- Envío de mensajes (mock)
- Persistencia de sesión mock en Keychain
- Capa de servicios separada (`AuthService`, `ChatService`)
- Selección de servicios por compilación (`USE_MOCK_SERVICES` / `USE_REAL_SERVICES`)
- Puente C++/ObjC++ preparado (`Bridge/ChatCoreBridge.*`)
- Backlog de MVP en `Docs/MVP_BACKLOG.md`
- Estado y checklist ejecutable en `Docs/IOS_MVP_STATUS.md`

## Arranque rápido

Guía completa de setup: `Docs/XCODE_SETUP.md`
Instalación en iPhone: `Docs/INSTALL_ON_IPHONE.md`
Script un-comando: `scripts/one_command_iphone.sh`

1. Instalar XcodeGen (si no lo tienes):
   - `brew install xcodegen`
2. Generar proyecto:
   - `cd ios && ./scripts/generate_project.sh`
3. Verificar estructura:
   - `cd ios && ./scripts/verify_structure.sh`
4. Abrir:
   - `open ChatterinoIOS.xcodeproj`
5. Ejecutar en simulador iPhone.

## Próximo bloque técnico

1. Sustituir `TwitchOAuthService` placeholder por OAuth Twitch real (PKCE)
2. Sustituir `MockChatService`/placeholder real por cliente de chat real sobre core C++
3. Conectar `ChatCoreBridge` con sesiones/canales reales del core
