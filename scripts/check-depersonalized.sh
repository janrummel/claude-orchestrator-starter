#!/usr/bin/env bash
# Scans tracked files for personal identifiers. The blocklist lives OUTSIDE
# the repo on purpose: the terms themselves must never be committed.
set -u
cd "$(dirname "$0")/.."
BLOCKLIST="${AGENT_KIT_BLOCKLIST:-$HOME/.config/agent-kit-blocklist.txt}"

if [ ! -f "$BLOCKLIST" ]; then
  echo "check-depersonalized: blocklist not found at $BLOCKLIST"
  echo "Create it with one personal term per line (names, employer, hostnames, vault names, private project names)."
  exit 2
fi

ALLOW="scripts/depersonalized-allow.txt"
fail=0
while IFS= read -r term; do
  [ -z "$term" ] && continue
  case "$term" in \#*) continue ;; esac
  # Text matching a pattern in scripts/depersonalized-allow.txt is public on purpose
  # (the owner's name in repo URLs, licence, author credit). Only the matched text is
  # removed; the rest of the line is still scanned, so a name next to an allowed URL
  # is still caught.
  hits=$(git ls-files -c -o --exclude-standard -z -- . ":!$ALLOW" | xargs -0 grep -n -i -H -- "$term" 2>/dev/null \
    | { if [ -s "$ALLOW" ]; then sed -E "$(sed 's|.*|s#&##g|' "$ALLOW")"; else cat; fi; } \
    | grep -i -- "$term" | cut -d: -f1 | sort -u)
  if [ -n "$hits" ]; then
    echo "PERSONAL TERM FOUND (from blocklist) in:"
    echo "$hits"
    fail=1
  fi
done < "$BLOCKLIST"

if [ "$fail" -eq 0 ]; then echo "check-depersonalized: OK"; else echo "check-depersonalized: FAIL"; fi
exit "$fail"
