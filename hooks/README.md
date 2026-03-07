# Hooks

Hooks run automatically at specific points in the Claude Code lifecycle.

## Available Hooks

### `session-start.sh`
Runs at the beginning of every Claude Code session. Injects minimal context as a system message so Claude knows who you are and what tools are available.

### `context-reinject.md`
Core rules that survive context window compression. When Claude's context gets compacted during long sessions, these rules are re-injected to maintain consistent behavior.

## Setup

### 1. Copy Files

```bash
cp hooks/session-start.sh.example ~/.claude/hooks/session-start.sh
cp hooks/context-reinject.md.example ~/.claude/hooks/context-reinject.md
chmod +x ~/.claude/hooks/session-start.sh
```

### 2. Wire Hooks in Claude Code

Copy the example settings file, or add to your existing `.claude/settings.json`:

```bash
# If you don't have a settings.json yet:
cp hooks/settings.json.example ~/.claude/settings.json

# If you already have one, merge the "hooks" section manually.
```

The settings should contain:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "type": "command",
        "command": "bash ~/.claude/hooks/session-start.sh"
      }
    ]
  }
}
```

> **Note:** Hook support depends on your Claude Code version. Check `claude --help` or the [Claude Code docs](https://docs.anthropic.com/en/docs/claude-code) for the latest hook configuration format.

### 3. Customize

Edit `session-start.sh` to include:
- Your name and role
- Available skills
- Key file paths
- Current project context
