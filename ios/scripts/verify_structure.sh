#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

required_paths=(
  "project.yml"
  "README.md"
  "Docs/XCODE_SETUP.md"
  "Docs/IOS_MVP_STATUS.md"
  "scripts/generate_project.sh"
  "scripts/verify_structure.sh"
  "ChatterinoIOS/ChatterinoIOSApp.swift"
  "ChatterinoIOS/AppViewModel.swift"
  "ChatterinoIOS/Services/AuthService.swift"
  "ChatterinoIOS/Services/ChatService.swift"
  "ChatterinoIOS/Services/ServiceFactory.swift"
  "Bridge/ChatCoreBridgeC.h"
  "Bridge/ChatCoreBridgeC.mm"
)

for p in "${required_paths[@]}"; do
  if [[ ! -e "$p" ]]; then
    echo "❌ Falta: $p" >&2
    exit 1
  fi
done

echo "✅ Estructura iOS MVP verificada"
