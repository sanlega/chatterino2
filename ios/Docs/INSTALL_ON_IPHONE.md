# Instalar versión de prueba en iPhone

## Ruta A (rápida): instalación directa con Xcode (cuenta Apple gratuita)

Requisitos:
- Mac con Xcode
- iPhone conectado por cable
- Apple ID logueado en Xcode

Pasos:
1. `cd ios && ./scripts/generate_project.sh`
2. Abrir `ChatterinoIOS.xcodeproj`
3. En target `ChatterinoIOS`:
   - `Signing & Capabilities` -> seleccionar tu Team
   - Cambiar bundle id si hace falta (ej: `com.tunombre.chatterinoios`)
4. Seleccionar tu iPhone como destino
5. Build & Run (⌘R)
6. En iPhone, confiar certificado de desarrollador si lo pide

Resultado: app instalada para pruebas locales.

---

## Ruta B: TestFlight (más limpia para iterar)

Requisitos:
- Cuenta Apple Developer (de pago)
- App Store Connect configurado

Pasos:
1. Configurar firma y provisioning
2. Archivar app (`Product > Archive`)
3. Subir a App Store Connect
4. Añadir testers en TestFlight
5. Instalar desde TestFlight en iPhone

---

## Config de servicios

- Debug usa mock (`USE_MOCK_SERVICES`)
- Release usa real (`USE_REAL_SERVICES`)

Para pruebas funcionales reales debes completar OAuth y chat real.
