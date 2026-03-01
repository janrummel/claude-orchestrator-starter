# Architecture

## The Three-Layer Memory Model

The orchestrator uses three memory layers with different lifetimes:

```
┌─────────────────────────────────────────────────┐
│  SHORT-TERM (Context Window)                    │
│                                                 │
│  What: Current conversation, temporary results  │
│  Where: Claude's context window                 │
│  Lifetime: 1 session                            │
│  Size: ~200K tokens                             │
├─────────────────────────────────────────────────┤
│  MID-TERM (State Files + Episodic Memory)       │
│                                                 │
│  What: Session handoffs, routing log, decisions │
│  Where: orchestrator/projects/, routing-log     │
│  Lifetime: Weeks to months                      │
│  Size: Grows with usage                         │
├─────────────────────────────────────────────────┤
│  LONG-TERM (CLAUDE.md + Knowledge Base)         │
│                                                 │
│  What: Rules, preferences, glossary, contacts   │
│  Where: CLAUDE.md, memory/, Obsidian vaults     │
│  Lifetime: Permanent                            │
│  Size: Manually curated                         │
└─────────────────────────────────────────────────┘
```

## How It Flows

```
User Message
    │
    ▼
┌──────────────┐
│  CLAUDE.md   │ ← Reads routing rules
│  (Long-term) │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Route to    │ ← Matches keywords to skills
│  Skill       │
└──────┬───────┘
       │
       ▼
┌──────────────┐     ┌──────────────┐
│  Execute     │ ──▶ │  Memory      │ ← Checks existing knowledge
│  Skill       │     │  (all layers)│
└──────┬───────┘     └──────────────┘
       │
       ▼
┌──────────────┐
│  Output +    │ ← Suggests next skills
│  Log         │
└──────────────┘
```

## Skills Architecture

Each skill is a self-contained `SKILL.md` file:

```yaml
---
name: skill-name
description: When to invoke this skill
---

# Skill Title

## Core Principles
[What guides this skill's behavior]

## Workflow
[Step-by-step instructions for Claude]

## Output Format
[Expected output structure]

## Rules
[Constraints and guidelines]
```

Skills are **instruction files**, not code. They tell Claude how to behave, what tools to use, and what output to produce.

### Skill Categories

| Category | Purpose | Example Skills |
|----------|---------|---------------|
| **Input** | Get information into the system | capture |
| **Processing** | Transform and analyze | distill, analyze |
| **Output** | Produce finished results | express |
| **Quality** | Evaluate and improve | signal-check |
| **Meta** | System maintenance | handoff |

### The Evaluator-Optimizer Pattern

A key pattern in this system: after generating output, run a quality check, then improve.

```
express (generate) → signal-check (evaluate) → express (optimize)
```

This mirrors how humans write: draft → review → revise.

## Routing Architecture

Routing happens through keyword matching in `CLAUDE.md`:

1. User sends a message
2. Claude reads the routing table
3. Matches keywords to skills
4. Invokes the best-matching skill
5. Logs the routing decision

### Learning from Routing

The `routing-log.jsonl` tracks every decision with outcomes:
- **positive**: User liked the result
- **negative**: Wrong skill was chosen
- **neutral**: No feedback

Over time, `user-patterns.md` accumulates corrections, which Claude reads at session start to avoid repeating mistakes.

## Obsidian Integration (Optional)

```
Claude Code ──stdio──▶ MCP Server ──HTTPS──▶ Obsidian REST API ──▶ Vault
```

Obsidian acts as the **long-term knowledge store**:
- Skills like `capture` write to it
- Skills like `analyze` and `express` read from it
- The `handoff` skill doesn't use Obsidian (uses local state files)

## Knowledge Database (Optional)

```
Claude Code ──stdio──▶ SQLite MCP Server ──▶ knowledge.db
```

For structured data that doesn't fit well in markdown:
- Research items with metadata
- Imported CSV/Excel datasets
- Skill usage statistics
