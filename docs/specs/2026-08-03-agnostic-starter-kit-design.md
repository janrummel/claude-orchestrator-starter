# Design: Agent Orchestrator Starter (harness-agnostic)

Status: approved, amended 2026-11-09 (see end)
Date: 2026-08-03

## Problem

Every agent-harness starter kit today is bound to one product. The predecessor of this
kit (claude-orchestrator-starter) only works with Claude Code. But the parts that make
an orchestrator valuable: persistent memory, project states, reusable skills, a
knowledge vault: are file conventions, not product features. They should survive a
change of model (Claude, Copilot, Codex, local) and a change of UI (CLI, VS Code,
opencode).

The one deliberately fixed component is **Obsidian as the knowledge layer**, connected
via MCP. Everything else must be swappable.

## Goals

1. A starter kit whose **core works on any harness that reads `AGENTS.md` and speaks
   MCP** (Claude Code, GitHub Copilot, Codex, opencode, ...).
2. **Honesty about the portability boundary**: the core is convention ("requested"
   behavior); enforcement (hooks, gates) exists only per adapter. The kit states this
   openly instead of pretending markdown rules enforce themselves.
3. Consolidate the maintainer's harness lessons (audit practice, readable-repo-standard,
   daily orchestrator use since March 2026) into one depersonalized, public-ready artifact.
4. Serve as a real multi-harness testbed for the maintainer before anyone else uses it.

## Non-goals

- No new specification. The kit *implements* readable-repo-standard and links to it;
  it does not duplicate or fork it.
- No support matrix chasing. Adapters are added only after real use, not speculatively.
- No plugin/marketplace packaging in v1.
- No SQLite knowledge DB in v1 (was optional in the predecessor, stays out until missed).

## Architecture

```
agent-orchestrator-starter/
├── README.md
├── START_HERE.md                 # cold-start entry per readable-repo-standard
├── STATE.md                      # single source of truth for project state
├── AGENTS.md.example             # agnostic instructions: workflow, memory, project states
├── core/
│   ├── memory/                   # memory convention: MEMORY.md index + one-fact files
│   ├── projects/                 # project-state convention: STATE.md pattern, pointer rule
│   └── skills/                   # skill library as plain markdown procedures
├── obsidian/                     # MCP setup + vault zone concept (Inbox as triage zone)
├── adapters/
│   ├── claude-code/              # hooks, slash commands, settings examples
│   ├── github-copilot/           # VS Code setup, MCP config, capability notes
│   └── opencode/                 # placeholder; built only after real demand
├── audit/                        # rubric-light: self-test "how good is your harness?"
└── docs/
    ├── portability.md            # the honest enforcement table (below)
    └── specs/                    # design docs like this one
```

### The portability boundary (core design driver)

| Layer                    | Portable? | Mechanism                                     |
|--------------------------|-----------|-----------------------------------------------|
| Instructions             | yes       | `AGENTS.md` de-facto standard                 |
| Memory as markdown files | yes       | pure file convention                          |
| Project states           | yes       | pure file convention (`STATE.md` in repo)     |
| Skills as markdown       | mostly    | readable procedures; auto-triggering is harness-specific |
| Obsidian via MCP         | yes       | MCP supported by all target harnesses         |
| Enforcement (hooks/gates)| **no**    | adapter-only, per harness                     |

Design consequence: the core must be **fully usable with zero enforcement** (degraded
but functional: the model is asked, not forced). Each adapter documents exactly which
conventions it upgrades from "requested" to "enforced". The audit measures the gap.

### Core components

**`AGENTS.md.example`**: the agnostic instruction file: session start, a
clarify → produce → finish workflow, memory rules, project-state rules, WIP discipline.
Written so that a blank model with no product features can follow it.

**`core/memory/`**: MEMORY.md index + one-fact-per-file convention, with the pointer
rule: project entries carry pointers, never status copies (two copies drift).

**`core/projects/`**: the STATE.md pattern: state lives in the repo being worked on,
with a "ONE next action" section. Follows readable-repo-standard.

**`core/skills/`**: depersonalized versions of the proven skills (clarify, analyze,
express, challenge, quality-gate, capture, learn-from-the-best, research). Each skill
is a plain markdown procedure any model can read and follow; harness-specific
invocation (slash commands, skill tools) lives in the adapters. Skills are migrated by
**incremental edit from the proven originals, never full rewrite**, because full
rewrites tend to lose details that only the original carried.

