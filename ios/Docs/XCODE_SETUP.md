# Xcode setup (MVP)

## 1. Generar proyecto

```bash
cd ios
xcodegen generate
open ChatterinoIOS.xcodeproj
```

## 2. Añadir bridge C++

En el target `ChatterinoIOS`:
1. Add Files...
   - `../Bridge/ChatCoreBridgeC.h`
   - `../Bridge/ChatCoreBridgeC.mm`
2. Build Settings:
   - `Objective-C Bridging Header` -> `ChatterinoIOS/BridgingHeader.h`
3. Crear `ChatterinoIOS/BridgingHeader.h` con:

```objc
#include "../Bridge/ChatCoreBridgeC.h"
```

## 3. Config OAuth

1. Copiar `ChatterinoIOS/Config.example.xcconfig` -> `ChatterinoIOS/Config.xcconfig`
2. Rellenar `TWITCH_CLIENT_ID` y `TWITCH_REDIRECT_URI`
3. Asignar el `.xcconfig` al target/configuración.

## 4. Run

Seleccionar simulador iPhone y ejecutar.
