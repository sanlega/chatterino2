# Chatterino iOS (MVP bootstrap)

Estado: **bootstrap inicial**.

## Objetivo de este bloque

- Crear shell iOS con SwiftUI
- Definir flujo base: Login -> Canales -> Chat
- Preparar puente C++/ObjC++ para conectar core en siguientes iteraciones

## Estructura

- `ChatterinoIOS/` app SwiftUI (pantallas + view model mock)
- `Bridge/` puente nativo (`ChatCoreBridge`) para conectar core C++
- `Docs/` tareas del MVP

## Siguiente paso inmediato

1. Crear proyecto Xcode y añadir estos archivos.
2. Conectar `ChatCoreBridge` a un primer caso real (estado de sesión).
3. Sustituir datos mock por servicio real de canales/chat.
