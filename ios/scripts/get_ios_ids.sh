#!/usr/bin/env bash
set -euo pipefail

echo "== iPhone devices (UDID) =="
if xcrun xctrace list devices >/dev/null 2>&1; then
  xcrun xctrace list devices | sed -n '1,200p'
elif xcrun devicectl list devices >/dev/null 2>&1; then
  xcrun devicectl list devices
else
  echo "No disponible xctrace/devicectl. Abre Xcode > Window > Devices and Simulators."
fi

echo ""
echo "== Teams conocidas por Xcode (si existen) =="
defaults read com.apple.dt.Xcode IDEProvisioningTeamNameToTeamIDPreferences 2>/dev/null || echo "No teams cacheadas aún. Abre Xcode y asigna Team una vez."

echo ""
echo "Tip: usa BUNDLE_ID como com.tunombre.chatterinoios"
