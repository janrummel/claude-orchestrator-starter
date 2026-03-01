# Claude Orchestrator Starter Kit

> Mache aus Claude Code einen persoenlichen KI-Assistenten — mit persistentem Gedaechtnis, eigenen Skills und Obsidian als Wissensbasis.

**[English version](README.md)**

## Was ist das?

Ein Starter Kit, um einen **persoenlichen Orchestrator** auf [Claude Code](https://docs.anthropic.com/en/docs/claude-code) aufzubauen. Statt Claude als zustandslosen Chatbot zu nutzen, bekommt es damit:

- **Gedaechtnis** das ueber Sessions hinweg bestehen bleibt (Kurzzeit, Mittelzeit, Langzeit)
- **Skills** — wiederverwendbare Workflows, ausgeloest durch natuerliche Sprache oder `/Befehle`
- **Routing** — automatische Erkennung, welcher Skill zu deiner Anfrage passt
- **Obsidian-Integration** — deine Notizen werden Claudes Wissensbasis

```
┌──────────────────────────────────────────────────┐
│  KURZZEIT (Context Window)                       │
│  Aktuelle Konversation, temporaere Ergebnisse    │
│  Lebensdauer: 1 Session                          │
├──────────────────────────────────────────────────┤
│  MITTELZEIT (Episodic Memory + State-Dateien)    │
│  Vergangene Sessions, Routing-Entscheidungen     │
│  Lebensdauer: Wochen bis Monate                  │
├──────────────────────────────────────────────────┤
│  LANGZEIT (CLAUDE.md + Wissensbasis)             │
│  Routing-Regeln, Praeferenzen, Glossar,          │
│  Unternehmenskontext, Projektdokumentation       │
│  Lebensdauer: Permanent                          │
└──────────────────────────────────────────────────┘
```

## Schnellstart (5 Minuten)

### Voraussetzungen

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installiert und funktionsfaehig
- Ein Terminal

### Einrichtung

```bash
# 1. Repo klonen
git clone https://github.com/janrummel/claude-orchestrator-starter.git
cd claude-orchestrator-starter

# 2. Orchestrator in deine Claude-Konfiguration kopieren
cp CLAUDE.md.example ~/.claude/CLAUDE.md
cp -r orchestrator/ ~/.claude/orchestrator/
cp -r memory/ ~/.claude/memory/
cp -r hooks/ ~/.claude/hooks/

# 3. Claude Code starten — fertig.
claude
```

Claude wird jetzt:
- `CLAUDE.md` beim Start lesen und seine Rolle verstehen
- Deine Anfragen an passende Skills weiterleiten
- Das Gedaechtnissystem nutzen, um Kontext ueber Sessions hinweg zu behalten

### Optional: Obsidian-Integration

Falls du [Obsidian](https://obsidian.md) als Notiz-App nutzt, siehe [Obsidian-Einrichtung](docs/obsidian-setup.md) um deinen Vault als Claudes Wissensbasis zu verbinden.

### Optional: Wissensdatenbank

Fuer strukturierte Datenspeicherung (Recherche-Ergebnisse, importierte Datensaetze), siehe [Knowledge DB Setup](docs/knowledge-db-setup.md).

## Architektur

### Die drei Schichten

| Schicht | Was | Wo | Lebensdauer |
|---------|-----|-----|-------------|
| **Kurzzeit** | Aktuelle Konversation | Context Window | 1 Session |
| **Mittelzeit** | Vergangene Sessions, Routing-Log | `orchestrator/routing-log.jsonl`, Episodic Memory | Wochen–Monate |
| **Langzeit** | Regeln, Praeferenzen, Wissen | `CLAUDE.md`, `memory/`, Obsidian | Permanent |

### Skills

Skills sind wiederverwendbare Workflows, definiert als `SKILL.md`-Dateien. Jeder Skill sagt Claude, **wie** es eine bestimmte Art von Anfrage bearbeiten soll.

Dieses Starter Kit enthaelt 6 Kern-Skills:

| Skill | Zweck | Trigger-Beispiele |
|-------|-------|------------------|
| `capture` | Schnelle Notizen in Obsidian | "Notiere das", "Idee festhalten" |
| `distill` | Zusammenfassen und verdichten | "Zusammenfassen", "Kernaussagen" |
| `express` | Ausgefeilten Output schreiben | "Schreibe", "Formuliere" |
| `analyze` | Tiefenanalyse mit strukturiertem Denken | "Analysiere", "Untersuche" |
| `signal-check` | Qualitaetspruefung / Faktencheck | "Ist das solide?", "Substanz-Check" |
| `handoff` | Session-Zustand fuer naechstes Mal sichern | "Zustand sichern", "Handoff" |

Diese 6 bilden zwei zentrale Schleifen:

**Evaluator-Optimizer-Schleife:**
```
express → signal-check → express (verbessert)
```

**Wissenszyklus:**
```
capture → distill → express → signal-check
    ↑                              │
    └──── analyze ← handoff ←─────┘
```

### Routing

Die `CLAUDE.md`-Datei enthaelt Routing-Regeln, die Schluesselwoerter auf Skills abbilden. Wenn du etwas sagst, prueft Claude auf passende Muster und ruft automatisch den richtigen Skill auf.

Beispiel:
- "Fasse diesen Artikel zusammen" → erkennt "zusammenfassen" → ruft `distill` auf
- "Ist diese Analyse solide?" → erkennt "Qualitaetspruefung" → ruft `signal-check` auf

### Gedaechtnis

Das `memory/`-Verzeichnis bietet Langzeitspeicherung:

```
memory/
├── glossary.md          — Fachbegriffe und Jargon
├── context/
│   └── company.md       — Arbeitskontext (Rolle, Unternehmen, Tools)
├── people/              — Wichtige Kontakte und Stakeholder
├── projects/            — Aktive Projektdokumentation
├── decisions/           — Entscheidungslog mit Begruendung
└── workflows/           — Bewaehrte Workflows und Best Practices
```

## Eigene Skills entwickeln

Siehe [Skill Development Guide](docs/skill-development.md) fuer eine Schritt-fuer-Schritt-Anleitung zum Erstellen eigener Skills.

Die Kurzversion:

```bash
# 1. Skill-Verzeichnis erstellen
mkdir -p ~/.claude/orchestrator/skills/mein-skill

# 2. SKILL.md schreiben
cat > ~/.claude/orchestrator/skills/mein-skill/SKILL.md << 'EOF'
---
name: mein-skill
description: Was dieser Skill tut und wann er verwendet werden soll.
---

# Mein Skill

Anweisungen fuer Claude, wie dieser Skill auszufuehren ist.

## Workflow
1. Schritt eins
2. Schritt zwei
3. Schritt drei
EOF

# 3. Routing-Regeln in CLAUDE.md ergaenzen
# Schluesselwort → Skill-Zuordnung zur Routing-Tabelle hinzufuegen
```

## Was NICHT enthalten ist

Dies ist ein **Starter Kit**, kein fertiges System. Du wirst vermutlich:

- Skills fuer deine Domaene ergaenzen (Engineering, Sales, Forschung, etc.)
- Routing-Regeln an dein Vokabular anpassen
- Unternehmenskontext, Glossar und Kontakte ausfuellen
- Die Ausgabesprache anpassen (dieses Kit ist standardmaessig auf Englisch)
- Deine(n) Obsidian-Vault(s) anbinden, falls du Obsidian nutzt

## Inspiration

Dieses Starter Kit basiert auf einem realen System, das taeglich fuer Engineering, Recherche und Wissensmanagement im Einsatz ist. Das vollstaendige System umfasst 20+ eigene Skills, 6 verbundene Obsidian-Vaults, eine SQLite-Wissensdatenbank und automatisierte Session-Handoffs.

## Lizenz

MIT — nutzen, forken, zu deinem machen.

## Mitmachen

Siehe [CONTRIBUTING.md](CONTRIBUTING.md).
