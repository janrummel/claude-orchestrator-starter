# Project-state convention

A project's working state lives in the project itself, in a `STATE.md` at
the root. Not in chat history, not in anyone's head, not in an external
memory system. Any blank model that opens the folder must be able to
continue cold. (This follows the readable-repo-standard idea: the repo
carries the harness minimum.)

## Rules

1. `STATE.md` starts with "The ONE next action": one concrete, doable step.
   If you cannot name one, that is the state ("blocked on X").
2. Update the state DURING work, not at session end. A crash must not lose
   the state.
3. Decisions are recorded with their why. Future sessions must be able to
   judge whether a decision still holds.
4. External memory (see `../memory/`) points here; it never copies status.

## Template

See `STATE.md.template`. Copy it to a new project's root and fill it in.
