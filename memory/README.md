# Memory: folder layout (older variant)

> **Use [`core/memory/`](../core/memory/README.md) for new setups.** It keeps one fact per file with a pointer index, which works with any harness and does not drift. This folder is the layout of the first Claude-Code-only version. It stays so that existing setups and links keep working.

This directory stores persistent knowledge that the agent reads at session start.

## Structure

```
memory/
├── glossary.md         : Domain terms, abbreviations, jargon
├── context/
│   └── company.md      : Your work context (role, company, tools)
├── people/
│   └── template.md     : Key contacts and stakeholders
├── projects/
│   └── template.md     : Active project documentation
├── decisions/
│   └── template.md     : Decision log with rationale
└── workflows/
    └── template.md     : Proven workflows and best practices
```

## How It Works

1. **The agent reads** relevant memory files at session start
2. **You update** memory files as you learn new things
3. **The agent suggests** updates when it learns something new about you

## Guidelines

- Keep entries concise. The agent reads these every session
- Use consistent formatting within each file
- Date your entries for context
- Only store facts, not opinions (unless explicitly labeled as such)
