# Memory convention

Memory is a directory of markdown files plus one index. No database, no
product feature, works with any harness that can read files.

## Layout

```
memory/
├── MEMORY.md              # index: one line per memory
├── inbox.md               # transient captures, only when no vault is connected
├── user_profile.md        # example: who the user is
├── feedback_<rule>.md     # example: a working rule the user gave
└── project_<name>.md      # example: pointer to a project
```

`inbox.md` is the fallback capture surface referenced by `AGENTS.md.example`. With a
connected Obsidian vault the vault's `Inbox/` zone takes that role and this file stays
absent. Either way, captures are triaged and emptied, never accumulated.

## Rules

1. One file = one fact. Small files stay correct; big files rot.
2. `MEMORY.md` holds pointers only (link + one-line hook). Content lives in
   the fact files. The index is what a session loads first.
3. Project memories are pointers to the project's own `STATE.md`, never a
   status copy. Two copies drift; the repo wins.
4. Update or delete before you add. Duplicates are worse than gaps.
5. Feedback memories record the why, not only the rule, so a future session
   can judge whether the rule still applies.

## File format

See `fact-file.md.template`. Frontmatter fields: `name` (kebab-case slug),
`description` (one line, used to judge relevance), `type`
(user | feedback | project | reference).

## Portability note

This is a requested convention. No harness enforces it by itself. The
Copilot adapter cannot enforce it at all (no hooks); the Claude Code adapter
(phase 3) can partially enforce it. See `../../docs/portability.md`.
