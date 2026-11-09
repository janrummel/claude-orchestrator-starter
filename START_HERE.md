# START HERE

This repo is the **Agent Orchestrator Starter**, a harness-agnostic starter kit for
personal agent orchestration (memory, project states, Obsidian knowledge
layer), designed to work across Claude Code, GitHub Copilot, Codex, opencode and
other harnesses that read `AGENTS.md` and speak MCP.

**Current stage:** the Claude Code part has been in daily use since March 2026. The vendor-neutral core (merged in November 2026) has run in 3 real-work sessions outside Claude Code, all on Codex; Copilot is untested. See `VALIDATION.md`.

Reading order:

1. `README.md` - what this kit is, with the diagram that explains it.
2. `examples/first-session.md` - one session start to finish, with the artifacts
   filled in. Read this before any template; it shows the size, not just the shape.
3. `STATE.md` - where the work stands and the ONE next action.
4. `docs/portability.md` - what is requested vs enforced.
5. `docs/rationale.md` - why each rule and number is what it is, and when to
   break it.
6. `VALIDATION.md` - the phase-1 evidence log (friction from real use on a
   non-Claude-Code harness).
7. `docs/specs/2026-08-03-agnostic-starter-kit-design.md` - the approved
   design (architecture, build phases, rules). The contract.

In a hurry: read the README, then pick your harness under `adapters/`. On Claude Code,
`docs/getting-started.md` is the fastest path.

This repo follows the [readable-repo-standard](https://github.com/janrummel/readable-repo-standard): the state you need to continue is in
the repo itself, not in anyone's head or external memory.
