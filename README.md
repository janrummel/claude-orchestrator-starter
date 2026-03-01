# Claude Orchestrator Starter Kit

> Turn Claude Code into a personal AI assistant — with persistent memory, custom skills, and Obsidian as your second brain.

**[Deutsche Version](README.de.md)**

## What is this?

This is a starter kit for building a **personal orchestrator** on top of [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Instead of using Claude as a stateless chatbot, this system gives it:

- **Memory** that persists across sessions (short-term, mid-term, long-term)
- **Skills** — reusable workflows invoked by natural language or `/commands`
- **Routing** — automatic detection of which skill fits your request
- **Obsidian integration** — your notes become Claude's knowledge base

```
┌─────────────────────────────────────────────────┐
│  SHORT-TERM (Context Window)                    │
│  Current conversation, temporary results        │
│  Lifetime: 1 session                            │
├─────────────────────────────────────────────────┤
│  MID-TERM (Episodic Memory + State Files)       │
│  Past sessions, routing decisions, handoffs     │
│  Lifetime: weeks to months                      │
├─────────────────────────────────────────────────┤
│  LONG-TERM (CLAUDE.md + Knowledge Base)         │
│  Routing rules, preferences, glossary,          │
│  company context, project docs                  │
│  Lifetime: permanent                            │
└─────────────────────────────────────────────────┘
```

## Quick Start (5 minutes)

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and working
- A terminal

### Setup

```bash
# 1. Clone this repo
git clone https://github.com/janrummel/claude-orchestrator-starter.git
cd claude-orchestrator-starter

# 2. Copy the orchestrator to your Claude config
cp CLAUDE.md.example ~/.claude/CLAUDE.md
cp -r orchestrator/ ~/.claude/orchestrator/
cp -r memory/ ~/.claude/memory/
cp -r hooks/ ~/.claude/hooks/

# 3. Start Claude Code — done.
claude
```

Claude will now:
- Read `CLAUDE.md` at startup and understand its role
- Route your requests to matching skills
- Use the memory system to remember context across sessions

### Optional: Obsidian Integration

If you use [Obsidian](https://obsidian.md) as your note-taking app, see [Obsidian Setup](docs/obsidian-setup.md) for connecting your vault as Claude's knowledge base.

### Optional: Knowledge Database

For structured data storage (research items, imported datasets), see [Knowledge DB Setup](docs/knowledge-db-setup.md).

## Architecture

### The Three Layers

| Layer | What | Where | Lifetime |
|-------|------|-------|----------|
| **Short-term** | Current conversation | Context window | 1 session |
| **Mid-term** | Past sessions, routing log | `orchestrator/routing-log.jsonl`, episodic memory | Weeks–months |
| **Long-term** | Rules, preferences, knowledge | `CLAUDE.md`, `memory/`, Obsidian | Permanent |

### Skills

Skills are reusable workflows defined as `SKILL.md` files. Each skill tells Claude **how** to handle a specific type of request.

This starter kit includes 6 core skills:

| Skill | Purpose | Trigger examples |
|-------|---------|-----------------|
| `capture` | Quick note-taking into Obsidian | "Note this", "Save this idea" |
| `distill` | Summarize and condense information | "Summarize", "Key takeaways" |
| `express` | Write polished output | "Write", "Draft", "Formulate" |
| `analyze` | Deep analysis with structured thinking | "Analyze", "Investigate" |
| `signal-check` | Quality check / fact check | "Is this solid?", "Quality check" |
| `handoff` | Save session state for next time | "Save state", "Handoff" |

These 6 form two key loops:

**Evaluator-Optimizer Loop:**
```
express → signal-check → express (improved)
```

**Knowledge Cycle:**
```
capture → distill → express → signal-check
    ↑                              │
    └──── analyze ← handoff ←─────┘
```

### Routing

The `CLAUDE.md` file contains routing rules that map keywords to skills. When you say something, Claude checks for matching patterns and invokes the right skill automatically.

Example:
- "Summarize this article" → matches "summarize" → invokes `distill`
- "Is this analysis solid?" → matches "quality check" → invokes `signal-check`

### Memory

The `memory/` directory provides long-term storage:

```
memory/
├── glossary.md          — Domain terms and jargon
├── context/
│   └── company.md       — Your work context (role, company, tools)
├── people/              — Key contacts and stakeholders
├── projects/            — Active project documentation
├── decisions/           — Decision log with rationale
└── workflows/           — Proven workflows and best practices
```

## Developing Your Own Skills

See [Skill Development Guide](docs/skill-development.md) for a step-by-step guide to creating custom skills.

The short version:

```bash
# 1. Create a skill directory
mkdir -p ~/.claude/orchestrator/skills/my-skill

# 2. Write the SKILL.md
cat > ~/.claude/orchestrator/skills/my-skill/SKILL.md << 'EOF'
---
name: my-skill
description: What this skill does and when to use it.
---

# My Skill

Instructions for Claude on how to execute this skill.

## Workflow
1. Step one
2. Step two
3. Step three
EOF

# 3. Add routing rules to CLAUDE.md
# Add keyword → skill mapping to the routing table
```

## What's NOT Included

This is a **starter kit**, not a complete system. You'll want to:

- Add skills specific to your domain (engineering, sales, research, etc.)
- Customize routing rules for your vocabulary
- Fill in your company context, glossary, and contacts
- Adjust the output language (this kit defaults to English)
- Connect your Obsidian vault(s) if you use Obsidian

## Inspiration

This starter kit is based on a real-world system built for daily use in engineering, research, and knowledge management. The full system includes 20+ custom skills, 6 connected Obsidian vaults, a SQLite knowledge database, and automated session handoffs.

## License

MIT — use it, fork it, make it yours.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).
