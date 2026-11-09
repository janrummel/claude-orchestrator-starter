#!/usr/bin/env bash
# Repo self-check: required files exist, relative markdown links resolve.
set -u
cd "$(dirname "$0")/.."
fail=0

REQUIRED=(
  "README.md"
  "docs/index.html"
  "README.de.md"
  "START_HERE.md"
  "VALIDATION.md"
  "LICENSE"
  "CONTRIBUTING.md"
  "docs/rationale.md"
  "docs/evidence.md"
  "examples/first-session.md"
  "adapters/README.md"
  "adapters/codex/README.md"
  "STATE.md"
  "AGENTS.md.example"
  "docs/specs/2026-08-03-agnostic-starter-kit-design.md"
  "docs/portability.md"
  "core/memory/README.md"
  "core/memory/MEMORY.md.example"
  "core/memory/fact-file.md.template"
  "core/projects/README.md"
  "core/projects/STATE.md.template"
  "obsidian/README.md"
  "obsidian/mcp-config.json.example"
  "adapters/github-copilot/README.md"
  "adapters/github-copilot/mcp.json.example"
  "CLAUDE.md.example"
  "hooks/README.md"
  "docs/architecture.md"
  "docs/faq.md"
  "docs/skill-development.md"
  "docs/getting-started.md"
  "docs/og-image.png"
)

for f in "${REQUIRED[@]}"; do
  [ -e "$f" ] || { echo "MISSING: $f"; fail=1; }
done

# Relative link check: extract ](path) targets from all tracked .md files,
# skip fenced code blocks (```...```), skip http(s), mailto, and pure #anchors,
# strip #fragment, test existence relative to the linking file's directory.
# Fail closed: if mktemp itself fails we must not silently report OK. A guard that
# goes green when its own infrastructure breaks is worse than no guard.
linkfail_marker=$(mktemp -u) || { echo "check-kit: FAIL (mktemp unavailable)"; exit 1; }
[ -n "$linkfail_marker" ] || { echo "check-kit: FAIL (empty marker path)"; exit 1; }
while IFS= read -r file; do
  dir=$(dirname "$file")
  in_fence=0
  while IFS= read -r line; do
    case "$line" in
      \`\`\`*) in_fence=$((1 - in_fence)); continue ;;
    esac
    [ "$in_fence" -eq 1 ] && continue
    echo "$line"
  done < "$file" | grep -oE '\]\([^)]+\)' | sed -E 's/^\]\(//; s/\)$//' | while IFS= read -r target; do
    case "$target" in
      http://*|https://*|mailto:*|\#*) continue ;;
    esac
    path="${target%%#*}"
    [ -z "$path" ] && continue
    if [ ! -e "$dir/$path" ]; then
      echo "BROKEN LINK: $file -> $target"
      echo 1 > "$linkfail_marker"
    fi
  done
done < <(git ls-files -c -o --exclude-standard '*.md')

[ -f "$linkfail_marker" ] && { fail=1; rm -f "$linkfail_marker"; }

if [ "$fail" -eq 0 ]; then echo "check-kit: OK"; else echo "check-kit: FAIL"; fi
exit "$fail"
