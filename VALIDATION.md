# VALIDATION - phase 1

Purpose: collect evidence that the core works on a harness other than Claude Code,
with zero enforcement. This file is the phase-1 exit evidence and the input for
phase 2 (which skills the library actually needs).

Rules for this log:

- One line per friction point, written during or right after the session.
  Format: `friction: <YYYY-MM-DD> <what needed manual repair, was missing, or was ignored>`
- Do not polish and do not filter. A boring entry ("had to paste the memory path
  again") is worth more than a tidy summary, because it names the missing piece.
- Also log the opposite when it happens: `held: <YYYY-MM-DD> <rule the session followed
  without being reminded>`. Absence of friction is a finding too.
- Real work only. A demo session produces demo friction.

## Session log

| # | Date | Harness | Task in one line |
|---|------|---------|------------------|
| 1 | 2026-08-08 | Codex CLI 0.144.0 (`gpt-5.6-sol`) | Independent harness audit against an external rubric (real work: closed a 10-day-old open action in another repo) |
| 2 | 2026-11-09 | Codex CLI 0.155.1 (`gpt-6-astra`), workspace-write | Audited website body against README and wrote a concrete replacement list; state and inbox rules in use |
| 3 | 2026-11-09 | Codex CLI 0.155.1 (`gpt-6-astra`), workspace-write | Applied website body copy changes while preserving markup, hero and scripts |

## Friction entries

<!-- append below, newest last -->

friction: 2026-08-08 A Codex session on high reasoning effort runs far longer than a
subagent (over ten minutes for evidence gathering alone); invoking it under a timeout
kills it mid-reasoning.
friction: 2026-08-08 `codex exec resume` rejects the sandbox flags the first call
accepted (different argument order), and fails without a clear message.
friction: 2026-08-08 Process supervision is the real hurdle, not the instructions:
backgrounding with `nohup ... &` is not enough, the process dies when the shell session
ends. This is harness-specific and belongs in an adapter.
friction: 2026-08-08 A read-only sandbox means the agent cannot write its own report;
output has to be collected from stdout, and Codex prints its final message twice, so
extraction needs post-processing.
held: 2026-08-08 Smoke test: Codex named the three workflow phases, the pointer rule
*with its reasoning*, and the source file, unprompted and with no outside hint.
held: 2026-08-08 The session stayed read-only as instructed; no write attempts outside
its workspace.

held: 2026-11-09 Clarified the requested audit scope, produced a replacement list for the website body (kept outside the repo as a work note), and checked the result without editing docs/index.html.
held: 2026-11-09 Updated STATE.md during production, kept project status out of the memory index, and parked unrelated memory repair in the session workspace inbox.
friction: 2026-11-09 The memory index points to feedback_numbers_need_sources.md and feedback_finish_before_start.md, but neither file exists in this workspace.
friction: 2026-11-09 AGENTS.md asks for a startup “Continue?” confirmation even after an explicit task; followed the higher-priority autonomy instruction and proceeded with the authorized work.
held: 2026-11-09 Closed the audit by adopting its change list while leaving HTML implementation open; no new project was started.

friction: 2026-11-09 In the session workspace, the link check failed only on the two pre-existing missing memory feedback targets; git diff --check passed and the website HTML hash stayed unchanged.

Fixed after session 2 (2026-11-09): `AGENTS.md.example` no longer asks "Continue?" when the opening message already gives a task; `core/memory/MEMORY.md.example` shows example entries as plain names instead of links to files that do not exist yet.

### Session 3 observations

held: 2026-11-09 Session 3 read AGENTS.md first, the memory index, STATE.md and the amended design; began the explicit task without a confirmation prompt.
held: 2026-11-09 Session 3 followed clarify, produce and finish: fixed scope, edited body text, then compared the result with README and the original markup.
held: 2026-11-09 Session 3 updated STATE.md during production, kept status out of the memory index, and closed the task by adopting the scoped edits.
held: 2026-11-09 Session 3 used README as a primary repository specification rather than independent runtime proof; made no web requests or unsupported validation claims.
held: 2026-11-09 Session 3 preserved HTML tags, attributes, comments, head, hero and scripts; new text contains no em-dashes.
held: 2026-11-09 Session 3 kept work within the current project and parked memory repair in the local inbox.
friction: 2026-11-09 Session 3 was asked to mark the audit rows but forbidden to edit that file; recorded a complete per-row ledger in STATE.md instead. (Cause: contradictory task wording by the maintainer, not the kit.)
friction: 2026-11-09 Session 3 skipped the hero typewriter row because the task explicitly protects both hero and scripts.
friction: 2026-11-09 Session 3 kept SVG return-path detail in a caption and footer resource paths as plain text to preserve all existing markup and attributes.
friction: 2026-11-09 Session 3 found both linked memory feedback files still missing (cause: its workspace was set up from the session-2 copy, before the template fix); check-kit fails on those existing broken links. The inbox mentioned by the prior state was also absent and was created locally.
friction: 2026-11-09 Session 3 repaired an overbroad text substitution during diff review; final checks confirm unchanged markup and restored context-window wording.
friction: 2026-11-09 Session 3 did not perform browser-rendered layout verification; structural checks and diff review passed, but visual fit remains unverified.

## Review (fill at phase-1 exit)

Reviewed 2026-11-09 after three sessions, all on Codex.

- **Survived without enforcement:** the three workflow phases, the pointer rule (no status
  in the memory index), updating `STATE.md` during work, parking unrelated ideas in the
  inbox, staying inside the task's write boundary, and ending with a closure decision.
- **Broke, fixed in the core:** the start rule asked "Continue?" after an explicit task;
  the memory template linked files that did not exist yet. Both fixed in the templates after
  session 2, not yet re-tested in a session: session 3 ran on a copy made before the fix.
- **Not proven:** nothing here shows enforcement (Codex has no hooks), skill use on another
  harness, or any Copilot behaviour. Process supervision (timeouts, backgrounding) is the
  main friction and belongs in the Codex adapter, not in the core.
- **Skills missed by name:** none of the three tasks called for a skill, so phase 2 starts
  from the existing eight by default, not by evidence.
- **How independent this is:** sessions 2 and 3 ran on the same day, with the same model,
  on this kit's own website, and session 3 built on session 2. Three sessions show that the
  core can be followed; they do not show how it holds up for other people or other work.
