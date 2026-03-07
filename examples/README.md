# Examples

A complete walkthrough of the orchestrator in action. These files show what a real session looks like — from first message to finished output.

## The Scenario

You're writing a blog post about remote work productivity. Here's how the three-phase workflow plays out:

### Phase 1: Clarify

**You:** "I want to write a blog post about remote work productivity, but I'm not sure what angle to take."

**Claude detects:** Expansion mode → invokes `analyze`

**Result:** [analyze-output.md](analyze-output.md) — Structured analysis with 4 possible angles, each evaluated for originality and audience fit.

### Phase 2: Build

**You:** "Go with angle 2 — the 'deep work' perspective. Write the post."

**Claude routes:** `express` (Build phase)

**Result:** [express-output.md](express-output.md) — 1200-word blog post draft.

### Phase 3: Verify

**You:** "Is this solid?"

**Claude routes:** `signal-check` (Verify phase)

**Result:** [signal-check-output.md](signal-check-output.md) — 4-axis evaluation with specific improvement suggestions.

**You:** "Improve based on that feedback."

**Claude routes:** `express` again (Evaluator-Optimizer Loop)

**Result:** The improved version, addressing each point from the signal-check.

## Supporting Files

- [project-state.md](project-state.md) — What a filled project file looks like after the handoff skill
- [routing-log.jsonl](routing-log.jsonl) — The routing log entries generated during this session
