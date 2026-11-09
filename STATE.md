# STATE - Agent Orchestrator Starter

> Single source of truth for the working state. Lives in git, not in external memory.
> Last updated: 2026-11-09.

## The ONE next action

**Phase 1 is reviewed (see `VALIDATION.md`). Next: phase 2, making the eight skills
read well on other harnesses.**

Then try the Copilot adapter once for real work; it is the only adapter not yet used.

## Status

- **Website (2026-11-09):** head, hero and quick start renamed and rewritten; body text
  aligned with README.md in two Codex sessions (audit, then text-only edit); one CSS rule
  added so the session-chaining block fits on phones.
- **Claude Code part:** in daily use since March 2026 (`CLAUDE.md.example`, `hooks/`,
  eight skills in `orchestrator/skills/`).
- **Vendor-neutral core merged 2026-11-09:** `AGENTS.md.example`, `core/`, `adapters/`
  for Codex and GitHub Copilot, `docs/portability.md`, `docs/evidence.md`,
  `docs/rationale.md`, two self-check scripts. It was built from August 2026 in a
  separate working repository; only files were carried over, no history.
- **Validation:** 3 of 3 planned non-Claude-Code real-work sessions recorded in
  VALIDATION.md as of 2026-11-09, all on Codex. Session 3 exercised a text-only HTML
  edit, state updates, inbox capture and friction logging. Review done 2026-11-09;
  these sessions do not prove adapter enforcement or cross-harness skill execution.
- **Memory:** `core/memory/` is the documented convention; `memory/` is the older
  folder layout, kept so that existing setups and links keep working.
- **No paths moved.** Every file that existed before the merge is still at its path.

Phase-1 friction in one line: process supervision on Codex (timeouts, backgrounding) was
the main cost; two template flaws were found and fixed. Details: `VALIDATION.md`, Review.

## Decisions

| Date | Decision | Why |
|---|---|---|
| 2026-11-09 | Merge into this repo instead of publishing a second one | keeps the address, the stars and every inbound link; one kit is easier to find than two |
| 2026-11-09 | Repository name stays, title becomes Agent Orchestrator Starter | renaming would break links; the title says what the kit is now |
| 2026-11-09 | Claude Code parts stay where they are and count as its adapter | moving them would break existing setups and links |
| 2026-08-08 | Phase-1 exit: any non-Claude-Code harness, not one specific environment | the gate must prove the core works with zero enforcement, nothing else |

## Known gaps

- **Fresh install not yet verified** (spec phase 3): nobody has yet installed the Claude
  Code part on a clean machine from the README alone and seen hooks fire and skills load.
- `orchestrator/skills/capture/SKILL.md` falls back to the older `memory/projects/` folders.
- `handoff` stays among the eight skills because session chaining on Claude Code uses it,
  although the maintainer's own setup stopped the manual hand-over step (see `docs/evidence.md`).

- `scripts/check-kit.sh` does not validate `.md.example` / `.md.template` files and only
  recognizes code fences that start in column 0.
- `scripts/check-depersonalized.sh` scans files, not commit metadata.
- The "bigger picture" diagram on the website repeats the optional stores in two places;
  a cleaner redraw is open.
- Older files (`docs/getting-started.md`, `docs/faq.md`,
  `docs/index.html`) still contain em-dashes; new text avoids them.
- `CLAUDE.md.example` still routes captures into the older `memory/` folders; it states
  that the one-fact convention from `AGENTS.md` takes precedence.
- Tool capabilities in `docs/portability.md` and the adapters were checked in August 2026;
  Copilot and Codex change fast.

## Ground rules for anyone (or any model) continuing here

- Read `docs/specs/2026-08-03-agnostic-starter-kit-design.md` first, including its
  amendment of 2026-11-09. It is the contract.
- No personal names, employers, hostnames, local paths or private project names in files.
- Skills are changed by incremental edit, never full rewrite.
- An adapter counts as finished only after real use on that tool.

