# Adapter: Codex CLI

The adapter where the core needs the least translation, because `AGENTS.md` is
Codex's own convention rather than something bolted on. Everything still runs as
`requested` (see [`../../docs/portability.md`](../../docs/portability.md)); Codex
has no hook layer.

This adapter is written from a real audit session run on Codex CLI 0.144.0 with
`gpt-5.6-sol`, not from documentation. The friction notes below are what actually
went wrong.

## Install

1. Prerequisites: `codex` on your PATH and an authenticated session
   (`codex login`). Check with `codex --version`.
2. Copy `AGENTS.md.example` from the kit root to `AGENTS.md` in the root of your
   project. Codex reads it automatically, no setting required.
3. Create `memory/` in the project from [`../../core/memory/`](../../core/memory/README.md)
   (copy `MEMORY.md.example` to `memory/MEMORY.md`).
4. Copy [`../../core/projects/STATE.md.template`](../../core/projects/STATE.md.template)
   to the project root as `STATE.md` and fill it in.
5. MCP, only if you want the vault connected: add a server block to
   `~/.codex/config.toml` under `[mcp_servers.vault]`. Codex uses TOML here, not
   the JSON shape in [`../../obsidian/mcp-config.json.example`](../../obsidian/mcp-config.json.example):

   ```toml
   [mcp_servers.vault]
   command = "npx"
   args = ["-y", "@modelcontextprotocol/server-filesystem",
           "/absolute/path/to/your/vault/Inbox",
           "/absolute/path/to/your/vault/Gallery"]
   ```

   Scope it to the two write zones, not the vault root, unless you need read
   access to the rest. Without hooks that path list is the only real boundary.

**A global `~/.codex/AGENTS.md` also exists.** Keep the kit instructions in the
project file, not the global one, or every unrelated project inherits your
orchestration rules.

## What Codex cannot do (read before trusting)

- **No hooks.** Nothing runs before or after a tool call. The vault write zones
  are convention only. Mitigation is the MCP path scoping above.
- **No stop gates.** `STATE.md` gets updated during work only if the session
  follows the instruction.
- **Session memory is not automatic.** Codex does not load `memory/MEMORY.md` by
  itself. Open a session with "Read memory/MEMORY.md and STATE.md, then
  continue", or keep that line near the top of your `AGENTS.md`.

## Operating notes (the actual friction)

These cost the most time in the first real session, and none of them are in the
instructions layer:

- **Runs are long.** With `model_reasoning_effort = "xhigh"` a substantial task
  spent over ten minutes just gathering evidence. Do not wrap `codex exec` in a
  short timeout; the process is killed mid-reasoning and the turn is lost.
- **Resume takes different arguments than the first call.** `codex exec resume
  --last` rejects the sandbox flags that `codex exec` accepts, and fails with a
  usage error rather than a hint. Put flags before the subcommand or set them in
  `config.toml`.
- **Backgrounding needs real supervision.** `nohup codex exec … &` is not enough:
  the process dies when the shell session ends, and the exit code you get back is
  the wrapper's, not the run's. Use a process manager, `tmux`, or a foreground
  call you are willing to wait for.
- **A read-only sandbox cannot write its own output.** If you run
  `--sandbox read-only` (correct for anything audit-shaped), the agent cannot save
  a report; collect it from stdout. Codex prints its final message twice, so
  extracting it needs a moment of post-processing.

## What held without being asked

Recorded because absence of friction is a finding too. On first contact, with no
hint beyond the file being present, Codex named the three workflow phases, quoted
the pointer rule **together with its reasoning** ("two copies drift"), and named
`AGENTS.md` as its source. It also stayed read-only for a whole session as
instructed, with no write attempts outside its workspace.

---
Written from a validation session on 2026-08-08 · Codex CLI 0.144.0
