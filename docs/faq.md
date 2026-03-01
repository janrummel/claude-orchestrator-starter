# FAQ

## General

### Do I need Obsidian?
No. The core system (CLAUDE.md + Skills + Memory files) works without Obsidian. Obsidian adds persistent note storage and semantic search, but you can start without it.

### Do I need the Knowledge Database?
No. It's optional and useful for structured data (research items, imported datasets). Start without it.

### Does this work with Claude Desktop (not Claude Code)?
Partially. CLAUDE.md works in Claude Desktop as a project file. Skills require the `/skill` command which is Claude Code specific. Memory files can be loaded manually.

### What model does this work with?
Any Claude model that supports Claude Code. The system is model-agnostic — it works through instruction files, not code.

## Skills

### How do I know which skill was invoked?
Check the routing log at `~/.claude/orchestrator/routing-log.jsonl`. Each entry shows the timestamp, input, skill invoked, and outcome.

### What if the wrong skill is invoked?
Tell Claude directly: "That's not what I meant, I wanted [X]." Then update `user-patterns.md` with the correction so it learns.

### Can I have multiple skills for the same trigger?
Yes. Use disambiguation rules in CLAUDE.md to specify which skill to prefer based on context.

### How many skills can I have?
As many as you want. The full system this starter kit is based on has 20+ skills. Start with the 6 included and add more as needed.

## Memory

### How does Claude remember across sessions?
Through three mechanisms:
1. **CLAUDE.md** is read at every session start
2. **Handoff files** preserve project state
3. **Episodic Memory** (if enabled via superpowers plugin) provides semantic search over past conversations

### What if my context window fills up?
The `context-reinject.md` hook ensures core rules survive context compression. For long sessions, use `/handoff` to save state before the window fills.

### Can I share memory files between machines?
Yes. The memory directory is just markdown files. Sync via Git, iCloud, Dropbox, or any file sync tool.

## Troubleshooting

### Claude ignores my CLAUDE.md
- Verify the file is at `~/.claude/CLAUDE.md` (exact path)
- Check file permissions: `ls -la ~/.claude/CLAUDE.md`
- Try restarting Claude Code

### Skills are not being invoked
- Check that the skill directory exists: `ls ~/.claude/orchestrator/skills/`
- Verify the SKILL.md file has correct frontmatter (name, description)
- Check routing rules in CLAUDE.md match your trigger words

### Obsidian connection fails
- Is Obsidian open? The REST API only works when Obsidian is running
- Check the port and API key in your MCP config
- Verify the Local REST API plugin is enabled in Obsidian
