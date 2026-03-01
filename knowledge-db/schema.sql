-- Knowledge Database Schema
-- Run: sqlite3 ~/.claude/data/knowledge.db < schema.sql

-- Research items (articles, papers, findings)
CREATE TABLE IF NOT EXISTS research_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    source TEXT,              -- URL, DOI, book title
    domain TEXT,              -- e.g., 'engineering', 'ai', 'energy'
    tags TEXT,                -- JSON array: ["tag1", "tag2"]
    summary TEXT,             -- Brief summary
    obsidian_path TEXT,       -- Path to related Obsidian note
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);

-- Skill usage tracking
CREATE TABLE IF NOT EXISTS skills_usage (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    skill_name TEXT NOT NULL,
    triggered_by TEXT,        -- What domain/context triggered it
    input_summary TEXT,       -- Brief description of input
    outcome TEXT DEFAULT 'pending',  -- pending/positive/negative/reflection
    created_at TEXT DEFAULT (datetime('now'))
);

-- Imported datasets catalog
CREATE TABLE IF NOT EXISTS imported_datasets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT NOT NULL,
    source_file TEXT,         -- Original CSV/Excel filename
    description TEXT,
    row_count INTEGER,
    column_names TEXT,        -- JSON array of column names
    imported_at TEXT DEFAULT (datetime('now'))
);

-- Cross-vault search index (optional, for multi-vault setups)
CREATE TABLE IF NOT EXISTS vault_index (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    vault TEXT NOT NULL,
    filepath TEXT NOT NULL,
    title TEXT,
    note_type TEXT,           -- e.g., 'note', 'draft', 'research', 'decision'
    domain TEXT,
    tags TEXT,                -- JSON array
    summary TEXT,
    updated_at TEXT DEFAULT (datetime('now')),
    UNIQUE(vault, filepath)
);
