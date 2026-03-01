# Obsidian Integration (Optional)

Connect your Obsidian vault to Claude Code so it can read and write your notes.

## Why Obsidian?

Obsidian serves as Claude's **long-term memory** — a searchable, linkable knowledge base that persists forever. Claude can:

- **Read** your notes for context before answering
- **Write** new notes (captures, summaries, drafts)
- **Search** semantically across your vault

## Requirements

1. [Obsidian](https://obsidian.md) installed
2. [Local REST API](https://github.com/coddingtonbear/obsidian-local-rest-api) plugin (v3.4+)
3. [MCP Tools](https://github.com/jacksteamdev/obsidian-mcp-tools) plugin (v0.2+)

## Setup

### 1. Install Obsidian Plugins

In Obsidian → Settings → Community Plugins:
- Install "Local REST API"
- Install "MCP Tools"
- Enable both

### 2. Configure Local REST API

- Settings → Local REST API
- Note the **port** (default: 27124) and **API key**

### 3. Connect to Claude Code

Add to your Claude Desktop config (`~/Library/Application Support/Claude/claude_desktop_config.json` on macOS):

```json
{
  "mcpServers": {
    "obsidian": {
      "command": "path/to/obsidian-mcp-server",
      "env": {
        "OBSIDIAN_API_KEY": "your-api-key-here"
      }
    }
  }
}
```

### 4. Test the Connection

Start Claude Code and try:
```
Search my Obsidian vault for "test"
```

## Vault Template

The `vault-template/` directory contains a minimal Obsidian vault structure you can use as a starting point:

```
vault-template/
├── Home.md              — Dashboard/landing page
├── Inbox/               — Quick captures land here
└── Templates/           — Note templates
```

## Multiple Vaults

For advanced setups, you can connect multiple vaults:
- Each vault needs its own REST API port
- Each vault needs its own MCP server binary
- See the architecture docs for details on multi-vault setups
