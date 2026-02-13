#!/usr/bin/env bash
set -euo pipefail

echo "== iPhone devices (UDID) =="
xcrun xctrace list devices | sed -n '1,200p'

echo ""
echo "== Teams conocidas por Xcode (si existen) =="
defaults read com.apple.dt.Xcode IDEProvisioningTeamNameToTeamIDPreferences 2>/dev/null || echo "No teams cacheadas aún. Abre Xcode y asigna Team una vez."

echo ""
echo "Tip: usa BUNDLE_ID como com.tunombre.chatterinoios"
