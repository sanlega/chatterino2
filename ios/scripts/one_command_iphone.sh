#!/usr/bin/env bash
set -euo pipefail

# Uso rápido:
#   ./ios/scripts/one_command_iphone.sh
#
# Opcional (para build CLI firmado en dispositivo, sin abrir Xcode):
#   DEVELOPMENT_TEAM=TU_TEAM_ID DEVICE_UDID=tu_udid BUNDLE_ID=com.tu.bundle ./ios/scripts/one_command_iphone.sh

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[1/6] Verificando herramientas..."
if ! command -v brew >/dev/null 2>&1; then
  echo "error: Homebrew no encontrado. Instálalo primero: https://brew.sh"
  exit 1
fi
if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "error: Xcode CLI tools no disponibles. Abre Xcode una vez y acepta licencia."
  exit 1
fi

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "[2/6] Instalando xcodegen..."
  brew install xcodegen
else
  echo "[2/6] xcodegen OK"
fi

echo "[3/6] Generando proyecto..."
./scripts/generate_project.sh

echo "[4/6] Verificando estructura..."
./scripts/verify_structure.sh

if [[ -f "ChatterinoIOS/Config.example.xcconfig" && ! -f "ChatterinoIOS/Config.xcconfig" ]]; then
  echo "[5/6] Creando Config.xcconfig desde ejemplo..."
  cp "ChatterinoIOS/Config.example.xcconfig" "ChatterinoIOS/Config.xcconfig"
fi

if [[ -n "${BUNDLE_ID:-}" ]]; then
  echo "[5/6] Ajustando bundle id en project.yml -> ${BUNDLE_ID}"
  perl -0777 -i -pe 's/PRODUCT_BUNDLE_IDENTIFIER:\s*[^\n]+/PRODUCT_BUNDLE_IDENTIFIER: '"${BUNDLE_ID}"'/g' project.yml
  ./scripts/generate_project.sh
fi

if [[ -n "${DEVELOPMENT_TEAM:-}" && -n "${DEVICE_UDID:-}" ]]; then
  echo "[6/6] Intentando build firmado para iPhone (${DEVICE_UDID})..."
  xcodebuild \
    -project ChatterinoIOS.xcodeproj \
    -scheme ChatterinoIOS \
    -configuration Debug \
    -destination "id=${DEVICE_UDID}" \
    DEVELOPMENT_TEAM="${DEVELOPMENT_TEAM}" \
    CODE_SIGN_STYLE=Automatic \
    -allowProvisioningUpdates \
    build

  echo "✅ Build completada para dispositivo."
  echo "Si no se instaló automáticamente, abre Xcode y pulsa Run con el iPhone seleccionado."
else
  echo "[6/6] Abriendo proyecto en Xcode para instalación en iPhone..."
  open ChatterinoIOS.xcodeproj
  cat <<'EOF'

Listo.
En Xcode:
1) Target ChatterinoIOS > Signing & Capabilities > Team
2) Selecciona tu iPhone
3) Run (⌘R)

Para modo totalmente CLI la próxima vez:
DEVELOPMENT_TEAM=TU_TEAM_ID DEVICE_UDID=TU_UDID BUNDLE_ID=com.tu.bundle ./ios/scripts/one_command_iphone.sh
EOF
fi
