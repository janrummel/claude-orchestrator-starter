# Obsidian as the knowledge layer

Obsidian is the one knowledge vault this kit recommends, and it is optional: the
human-owned knowledge vault. The agent connects to it via MCP, which every target harness speaks.

## Connection: filesystem MCP server

The simplest robust option needs no Obsidian plugin: a filesystem MCP server
scoped to the vault path. The agent sees the vault as files; Obsidian sees
the same files and renders them. See `mcp-config.json.example` and your
harness adapter for where the config goes.

If you want richer, Obsidian-aware operations (search over links, frontmatter
queries), an Obsidian-specific MCP server can replace the filesystem server
later; the zone rules below stay the same.

## Write zones (the important part)

The agent is asked to write to two zones only. Only scoping the MCP server to those
folders (see `mcp-config.json.example`) actually enforces it:

| Zone       | Who writes            | Purpose                              |
|------------|-----------------------|--------------------------------------|
| `Inbox/`   | agent (and you)       | transient capture, triage zone       |
| `Gallery/` | agent, curated only   | polished output examples             |
| everything else | you (the human)  | the agent reads, never writes        |

The human promotes notes out of `Inbox/` into the vault proper. This keeps
the vault yours: the agent feeds it, you curate it.

Why so strict: an agent that writes anywhere in a knowledge vault will,
over months, quietly restructure it around its own conventions. The vault
then belongs to the tool, not to you.

## Note format

Notes going to `Inbox/` carry a date-prefixed filename
(`YYYY-MM-DD-<topic>.md`) and a one-line source note at the top (who wrote
it, from which session or task).

## Alternative: Obsidian plugins

If you want the agent to search through Obsidian itself (links, frontmatter), use the two community plugins instead of the filesystem server. The write zones above stay the same.

### Requirements

1. [Obsidian](https://obsidian.md) installed
2. [Local REST API](https://github.com/coddingtonbear/obsidian-local-rest-api) plugin (v3.4+)
3. [MCP Tools](https://github.com/jacksteamdev/obsidian-mcp-tools) plugin (v0.2+)


#### 1. Install Obsidian Plugins

In Obsidian → Settings → Community Plugins:
- Install "Local REST API"
- Install "MCP Tools"
- Enable both

#### 2. Configure Local REST API

- Settings → Local REST API
- Note the **port** (default: 27124) and **API key**

#### 3. Connect your harness

Add the server to your harness MCP config (for Claude Code: `claude mcp add` or `.mcp.json`; others: see your adapter):

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

#### 4. Test the Connection

Start your agent and try:
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
