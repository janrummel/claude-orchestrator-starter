# Getting Started

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and authenticated
- A terminal (macOS, Linux, or WSL)
- ~10 minutes

## Step 1: Clone the Repo

```bash
git clone https://github.com/janrummel/claude-orchestrator-starter.git
cd claude-orchestrator-starter
```

## Step 2: Copy Core Files

```bash
# The orchestrator brain
cp CLAUDE.md.example ~/.claude/CLAUDE.md

# Skills
cp -r orchestrator/ ~/.claude/orchestrator/

# Memory templates
cp -r memory/ ~/.claude/memory/

# Create the projects directory
mkdir -p ~/.claude/orchestrator/projects
```

## Step 3: Set Up Hooks

Hooks give Claude context awareness: a statusbar showing context usage, automatic warnings when context gets low, and smart session start with project context injection.

```bash
# Copy hook files
cp hooks/session-start.sh.example ~/.claude/hooks/session-start.sh
cp hooks/context-monitor.js ~/.claude/hooks/context-monitor.js
cp hooks/context-statusline.js ~/.claude/hooks/context-statusline.js
cp hooks/session-end.js ~/.claude/hooks/session-end.js
cp hooks/context-reinject.md.example ~/.claude/hooks/context-reinject.md
chmod +x ~/.claude/hooks/session-start.sh
```

Then configure Claude Code to use them. If you don't have a `settings.json` yet:

```bash
cp hooks/settings.json.example ~/.claude/settings.json
```

If you already have one, merge the `hooks` and `statusLine` sections from `settings.json.example` into yours.

### Optional: Install claude-loop

`claude-loop` keeps you in the same terminal when context fills up — no more opening new windows.

```bash
# Put it somewhere on your PATH
cp hooks/claude-loop.sh ~/.local/bin/claude-loop
chmod +x ~/.local/bin/claude-loop
```

## Step 4: Customize

### session-start.sh

Edit `~/.claude/hooks/session-start.sh` and set:
- `USER_NAME` — your name
- `USER_ROLE` — your role (e.g., "Engineer", "Researcher")
- `USER_INDUSTRY` — your domain (e.g., "E-Mobility", "Biotech")
- `SKILLS` — list of your installed skills

### CLAUDE.md

Open `~/.claude/CLAUDE.md` and:
1. **Set your language** (line 5): `English`, `Deutsch`, or any language
2. **Review routing rules**: Adjust keywords that match your vocabulary
3. **Add your domain skills** later as you need them

## Step 5: Fill Your Memory

```bash
# Rename example files
cd ~/.claude/memory
mv glossary.md.example glossary.md
mv context/company.md.example context/company.md
```

Edit `context/company.md` with your role and company info.

## Step 6: Test It

```bash
# Start Claude Code (or use claude-loop for session chaining)
claude-loop

# Try these:
# "Note: Check out the new Rust async features"     → should invoke capture
# "Summarize the key points of our discussion"       → should invoke distill
# "Write a brief summary of what we discussed"       → should invoke express
# "Is this analysis solid?"                          → should invoke signal-check
# "Save the session state"                           → should invoke handoff
```

You should see a statusbar at the bottom showing the model name, directory, and a context usage bar.

### Test session chaining

1. Work in a long session until context usage climbs
2. At 75% (WARNING): Claude will tell you context is getting low
3. At 65% remaining (CRITICAL): Claude will save a handoff file automatically
4. When the session ends, `claude-loop` asks: "Start new session with context? [Y/n]"
5. Press Y — the new session picks up where you left off

## Step 7 (Optional): Connect Obsidian

See [Obsidian Setup](../obsidian/README.md) for connecting your vault.

## Step 8 (Optional): Set Up Knowledge DB

```bash
mkdir -p ~/.claude/data
sqlite3 ~/.claude/data/knowledge.db < knowledge-db/schema.sql
```

## What's Next?

1. **Use it daily** — the system improves as you use it
2. **Check routing log** — see `~/.claude/orchestrator/routing-log.jsonl`
3. **Add skills** — see [Skill Development Guide](skill-development.md)
4. **Update patterns** — edit `user-patterns.md` when routing is wrong
5. **Customize chains** — edit `workflow-templates.md` for your workflows
