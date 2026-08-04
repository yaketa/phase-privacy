#!/bin/bash
# Replace the PHASE_SUPPORT_EMAIL placeholder everywhere it appears — the four
# published pages here, and the Settings › About row in the app.
#
#   ./set-support-email.sh phase.app.support@gmail.com
#
# Then commit and push this repo (GitHub Pages redeploys on push), and commit
# the app change in ../time-memo.
set -euo pipefail

EMAIL=${1:-}
if [[ ! "$EMAIL" =~ ^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$ ]]; then
  echo "usage: $0 <address>    (got: '${EMAIL}')" >&2
  exit 2
fi

SITE=$(cd "$(dirname "$0")" && pwd)
APP="$SITE/../time-memo/TimeMemo/Features/Settings/SettingsListView.swift"

files=("$SITE/index.html" "$SITE/support.html" "$SITE/ja/index.html" "$SITE/ja/support.html")
[ -f "$APP" ] && files+=("$APP") || echo "note: $APP not found — skipping the app" >&2

before=0
for f in "${files[@]}"; do
  n=$(grep -o "PHASE_SUPPORT_EMAIL" "$f" | wc -l | tr -d ' ')
  before=$((before + n))
  [ "$n" -gt 0 ] && sed -i '' "s/PHASE_SUPPORT_EMAIL/$EMAIL/g" "$f"
  printf "  %-52s %s\n" "$(basename "$(dirname "$f")")/$(basename "$f")" "$n"
done

echo "replaced $before occurrence(s) with $EMAIL"
[ "$before" -eq 0 ] && echo "nothing to do — already replaced?" >&2
exit 0
