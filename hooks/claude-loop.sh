#!/bin/bash
# claude-loop — Seamless CLI session chaining
#
# Runs Claude Code and automatically offers to chain sessions when one ends.
# No more opening new terminals when context fills up.
#
# How it works:
#   1. Runs `claude` with your arguments
#   2. When the session ends, checks if a handoff file was saved
#   3. If yes: offers to start a fresh session (hooks inject saved state)
#   4. If no:  offers to --continue the previous session
#
# Usage:
#   claude-loop                    # start a new session
#   claude-loop --continue         # continue last session
#   claude-loop -p "fix the bug"   # start with a prompt
#
# Install:
#   cp hooks/claude-loop.sh ~/.local/bin/claude-loop
#   chmod +x ~/.local/bin/claude-loop

set -euo pipefail

HANDOFF_FILE="${HOME}/.claude/orchestrator/last-session.md"
HANDOFF_MAX_AGE=3600  # seconds — ignore handoff files older than 1 hour

# --- Helpers ---

is_recent_handoff() {
  [[ -f "$HANDOFF_FILE" ]] || return 1

  local now file_mtime file_age
  now=$(date +%s)

  # macOS uses -f%m, Linux uses -c%Y
  if [[ "$(uname)" == "Darwin" ]]; then
    file_mtime=$(stat -f%m "$HANDOFF_FILE" 2>/dev/null) || return 1
  else
    file_mtime=$(stat -c%Y "$HANDOFF_FILE" 2>/dev/null) || return 1
  fi

  file_age=$((now - file_mtime))
  [[ $file_age -lt $HANDOFF_MAX_AGE ]]
}

mark_handoff_consumed() {
  if [[ -f "$HANDOFF_FILE" ]]; then
    mv "$HANDOFF_FILE" "${HANDOFF_FILE%.md}.consumed.md" 2>/dev/null || true
  fi
}

print_separator() {
  printf '\n\033[2m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n'
}

# --- Main loop ---

ARGS=("$@")

while true; do
  # Run Claude Code
  claude "${ARGS[@]}" || true

  print_separator

  if is_recent_handoff; then
    echo "Session state saved. Start new session with context? [Y/n]"
    read -r answer </dev/tty
    if [[ "$answer" =~ ^[nN] ]]; then
      echo "State preserved in: $HANDOFF_FILE"
      break
    fi
    # Mark as consumed so session-start can detect it was used
    # (the hook reads it before we mark it)
    ARGS=()  # Fresh session — session-start.sh will inject the handoff
  else
    echo "Session ended. Continue? [Y/n]"
    read -r answer </dev/tty
    if [[ "$answer" =~ ^[nN] ]]; then
      break
    fi
    ARGS=("--continue")  # Resume previous conversation
  fi
done
