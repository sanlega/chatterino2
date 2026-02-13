# Chatterino iOS (MVP bootstrap)

Estado: **MVP en marcha**.

## Qué está implementado ya

- Shell iOS SwiftUI funcional
- Flujo: `Login -> Canales -> Chat`
- Envío de mensajes (mock)
- Persistencia de sesión mock en Keychain
- Capa de servicios separada (`AuthService`, `ChatService`)
- Puente C++/ObjC++ preparado (`Bridge/ChatCoreBridge.*`)
- Backlog de MVP en `Docs/MVP_BACKLOG.md`

## Arranque rápido

Guía completa de setup: `Docs/XCODE_SETUP.md`


1. Instalar XcodeGen (si no lo tienes):
   - `brew install xcodegen`
2. Generar proyecto:
   - `cd ios && xcodegen generate`
3. Abrir:
   - `open ChatterinoIOS.xcodeproj`
4. Ejecutar en simulador iPhone.

## Próximo bloque técnico

1. Sustituir `MockAuthService` por OAuth Twitch real
2. Sustituir `MockChatService` por cliente real sobre core C++
3. Conectar `ChatCoreBridge` con sesiones/canales reales del core