**`obsidian/`**: MCP server setup for the vault, plus the zone concept: the agent
writes only to an Inbox (triage) zone and a curated output zone; the human promotes.
This is the only fixed integration.

**`adapters/`**: per harness: install steps, MCP config, what the harness can enforce
(hooks, gates, permissions), what it cannot, and the mapping from core conventions to
harness features. Claude Code adapter is extracted from a working setup; Copilot
adapter is validated in real use before it counts as done.

**`audit/`**: a light version of an audit rubric as a self-test:
a checklist distinguishing enforcement / state / practice checks, with the two core
lessons built in: *existence ≠ effectiveness* and *a guard is proven only when it has
been seen firing*.

## Build phases

Each phase is used for real before the next starts (no speculative building):

1. **Core + Copilot adapter**: exit: the maintainer runs the kit for real work in at
   least three sessions on a harness that is **not** Claude Code, and the friction log
   is reviewed. A depersonalized friction summary lands in this repo's STATE.md.

   *Amended 2026-08-08.* The original criterion named one specific Copilot environment.
   That made the gate depend on an environment the maintainer does not control, so the
   project could stall indefinitely.
   The criterion now names what the exit is actually meant to prove: **that the core
   works on a foreign harness with zero enforcement.** Any non-Claude-Code harness the
   maintainer controls satisfies it (Copilot in a private VS Code, opencode, Codex).
   A run in a second environment remains welcome as extra evidence, not as the gate.
2. **Skill library**: exit: the depersonalized skills are usable from at least two
   harnesses (Copilot + Claude Code) without editing.
3. **Claude Code adapter**: exit: fresh-machine install from the repo alone succeeds;
   hooks proven by deliberate mutation (a guard is believed only after it was red once).
4. **Audit + quality gate → public**: exit: rubric-light self-test included, full
   quality-gate review passed, repo depersonalization verified, then (and only then)
   visibility flips to public.

The repo is **private until phase 4 completes**.

## Depersonalization policy (from commit 1)

No personal names, employer names, hostnames, local paths, vault names, or project
names from the maintainer's private setup: in files **or git history**. Examples use
neutral placeholders. This is cheaper than a cleanup pass later and makes the history
publishable.

## Relation to existing repos

- **claude-orchestrator-starter** (public): stays as-is; gets a "successor" note in its
  README once this kit goes public. Not before (this repo is private until then).
- **readable-repo-standard** (public): referenced as the underlying principle; this
  repo itself complies with it (START_HERE.md, STATE.md).
- **Audit rubric** (not public): source of the planned audit content.

## Testing

- Phase exits above are the test plan: real daily use, cross-harness skill runs,
  fresh-machine install, mutation-proven hooks.
- Before going public: quality-gate review + a depersonalization scan of files and
  history (grep for known identifiers, run by an agent with a checklist).

## Open decisions

- **Final name**: decided, see the amendment below.
- **License**: decided, MIT (see `LICENSE`).

## Amendment 2026-11-09: merged into the predecessor

The kit no longer lives in a separate repository. Its core was merged into
`claude-orchestrator-starter`, which keeps its name, address and existing files so
that no link breaks. What changed against the sections above:

- **Relation to existing repos:** the predecessor is not left as-is with a successor
  note. It *is* the kit now. Its Claude Code parts (`CLAUDE.md.example`, `hooks/`,
  `orchestrator/skills/`) form the Claude Code adapter in place, without moving.
- **Visibility:** public from the merge on. The phase-4 gate (audit and quality gate
  before public) is replaced by a quality-gate review and a depersonalization scan of
  the merged files before the merge. Only files were carried over, no git history.
- **Skills:** the predecessor's eight skills are the starting library. They stay at
  `orchestrator/skills/`; phase 2 now means making them read well on other harnesses,
  not writing them.
- **Memory:** `core/memory/` (one fact per file) is the documented convention. The
  older `memory/` folder layout stays for existing users and is marked as such.
- **Name:** the repository name stays; the kit is titled Agent Orchestrator Starter.
- **`audit/`:** deferred. There is no audit folder yet; it is built only if the self-checks
  in `scripts/` turn out not to be enough.
- **Knowledge DB:** `knowledge-db/` stays as an optional add-on from the predecessor,
  against the original non-goal, because removing it would break existing setups.
