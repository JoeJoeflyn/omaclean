#!/bin/bash
# omaClean indicator setup — adds CleanKbd to your indicators widget
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "$0")" && pwd)"
INDICATORS_DIR="$HOME/.config/omarchy/plugins/giogio.indicators"

# Step 1: Clone omarchy.indicators if not already cloned
if [[ ! -d "$INDICATORS_DIR" ]]; then
  echo "Cloning omarchy.indicators..."
  omarchy plugin clone omarchy.indicators
fi

# Step 2: Copy CleanKbd.qml into the indicators
cp "$PLUGIN_DIR/CleanKbd.qml" "$INDICATORS_DIR/indicators/CleanKbd.qml"
echo "Added CleanKbd.qml to indicators"

# Step 3: Add CleanKbd to defaultIndicatorEntries in Indicators.qml
if ! grep -q '"CleanKbd"' "$INDICATORS_DIR/Indicators.qml"; then
  sed -i 's/"StayAwake" ]/"StayAwake", "CleanKbd" ]/' "$INDICATORS_DIR/Indicators.qml"
  echo "Added CleanKbd to Indicators.qml"
fi

# Step 4: Add CleanKbd to manifest options
python3 -c "
import json
with open('$INDICATORS_DIR/manifest.json') as f:
    m = json.load(f)
opts = m['barWidget']['schema'][0]['options']
if not any(o['value'] == 'CleanKbd' for o in opts):
    opts.append({'value': 'CleanKbd', 'label': 'Clean keyboard', 'description': 'Lock keyboard for cleaning'})
    with open('$INDICATORS_DIR/manifest.json', 'w') as f:
        json.dump(m, f, indent=2)
    print('Added CleanKbd to manifest')
"

# Step 5: Enable service and restart
omarchy plugin enable omaclean 2>/dev/null || true
omarchy restart shell
echo ""
echo "Done! Hover the center bar section to see the keyboard icon beside NightLight and StayAwake."
echo "Click it to lock the keyboard, click again to unlock."
