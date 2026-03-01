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

# Hooks
cp -r hooks/ ~/.claude/hooks/
chmod +x ~/.claude/hooks/session-start.sh
```

## Step 3: Customize CLAUDE.md

Open `~/.claude/CLAUDE.md` and:

1. **Set your language** (line 5): `English`, `Deutsch`, or any language
2. **Review routing rules**: Adjust keywords that match your vocabulary
3. **Add your domain skills** later as you need them

## Step 4: Fill Your Memory

```bash
# Rename example files
cd ~/.claude/memory
mv glossary.md.example glossary.md
mv context/company.md.example context/company.md
```

Edit `context/company.md` with your role and company info.

## Step 5: Test It

```bash
# Start Claude Code
claude

# Try these:
# "Note: Check out the new Rust async features"     → should invoke capture
# "Summarize the key points of our discussion"       → should invoke distill
# "Write a brief summary of what we discussed"       → should invoke express
# "Is this analysis solid?"                          → should invoke signal-check
# "Save the session state"                           → should invoke handoff
```

## Step 6 (Optional): Connect Obsidian

See [Obsidian Setup](../obsidian/README.md) for connecting your vault.

## Step 7 (Optional): Set Up Knowledge DB

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
