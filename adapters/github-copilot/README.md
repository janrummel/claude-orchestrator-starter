# Adapter: GitHub Copilot (VS Code)

The zero-enforcement adapter: everything runs as `requested` (see
`../../docs/portability.md`). It is the kit's reference environment for
"works with discipline alone".

**Status: draft from documentation, not yet used for real work.**

## Install

1. Prerequisites: VS Code with GitHub Copilot and agent mode enabled
   (Copilot subscription; in corporate setups check that agent mode and
   MCP are not disabled by policy).
2. Copy `AGENTS.md.example` from the kit root to `AGENTS.md` in the root of
   the workspace you work in. Copilot's agent reads `AGENTS.md`
   automatically. If your Copilot version predates AGENTS.md support
   (introduced in VS Code 1.104, experimental, toggled by the
   `chat.useAgentsMdFile` setting), copy the same content to
   `.github/copilot-instructions.md` instead.
3. Create `memory/` in your workspace from `core/memory/` (copy
   `MEMORY.md.example` to `memory/MEMORY.md`, keep the template nearby).
4. For each project, copy `core/projects/STATE.md.template` to the project
   root as `STATE.md` and fill it in.
5. MCP: copy `mcp.json.example` to `.vscode/mcp.json` in your workspace and
   set the vault path. VS Code will ask to trust and start the server; the
   `vault` server then appears in agent mode's tool list.

   Note: `.vscode/mcp.json` uses the top-level key `servers` (the VS Code
   shape), while `obsidian/mcp-config.json.example` shows the generic
   `mcpServers` shape used by most other harnesses. This difference is
   intentional, not a typo. Do not copy the generic `mcpServers` shape
   straight into `.vscode/mcp.json`: VS Code will silently ignore a config
   under the wrong key, and the server will not appear in agent mode's tool
   list with no error shown.

## What Copilot cannot do (read before trusting)

- No hooks: nothing runs before or after a tool call. The vault write zones
  (`Inbox/`, `Gallery/`) are convention only; Copilot could write anywhere
  the MCP server allows. Mitigation: scope the filesystem MCP server to the
  vault's `Inbox/` and `Gallery/` folders only (two path arguments), not to
  the vault root, if you do not need read access to the rest.
- No stop gates: STATE.md updates during work happen only if the session
  follows the instruction.
- Session memory: Copilot does not load `memory/MEMORY.md` by itself. Start
  sessions with "Read memory/MEMORY.md and the STATE.md of <project>, then
  continue" or put that instruction prominently in `AGENTS.md`.

## Friction log

While using this adapter for real work, add one line per friction point to
[`../../VALIDATION.md`](../../VALIDATION.md) in the format used there. These
entries decide which rules need enforcement rather than requests.

---
Verified against VS Code docs: 2026-08-03
