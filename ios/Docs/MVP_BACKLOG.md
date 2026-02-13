# iOS MVP Backlog

## Sprint 0 (hecho)
- [x] Shell SwiftUI
- [x] Navegación Login -> Channels -> Chat
- [x] Capa de servicios (auth/chat) desacoplada
- [x] Persistencia de sesión mock en Keychain
- [x] Bridge C++/ObjC++ placeholder
- [x] Configuración XcodeGen (`project.yml`)

## Sprint 1 (en curso)
- [ ] OAuth Twitch login real
- [ ] Persistencia segura token real (refresh)
- [ ] Estado de sesión en bridge

## Sprint 2
- [ ] Lista de canales real
- [ ] Entrada a canal
- [ ] Mensajes en tiempo real (lectura)

## Sprint 3
- [ ] Envío de mensaje real
- [ ] Emotes básicos
- [ ] Errores/red/reconexión mínima

## Definition of Done MVP
- Login real
- Abrir al menos 1 canal y leer chat en vivo
- Enviar mensajes
- Build estable en iPhone físico (TestFlight interno)
