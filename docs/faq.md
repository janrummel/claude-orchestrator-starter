# FAQ

## General

### What is this built for?
Claude Code (the CLI tool). The core system — CLAUDE.md, skills, memory — is platform-agnostic. The hooks and session chaining features are CLI-specific.

### Does this work with Claude Desktop (macOS app)?
Partially. CLAUDE.md works in Claude Desktop as a project file. Skills can be invoked manually. However, hooks, the statusbar, and session chaining are Claude Code CLI features.

### Do I need Obsidian?
No. The core system works without Obsidian. Obsidian adds persistent note storage and semantic search, but you can start without it. Skills that use Obsidian fall back to local `~/.claude/memory/` files.

### Do I need the Knowledge Database?
No. It's optional and useful for structured data (research items, imported datasets). Start without it.

### What model does this work with?
Any Claude model that supports Claude Code. The system is model-agnostic — it works through instruction files, not code.

## Session & Context

### What if my context window fills up?
The hooks handle this automatically:

1. **Statusbar** shows context usage in real-time (color-coded progress bar)
2. **At 35% remaining (WARNING):** Claude is told to wrap up the current task
3. **At 25% remaining (CRITICAL):** Claude is instructed to write a session handoff file with your current task, progress, decisions, and next steps
4. **When the session ends:** `claude-loop` detects the handoff file and offers to start a new session
5. **New session starts:** `session-start.sh` reads the handoff file and injects it as context

No manual action needed — your state is preserved automatically.

### What is claude-loop?
A wrapper script that replaces the `claude` command. It keeps you in the same terminal: when a session ends, it asks if you want to continue. If a handoff file exists, the new session picks up your saved state. If not, it uses `--continue` to resume the previous conversation.

### Can I still use plain `claude` without claude-loop?
Yes. Everything works without `claude-loop`. The hooks still monitor context and save state. You just need to start a new session manually when context fills up — the session-start hook will still detect and inject the handoff file.

### How does Claude remember across sessions?
Through three mechanisms:
1. **CLAUDE.md** is read at every session start (permanent rules and preferences)
2. **Handoff files** preserve project state (automatic or manual via `/handoff`)
3. **Episodic Memory** (if enabled via superpowers plugin) provides semantic search over past conversations

### Can I use `.claude/rules/` instead of a big CLAUDE.md?
Yes. Since Claude Code v2.0.64, you can put conditional rules in `.claude/rules/` with glob-scoped YAML frontmatter (e.g., `paths: ["src/**/*.ts"]`). Rules only load when Claude works on matching files. This keeps your context leaner. Start with the monolithic CLAUDE.md from this kit, then split into rules as your system grows.

### Can I trigger `/compact` automatically?
Not directly from hooks — hooks can't execute slash commands. But the CLAUDE.md instructions tell Claude to proactively suggest compacting when context usage climbs. You can also type `/compact [focus topic]` manually at any time to compress context around a specific topic.

## Skills

### How do I know which skill was invoked?
Check the routing log at `~/.claude/orchestrator/routing-log.jsonl`. Each entry shows the timestamp, input, skill invoked, and outcome.

### What if the wrong skill is invoked?
Tell Claude directly: "That's not what I meant, I wanted [X]." Then update `user-patterns.md` with the correction so it learns.

### Can I have multiple skills for the same trigger?
Yes. Use disambiguation rules in CLAUDE.md to specify which skill to prefer based on context.

### How many skills can I have?
As many as you want. The full system this starter kit is based on has 20+ skills. Start with the 7 included and add more as needed.

## Memory

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

### Statusbar not showing context usage
- Verify `context-statusline.js` is at `~/.claude/hooks/context-statusline.js`
- Check your `settings.json` has the `statusLine` section
- Restart Claude Code

### Session chaining not working
- Make sure `~/.claude/orchestrator/` directory exists: `mkdir -p ~/.claude/orchestrator/projects`
- Check that `context-monitor.js` is configured in `settings.json` under `PostToolUse`
- Verify `session-start.sh` is executable: `chmod +x ~/.claude/hooks/session-start.sh`

### Obsidian connection fails
- Is Obsidian open? The REST API only works when Obsidian is running
- Check the port and API key in your MCP config
- Verify the Local REST API plugin is enabled in Obsidian
