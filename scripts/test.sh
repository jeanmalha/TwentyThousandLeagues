#!/usr/bin/env bash
# Runs the GUT unit tests headless. Exits non-zero if any test fails.
# Set GODOT to your Godot 4.6.2 binary if it isn't on PATH as `godot`.
set -euo pipefail
cd "$(dirname "$0")/.."

GODOT="${GODOT:-}"
if [[ -z "$GODOT" ]]; then
  if command -v godot >/dev/null 2>&1; then GODOT=godot
  elif [[ -x /Applications/Godot.app/Contents/MacOS/Godot ]]; then GODOT=/Applications/Godot.app/Contents/MacOS/Godot
  else echo "Godot not found: set GODOT=/path/to/godot" >&2; exit 2; fi
fi

# Import first so a fresh clone (no .godot/ folder) has class names and resources.
"$GODOT" --headless --path . --import >/dev/null 2>&1 || true
"$GODOT" --headless --path . -s res://addons/gut/gut_cmdln.gd -gconfig=res://.gutconfig.json "$@"
