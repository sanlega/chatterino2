#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "error: xcodegen no está instalado. Ejecuta: brew install xcodegen" >&2
  exit 1
fi

# Limpieza de rutas antiguas erróneas
rm -rf ChatterinoIOS/ChatterinoIOS.xcodeproj ChatterinoIOS.xcodeproj

# Genera el .xcodeproj en la raíz de ios/
xcodegen generate --spec project.yml --project .

echo "✅ Proyecto generado: $ROOT_DIR/ChatterinoIOS.xcodeproj"
