# Portability: what moves with you, what does not

This kit's core is a set of file conventions. Conventions are `requested`
behavior: the model is asked to follow them. Some harnesses can upgrade
specific conventions to `enforced` behavior (hooks, gates, permissions).
This page is the honest map. Two lessons from harness audit practice drive
it: existence of a rule is not effectiveness, and a guard should only be
believed after it has been seen firing.

## The boundary

| Layer                     | Portable? | Mechanism                                            |
|---------------------------|-----------|------------------------------------------------------|
| Instructions              | yes       | `AGENTS.md`, read by Copilot, Codex, opencode, Claude Code (as CLAUDE.md content) |
| Memory as markdown files  | yes       | pure file convention                                 |
| Project states            | yes       | pure file convention (`STATE.md` in the repo)        |
| Skills as markdown        | mostly    | readable procedures; auto-triggering is harness-specific (phase 2) |
| Obsidian via MCP          | yes       | MCP supported by all target harnesses                |
| Enforcement (hooks/gates) | **no**    | adapter-only, per harness                            |

## Per-harness enforcement capability

As checked in August 2026. Copilot and Codex change fast; check your version.

| Capability                     | Copilot (VS Code) | Codex CLI | Claude Code | opencode |
|--------------------------------|-------------------|-----------|-------------|----------|
| Reads AGENTS.md                | yes               | yes (native) | via CLAUDE.md (`@AGENTS.md`) | yes |
| MCP servers                    | yes               | yes       | yes         | yes      |
| Pre/post tool hooks            | no                | no        | yes         | plugins  |
| Command allow/deny rules       | limited (workspace trust, tool approval) | sandbox modes | yes | yes |
| Custom slash commands          | limited (prompt files) | limited | yes      | yes      |

Consequence: on Copilot and Codex, EVERY core rule runs as `requested`. The kit still
works, but nothing stops a session from ignoring the memory rules or the
vault zones. Know this before you trust an output chain. The two
self-check scripts in `scripts/` check the repo, not your sessions.

## Rule-by-rule status

| Core rule                         | Without adapter | Possible on Claude Code             | Shipped in this kit |
|-----------------------------------|-----------------|-------------------------------------|---------------------|
| Clarify -> Produce -> Finish      | requested       | requested                           | n/a                 |
| Memory index discipline           | requested       | partially enforceable (hooks)       | no                  |
| STATE.md updated during work      | requested       | partially enforceable (stop gate)   | no                  |
| Vault write zones (Inbox/Gallery) | requested       | enforceable (hook on the MCP write tool, or MCP server path scoping) | no                  |
| WIP limit / closure decision      | requested       | requested (human discipline)        | n/a                 |
| Context running out, session chaining | requested   | enforceable (hooks)                 | yes, `hooks/`       |
