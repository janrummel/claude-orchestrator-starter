# A first session, start to finish

The rest of the kit gives you templates. This page shows one filled in, because
a template tells you the shape and an example tells you the size.

The task below is deliberately small and realistic: a person named Alex, who coordinates
events at a city library, wants to decide whether to
switch a small internal tool from a spreadsheet to a database. One session, one
finished result.

Everything in this example is fictional. The point is the shape of the artifacts,
not the content.

---

## Before: what Alex set up once

```
~/work/tool-decision/          <- the project
├── AGENTS.md                  <- copied from AGENTS.md.example
└── STATE.md                   <- copied from core/projects/STATE.md.template
~/work/memory/                 <- set up once, shared across projects
├── MEMORY.md
└── user_profile.md
```

That is the whole installation. No plugin, no service.

---

## The session

### Phase 1: Clarify

Alex opens the agent in `~/work/tool-decision/` and types:

> Should we move the room-booking tracker off the spreadsheet?

Because `AGENTS.md` is present, the agent does **not** start answering. It
follows the session-start rule, finds `STATE.md` empty, and asks the clarifying
questions the workflow demands: what exactly is the problem, for whom, and when
is it done?

What comes out of five minutes of back and forth:

> **Problem:** four people edit the same sheet, two of them overwrite each other
> weekly, and nobody can tell which version is current.
> **For whom:** the four editors, plus a manager who only reads.
> **Done when:** a decision is written down with its reason, not when a tool is built.

Note what changed: the question was "should we switch tools", the problem is
"concurrent edits are lost". Those are not the same task. Skipping Clarify would
have produced a well-argued answer to the wrong question.

### Phase 2: Produce

The agent drafts a one-page comparison: keep the sheet with locking rules, move
to a shared database, or move to a small app. Each option gets cost, migration
effort, and what breaks. Alex corrects two wrong assumptions about who has admin
rights.

Mid-work, Alex has an unrelated idea: "we should also track projector
maintenance dates". Per `AGENTS.md`, that goes to the inbox and is **not** pursued now:

```markdown
<!-- ~/work/memory/inbox.md  (or the vault's Inbox/ when a vault is connected) -->
- 2026-08-08 idea: track projector maintenance dates too, unrelated to the tool
  decision, look at it after this is closed
```

This is the rule that saves the most time in practice, and the one most often
ignored. The idea is not lost, and the session does not fork.

### Phase 3: Finish

The agent checks the draft against the quality principles: are the numbers
sourced, are assumptions marked, is anything stated as fact that is a guess? Two
cost figures turn out to be guesses and get marked as such, with a note on who
could confirm them.

Alex writes the decision down. Done means recorded, not built.

---

## After: what the artifacts look like

### `STATE.md` in the project

```markdown
# STATE - room-booking tooling

> Single source of truth for the working state. Lives in this repo.
> Last updated: 2026-08-08.

## The ONE next action

Ask IT (Sandra) to confirm the two cost figures marked as estimates in
`decision.md`, then move this project to done.

## Status

- Done: problem reframed from "switch tools" to "concurrent edits are lost";
  three options compared; decision written in `decision.md`.
- Open: two cost figures are estimates, not confirmed.

## Decisions

- 2026-08-08 shared database, not a new app - because the problem is concurrent
  edits, and an app would add a UI nobody asked for.
- 2026-08-08 keep the spreadsheet as the read view for the manager - because
  retraining one reader costs more than exporting a view.
```

Anyone, human or model, can open that folder cold and continue. That is the whole
point of keeping state in the project.

### `MEMORY.md`, the index

```markdown
# Memory index

> Pointers only. One line per memory: link + hook. Content lives in the files.

## User

- [user_profile.md](user_profile.md) - Alex, events coordinator at a city library, prefers
  decisions written down over tools built

## Working rules (feedback)

- [feedback_reframe_before_comparing.md](feedback_reframe_before_comparing.md) -
  restate the problem before comparing options; the stated question is often not
  the real one

## Projects (pointers, no status copies)

- **room-booking tooling** - `~/work/tool-decision/` (state lives IN the
  project, `STATE.md`)
```

Notice the project line carries a **pointer**, not a status. If it said "decision
written, two figures open", that sentence would be stale the moment `STATE.md`
changes, and you would have two sources of truth disagreeing with each other.

### A new memory file, written during the session

```markdown
---
name: reframe-before-comparing
description: restate the problem before comparing options; the asked question is often not the real one
type: feedback
---

Before comparing options, restate the problem in one sentence and get it
confirmed. In the tracker decision the question was "should we switch tools"
while the actual problem was "concurrent edits are lost".

**Why:** comparing options against the wrong problem produces a well-argued
answer nobody needed.
**How to apply:** in Clarify, say the problem back in your own words and wait
for a yes before drafting anything.
```

One file, one fact, with the reason. In six months the reason is what tells you
whether the rule still applies.

---

## What this session cost in discipline

Three things happened only because the rules were followed, and none of them
were enforced by software:

1. The question got reframed instead of answered.
2. A good unrelated idea got parked instead of chased.
3. Two numbers got marked as guesses instead of shipped as facts.

On a harness without hooks, that is exactly the deal: the kit makes the right
move obvious and cheap, and you still have to make it. See
[`docs/portability.md`](../docs/portability.md) for which harnesses can enforce
part of this for you.
