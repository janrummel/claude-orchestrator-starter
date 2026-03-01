# Knowledge Database (Optional)

A local SQLite database for structured data storage — research items, imported datasets, and skill usage statistics.

## Why a Database?

Some knowledge is better stored in structured form than in markdown files:
- Research items with metadata (tags, dates, sources)
- Imported CSV/Excel data for analysis
- Skill usage statistics for self-improvement

## Setup

```bash
# Create the database
sqlite3 ~/.claude/data/knowledge.db < schema.sql
```

## Usage

Claude can query the database directly:
```sql
SELECT title, tags, created_at FROM research_items
WHERE domain = 'your-domain'
ORDER BY created_at DESC LIMIT 10;
```

## Connecting via MCP

You can use an SQLite MCP server to give Claude direct database access:

```json
{
  "mcpServers": {
    "knowledge-db": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-sqlite", "~/.claude/data/knowledge.db"]
    }
  }
}
```
