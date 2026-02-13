# Próximo bloque de ejecución (hasta app usable real)

## Objetivo
Que en iPhone se pueda: login real, abrir canal real, leer chat real, enviar mensaje real.

## Orden de trabajo

1. OAuth real Twitch (PKCE)
   - Implementar `TwitchOAuthService.signIn()` con `ASWebAuthenticationSession`
   - Guardar access token + refresh en Keychain

2. Cliente real de canales/chat
   - Sustituir `TwitchHelixChatService` placeholder por integración real
   - Conectar al bridge/core C++ para transporte chat

3. Wiring final Release
   - Validar `USE_REAL_SERVICES` en Release
   - Mantener Debug mock para iteración rápida

4. Prueba en dispositivo
   - Instalar por Ruta A (Xcode directo)
   - Verificar flujo completo en iPhone

5. Distribución
   - Si se quiere compartir testers: preparar TestFlight
