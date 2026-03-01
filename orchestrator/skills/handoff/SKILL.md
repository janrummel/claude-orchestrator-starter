---
name: handoff
description: Saves current session state to a project file for seamless continuation in the next session. Captures decisions, open questions, active context, and next steps. Use when the user says 'handoff', 'save state', 'save session', 'for next time', 'where were we', or at the end of a work session.
---

# Handoff — Save Session State

You save the current work state so the next session can continue seamlessly. No context is lost.

## Core Principles
1. **Write for your future self** — assume NOTHING from this session is known
2. **Decisions with reasoning** — not just WHAT, but WHY
3. **Record discarded alternatives** — prevents repetition
4. **Concrete next steps** — specific enough to start immediately

## Workflow

### Step 1: Identify Project

Which project was active in this session?

**Existing state file?**
```bash
ls ~/.claude/orchestrator/projects/
```

- **Yes:** Load and update state file
- **No:** Create new state from template

**Determine project name:**
- Derive from context (directory, topic, user input)
- Use kebab-case: `my-project`, `research-topic`, `feature-name`

### Step 2: Summarize Session

Analyze the current session and extract:

**2a. Active Context (MOST IMPORTANT section)**
- Where are we right now? (2-5 bullet points)
- What was the main topic?
- What was achieved?
- What is the immediate next step?

**2b. Decisions**
For EACH decision made in this session:
- What was chosen?
- Why? (1-2 sentences reasoning)
- Which alternatives were discarded and why?

**2c. Open Questions**
- What remained unclear?
- What needs to be decided next session?
- Where are there uncertainties?

**2d. Next Steps**
- Prioritized list of concrete actions
- Specific enough to start immediately
- First action should be doable without further questions

**2e. Relevant Files**
- Which files were created/modified?
- Which files are important for continued work?

### Step 3: Write State File

Save/update state file at:
```
~/.claude/orchestrator/projects/<projectname>.md
```

**Template:**
```markdown
# Project: [Name]

## Active Context
- [Current state point 1]
- [Current state point 2]

## Decision Trail
### [Date] — [Decision Title]
- **Chosen:** [What]
- **Reasoning:** [Why]
- **Discarded:** [Alternatives and why not]

## Open Questions
- [ ] [Question 1]
- [ ] [Question 2]

## Next Steps
1. [Highest priority action]
2. [Second priority action]
3. [Third priority action]

## Relevant Files
| File | Purpose |
|------|---------|
| `path/to/file` | [What it contains] |
```

**Rules for Decision Trail:**
- Chronological, newest first
- NEVER delete existing entries — only add new ones
- Keep max 10 entries — archive older ones if needed

### Step 4: Confirmation

Show the user a brief summary:

```markdown
## Handoff saved: [Project Name]

**Saved:** `~/.claude/orchestrator/projects/<name>.md`
**Decisions:** [N] new entries
**Next session:** [First next step in 1 sentence]
```

## Modes

| Mode | When | Behavior |
|------|------|----------|
| **Full** | End of long session | Update all sections |
| **Quick** | Brief checkpoint | Only Active Context + Next Steps |
| **Resume** | Session start, load state | Read state and summarize (no writing) |

## Automatic Triggers

Suggest `/handoff` proactively when:
- Session longer than ~30 minutes / ~20 tool calls
- Significant decisions were made
- User signals session end ("thanks", "done for today", "bye")
- A milestone was completed

## Rules
- ALWAYS write for "future self" — assume NOTHING from the session is known
- Decision trail is append-only — never delete old entries
- Discarded alternatives MUST be documented (prevents repetition)
- When unsure about the project: ask the user
- Prefer quick mode when user seems in a hurry
- Tone: Compact, precise, future-oriented
