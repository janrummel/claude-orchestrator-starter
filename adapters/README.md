# Adapters

The core works on any harness that reads `AGENTS.md`. An adapter adds two things
the core cannot carry: the install path for that specific harness, and an honest
list of what it can and cannot enforce.

| Adapter | Status | Enforcement available | Notes |
|---|---|---|---|
| [`github-copilot/`](github-copilot/README.md) | draft from documentation, not yet used | no hooks; tool approval / sandbox modes only (as of 2026-08) | reference environment for "works on discipline alone"; `AGENTS.md` support is recent and setting-gated |
| [`codex/`](codex/README.md) | written from a real session | no hooks; tool approval / sandbox modes only (as of 2026-08) | `AGENTS.md` is native here; the friction is process supervision, not instructions |
| Claude Code | in daily use since March 2026 | hooks, deny rules, stop gates | lives in place: [`CLAUDE.md.example`](../CLAUDE.md.example), [`hooks/`](../hooks/README.md), [`orchestrator/skills/`](../orchestrator/skills/); setup in [`docs/getting-started.md`](../docs/getting-started.md) |
| opencode | not planned yet | plugins | added when someone actually runs it, not before |

## Why there are so few

An adapter counts as finished only after the kit has been used for real work on
that harness, so the "what it cannot do" section comes from
observation rather than from reading release notes. That is slower and it is the
reason the finished adapters can tell you where they hurt.

If your harness is missing: the core alone is usable. Copy `AGENTS.md.example` to
`AGENTS.md`, set up `memory/` and `STATE.md`, and you have everything except the
harness-specific install notes. That is also the purest test of the kit's central
claim, so if you do it, [`../VALIDATION.md`](../VALIDATION.md) is where the
friction belongs.
