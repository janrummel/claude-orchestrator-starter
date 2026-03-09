# Hooks

Hooks run automatically at specific points in the Claude Code lifecycle. Together they solve the **context-full problem**: when a session's context window fills up, your state is saved automatically and the next session picks up where you left off.

## The Flow

```
context-statusline.js          (shows context usage in statusbar)
        ↓ writes metrics
context-monitor.js             (warns at 45%, triggers handoff at 35%)
        ↓ tells Claude to save state
~/.claude/orchestrator/last-session.md   (handoff file)
        ↓ session ends
claude-loop.sh                 (offers to start new session)
        ↓ new session starts
session-start.sh               (reads handoff → injects as context)
        ↓
Claude knows where you left off
        ↓ session ends (any reason)
session-end.js                 (saves summary if no recent handoff exists)
```

## Files

### `context-statusline.js`
Statusline showing model, directory, and context usage as a color-coded progress bar. Also writes a bridge file to `/tmp/` so the context monitor can read metrics.

### `context-monitor.js`
PostToolUse hook that watches context usage:
- **WARNING (35% remaining):** Tells Claude to wrap up the current task
- **CRITICAL (25% remaining):** Instructs Claude to write a session handoff file with current task, progress, decisions, and next steps

Includes debounce (5 tool calls between warnings) to avoid spam.

### `session-start.sh`
Runs at session start. Checks for:
1. A recent handoff file → injects saved state so Claude continues seamlessly
2. An active project file → injects project context

The handoff file is auto-consumed (renamed) after injection so it doesn't repeat.

### `claude-loop.sh`
Wrapper script that keeps you in the same terminal:
- Runs `claude` with your arguments
- When the session ends, checks for a handoff file
- If handoff exists: offers to start a fresh session (state injected via hooks)
- If no handoff: offers to `--continue` the previous session

### `session-end.js`
Stop hook that saves a brief session summary when Claude stops — whether by `/exit`, Ctrl-C, or task completion. Skips writing if a recent handoff from context-monitor already exists (avoids overwriting richer context).

### `context-reinject.md`
Core rules that survive context window compression during long sessions.

## Setup

### 1. Copy files

```bash
# Hooks
cp hooks/session-start.sh.example ~/.claude/hooks/session-start.sh
cp hooks/context-monitor.js ~/.claude/hooks/context-monitor.js
cp hooks/context-statusline.js ~/.claude/hooks/context-statusline.js
cp hooks/context-reinject.md.example ~/.claude/hooks/context-reinject.md
chmod +x ~/.claude/hooks/session-start.sh

# Wrapper script (put it somewhere on your PATH)
cp hooks/claude-loop.sh ~/.local/bin/claude-loop
chmod +x ~/.local/bin/claude-loop
```

### 2. Configure Claude Code

Copy the settings example, or merge into your existing `~/.claude/settings.json`:

```bash
# If you don't have settings.json yet:
cp hooks/settings.json.example ~/.claude/settings.json

# If you already have one, add the hooks and statusLine sections.
```

### 3. Customize

Edit `session-start.sh`:
- Set `USER_NAME`, `USER_ROLE`, `USER_INDUSTRY`
- Adjust `SKILLS` to match your installed skills

### 4. Create the orchestrator directory

```bash
mkdir -p ~/.claude/orchestrator/projects
```

### 5. Use it

```bash
# Instead of `claude`, use:
claude-loop

# Or with arguments:
claude-loop -p "continue with the refactoring"
```

When context fills up, Claude saves state automatically. Press `Y` to start a fresh session — it picks up where you left off.

## Thresholds

You can adjust these in `context-monitor.js`:

| Setting | Default | Purpose |
|---------|---------|---------|
| `WARNING_THRESHOLD` | 45% remaining (~55% used) | Start wrapping up |
| `CRITICAL_THRESHOLD` | 35% remaining (~65% used) | Save state, inform user |
| `DEBOUNCE_CALLS` | 5 | Tool calls between warnings |
| `HANDOFF_MAX_AGE` | 3600s | Ignore stale handoff files |
