# Skill Development Guide

## What Is a Skill?

A skill is a `SKILL.md` file that tells Claude **how** to handle a specific type of request. It's not code — it's instructions.

## Anatomy of a Skill

```markdown
---
name: my-skill
description: Clear description of when this skill should be invoked.
---

# Skill Title — Short Description

You are [role description]. [One sentence about what you do].

## Core Principles
1. **Principle 1** — explanation
2. **Principle 2** — explanation
3. **Principle 3** — explanation

## Workflow

### Step 1: [Name]
- What to do
- How to do it

### Step 2: [Name]
- What to do
- How to do it

## Output Format

\```markdown
## [Section]
[Template for output]
\```

## Rules
- Rule 1
- Rule 2
- Tone: [Analytical / Encouraging / Direct / ...]
```

## Creating a New Skill

### 1. Create the Directory

```bash
mkdir -p ~/.claude/orchestrator/skills/my-skill
```

### 2. Write the SKILL.md

Start with this template:

```bash
cat > ~/.claude/orchestrator/skills/my-skill/SKILL.md << 'EOF'
---
name: my-skill
description: Use when the user says 'trigger word 1', 'trigger word 2', or wants [outcome].
---

# My Skill — [Purpose]

You are [role]. [What you do in one sentence].

## Core Principles
1. **[Name]** — [Explanation]
2. **[Name]** — [Explanation]

## Workflow

### Step 1: Understand
- What does the user need?
- Ask one clarifying question if needed

### Step 2: Execute
- [Main action steps]

### Step 3: Deliver
- Present the result
- Suggest next steps

## Output Format
[Define expected output structure]

## Rules
- [Constraint 1]
- [Constraint 2]
- Tone: [Desired tone]
EOF
```

### 3. Add Routing Rules

Edit `~/.claude/CLAUDE.md` and add to the routing table:

```markdown
| trigger word 1, trigger word 2 | `my-skill` | [Purpose] |
```

### 4. Test It

```bash
claude
# Type a message with your trigger words
# Check if the skill is invoked correctly
```

## Skill Design Principles

### Be Specific
Bad: "Help the user with their request"
Good: "Analyze the text through 4 axes: meaning, facts, framing, context"

### Define the Workflow
Skills with clear step-by-step workflows produce consistent results.

### Set Constraints
Without rules, Claude defaults to generic behavior. Rules make skills distinct.

### Include Output Format
A defined output format ensures consistency across invocations.

### Suggest Next Steps
End each skill with suggestions for what to do next (the workflow chain pattern).

## Skill Categories

| Type | Purpose | Design Focus |
|------|---------|-------------|
| **Rigid** | Must follow exact steps (TDD, debugging) | Strict workflow, no shortcuts |
| **Flexible** | Adapt principles to context (brainstorming) | Guiding principles, loose workflow |
| **Meta** | System maintenance (handoff, improve) | Self-referential, updates the system |

## Examples

### Simple Skill: Daily Standup
```markdown
---
name: standup
description: Use for daily standup summaries. Triggers: 'standup', 'daily update'.
---

# Standup — Daily Summary

## Workflow
1. Ask: "What did you work on yesterday?"
2. Ask: "What are you working on today?"
3. Ask: "Any blockers?"
4. Format as concise standup update

## Output Format
**Yesterday:** [Summary]
**Today:** [Plan]
**Blockers:** [None / List]
```

### Complex Skill: Research Pipeline
A research skill might include:
- Knowledge check (what do we already know?)
- External search (what's new?)
- Quality filtering (signal vs. noise)
- Summary generation
- Knowledge persistence (save to Obsidian/DB)

Build complex skills by chaining simpler ones.
