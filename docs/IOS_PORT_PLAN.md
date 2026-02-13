# Plan de port de Chatterino2 a iOS

## 0) Diagnóstico rápido (hecho)

Estado actual del repo:
- Stack principal: **Qt 6 + Widgets** (desktop-first).
- Entrada GUI: `src/main.cpp` usa `QApplication`.
- Dependencias de UI desktop repartidas en `src/widgets/**`, hotkeys y ventanas múltiples.
- Build docs oficiales: Windows/Linux/macOS/FreeBSD (sin flujo iOS documentado).

Referencias:
- `CMakeLists.txt` (usa `Qt::Widgets`)
- `src/main.cpp` (`QApplication`)
- `src/widgets/**`
- `BUILDING_ON_MAC.md`

---

## 1) Objetivo del port (definir alcance)

**MVP iOS (v1):**
1. Login Twitch
2. Lista de canales + abrir chat
3. Lectura y envío de mensajes
4. Emotes principales (Twitch/BTTV/FFZ/7TV, según viabilidad)
5. Notificaciones básicas

**Fuera de MVP:**
- Multi-ventana avanzada estilo desktop
- Hotkeys desktop
- Plugins alpha completos
- Features de moderación más complejas

---

## 2) Decisión técnica clave (arquitectura)

### Opción A — Recomendación
**Reutilizar núcleo C++ (providers/controllers/messages/common) + UI nativa iOS (SwiftUI).**

Ventajas:
- Mejor UX iOS (gestos, accesibilidad, navegación nativa)
- Mejor encaje App Store
- Menos fricción que intentar portar una UI Widgets desktop 1:1

Coste:
- Hay que construir un puente C++ ↔ Swift (Objective-C++ wrapper)

### Opción B
Rehacer UI con Qt Quick/QML para iOS y mantener Qt en todo.

Ventajas:
- Más homogéneo con C++

Riesgos:
- Migración grande desde Widgets a QML
- UX iOS suele quedar menos nativa

---

## 3) Fase 1 — Auditoría y extracción de núcleo (2-3 semanas)

1. Mapear qué módulos son realmente UI-dependientes.
2. Definir capa `Core` sin `QWidget/QApplication` acoplado.
3. Extraer casos de uso:
   - auth/session
   - conexión chat
   - parse/render model de mensajes
   - envío de mensaje
4. Crear contratos de interfaz para:
   - navegación
   - notificaciones
   - almacenamiento seguro

**Entregable:** diagrama de módulos + librería core compilable sin UI desktop.

---

## 4) Fase 2 — Bootstrap iOS (1-2 semanas)

1. Crear workspace Xcode (`ios/`): app SwiftUI + target puente ObjC++.
2. Integrar core C++ como static lib/framework.
3. CI inicial para build iOS (GitHub Actions + macOS runner).
4. Setup firma, bundle ID y entornos (dev/test/prod).

**Entregable:** app iOS arranca, conecta core y muestra estado de sesión.

---

## 5) Fase 3 — MVP funcional (4-6 semanas)

1. Login OAuth Twitch en iOS
2. Lista de canales/favoritos
3. Vista de chat (paginación + actualización en vivo)
4. Envío de mensaje
5. Render inicial de emotes y badges
6. Persistencia local mínima (cuentas + preferencias básicas)

**Entregable:** TestFlight interno utilizable diariamente.

---

## 6) Fase 4 — Calidad de producto (3-5 semanas)

1. Reconexión robusta y manejo de red móvil
2. Rendimiento (scroll largo, memoria, CPU/batería)
3. Push/local notifications
4. Accesibilidad (Dynamic Type, VoiceOver)
5. Crash reporting + métricas

**Entregable:** beta cerrada estable.

---

## 7) Fase 5 — Publicación (1-2 semanas)

1. Revisión legal (marca/branding, ToS API Twitch, licencias OSS)
2. Material App Store (capturas, privacidad, texto)
3. App Review + plan de hotfix

**Entregable:** release App Store.

---

## 8) Riesgos principales

1. **UI actual desktop-heavy (Qt Widgets)**
2. Integración iOS de ciertas dependencias/SDKs
3. Cumplimiento de políticas App Store/Twitch
4. Rendimiento en chats muy activos

Mitigación:
- Scope estricto de MVP
- Reutilizar solo core sólido
- UI iOS nativa desde el inicio

---

## 9) Equipo mínimo recomendado

- 1 dev C++/arquitectura (core)
- 1 dev iOS SwiftUI
- 0.5 QA/automatización

Tiempo estimado realista para MVP: **8-12 semanas**.
Tiempo hasta App Store pulida: **12-16 semanas**.

---

## 10) Próximo paso inmediato

Crear issue/epic en el repo con 3 tracks:
1. `core-extraction`
2. `ios-shell-swiftui`
3. `mvp-chat-flow`

y arrancar con un spike técnico de 1 semana para validar puente C++ ↔ Swift.
