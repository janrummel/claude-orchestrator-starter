# Architecture

## Overview

The orchestrator has four layers:

```
┌───────────────────────────────────────────────────────────────┐
│  CONTEXT MANAGEMENT (Hooks + Session Chaining)                │
│                                                               │
│  What: Monitors context usage, auto-saves state, chains       │
│        sessions seamlessly                                    │
│  Where: hooks/, claude-loop                                   │
│  Handles: Context-full transitions without losing state       │
├───────────────────────────────────────────────────────────────┤
│  SHORT-TERM MEMORY (Context Window)                           │
│                                                               │
│  What: Current conversation, temporary results                │
│  Where: Claude's context window                               │
│  Lifetime: 1 session (~200K tokens)                           │
├───────────────────────────────────────────────────────────────┤
│  MID-TERM MEMORY (State Files + Episodic Memory)              │
│                                                               │
│  What: Session handoffs, routing log, decisions               │
│  Where: orchestrator/projects/, routing-log, last-session.md  │
│  Lifetime: Weeks to months                                    │
├───────────────────────────────────────────────────────────────┤
│  LONG-TERM MEMORY (CLAUDE.md + Knowledge Base)                │
│                                                               │
│  What: Rules, preferences, glossary, contacts                 │
│  Where: CLAUDE.md, memory/, Obsidian vaults                   │
│  Lifetime: Permanent                                          │
└───────────────────────────────────────────────────────────────┘
```

## Context Management Layer

This layer solves the CLI's biggest pain point: when the context window fills up, you lose your working state.

### How It Works

```
context-statusline.js
│  Runs on every render. Shows context usage in the statusbar.
│  Writes metrics to a bridge file in /tmp/.
│
▼
context-monitor.js (PostToolUse hook)
│  Reads the bridge file after every tool use.
│  WARNING at 35% remaining: tells Claude to wrap up.
│  CRITICAL at 25% remaining: tells Claude to save state NOW.
│
▼
Claude writes ~/.claude/orchestrator/last-session.md
│  Contains: current task, progress, decisions, next step.
│  This is the automatic handoff — no user action needed.
│
▼
Session ends
│
▼
claude-loop (wrapper script)
│  Detects the handoff file.
│  Asks: "Start new session with context? [Y/n]"
│
▼
session-start.sh (SessionStart hook)
│  Reads last-session.md, injects it as system context.
│  Claude knows exactly where the previous session left off.
│
▼
New session continues seamlessly
```

### Bridge File Pattern

The statusline and context monitor communicate through a temporary JSON file:

```
context-statusline.js  ──writes──▶  /tmp/claude-ctx-{session-id}.json
context-monitor.js     ──reads───▶  /tmp/claude-ctx-{session-id}.json
```

This avoids duplicate API calls — the statusline already has the metrics, so the monitor just reads them.

### Two Types of Handoff

| Type | Trigger | Written by | Read by |
|------|---------|-----------|---------|
| **Automatic** | Context hits 25% remaining | Claude (instructed by context-monitor hook) | session-start.sh |
| **Manual** | User says "save state" / "handoff" | Claude (via handoff skill) | session-start.sh |

Both produce state files that the session-start hook can read. Automatic handoff writes to `last-session.md`, manual handoff writes to `orchestrator/projects/<name>.md`.

## How Routing Flows

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
│  Output +    │ ← Suggests next skill
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
| **Quality** | Evaluate and improve | signal-check, quality-gate, challenge |
| **Meta** | System maintenance | handoff |

### The Evaluator-Optimizer Pattern

A key pattern in this system: after generating output, run a quality check, then improve.

```
express (generate) → signal-check (evaluate) → express (optimize)
```

This mirrors how humans write: draft → review → revise.

### The Evaluator-Gate-Optimizer Pattern

For outputs with risk indicators (numbers, forecasts, causal claims), the quality-gate adds structured verification:

```
express (generate) → quality-gate (triage + verify) → express (revise)
```

The quality-gate **orchestrates** signal-check and challenge rather than replacing them. It adds:
- **Triage levels** (0-3) based on risk indicators in the output
- **External verification** of quantitative claims
- **Quality Score (QS)** from 5 measurable sub-metrics
- **Synthesis** of all findings into a prioritized report

When to use which:
- **signal-check**: Quick substance check on any content
- **quality-gate**: Structured verification for outputs with numbers, forecasts, or causal claims
- **challenge**: Adversarial stress-testing of ideas and strategies

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
