# Memory — Long-Term Knowledge Base

This directory stores persistent knowledge that Claude reads at session start.

## Structure

```
memory/
├── glossary.md          — Domain terms, abbreviations, jargon
├── context/
│   └── company.md       — Your work context (role, company, tools)
├── people/
│   └── template.md      — Key contacts and stakeholders
├── projects/
│   └── template.md      — Active project documentation
├── decisions/
│   └── template.md      — Decision log with rationale
└── workflows/
    └── template.md      — Proven workflows and best practices
```

## How It Works

1. **Claude reads** relevant memory files at session start
2. **You update** memory files as you learn new things
3. **Claude suggests** updates when it learns something new about you

## Guidelines

- Keep entries concise — Claude reads these every session
- Use consistent formatting within each file
- Date your entries for context
- Only store facts, not opinions (unless explicitly labeled as such)
