# Hooks

Hooks run automatically at specific points in the Claude Code lifecycle.

## Available Hooks

### `session-start.sh`
Runs at the beginning of every Claude Code session. Injects minimal context as a system message so Claude knows who you are and what tools are available.

### `context-reinject.md`
Core rules that survive context window compression. When Claude's context gets compacted during long sessions, these rules are re-injected to maintain consistent behavior.

## Setup

Copy the example files (remove `.example` suffix):

```bash
cp hooks/session-start.sh.example ~/.claude/hooks/session-start.sh
cp hooks/context-reinject.md.example ~/.claude/hooks/context-reinject.md
chmod +x ~/.claude/hooks/session-start.sh
```

## Customization

Edit `session-start.sh` to include:
- Your name and role
- Available skills
- Key file paths
- Current project context
