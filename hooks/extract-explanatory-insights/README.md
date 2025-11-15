# Extract Explanatory Insights Hook

Automatically extracts `★ Insight` blocks from Claude Code Explanatory output style responses and organizes them into categorized lessons-learned documentation.

## What It Does

When you use Claude Code with the Explanatory output style, Claude provides educational insights in formatted blocks:

```
★ Insight ─────────────────────────────────────
Educational content explaining implementation choices,
architectural decisions, and best practices.
─────────────────────────────────────────────────
```

This hook automatically:
1. **Detects** insight blocks in Claude's responses
2. **Categorizes** them by topic (testing, architecture, security, etc.)
3. **Saves** them to `docs/lessons-learned/{category}/insights.md`
4. **Maintains** an index with metadata and search instructions

## Installation

### From Claudex Marketplace

```bash
# Add claudex marketplace
/plugin marketplace add cskiro/claudex

# Install the hook
/plugin install extract-explanatory-insights@claudex
```

### Manual Installation

1. Copy the hook directory to your project's `.claude/hooks/` directory
2. Register the hook in `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "*",
        "type": "command",
        "command": "./.claude/hooks/extract-explanatory-insights.sh"
      }
    ]
  }
}
```

## Output Structure

The hook creates the following structure in your project:

```
docs/lessons-learned/
├── README.md                    # Auto-generated index
├── architecture/
│   └── insights.md
├── configuration/
│   └── insights.md
├── hooks-and-events/
│   └── insights.md
├── performance/
│   └── insights.md
├── react/
│   └── insights.md
├── security/
│   └── insights.md
├── testing/
│   └── insights.md
├── typescript/
│   └── insights.md
├── version-control/
│   └── insights.md
└── general/
    └── insights.md
```

## Auto-Categorization

Insights are automatically categorized based on content analysis:

| Category | Triggers |
|----------|----------|
| **testing** | test, testing, coverage, tdd, vitest, jest |
| **configuration** | config, settings, inheritance, precedence |
| **hooks-and-events** | hook, lifecycle, event, trigger |
| **security** | security, vulnerability, auth, permission |
| **performance** | performance, optimize, cache, memory |
| **architecture** | architecture, design, pattern, structure |
| **version-control** | git, commit, branch, merge, pr, pull request |
| **react** | react, component, tsx, jsx, hooks |
| **typescript** | typescript, type, interface, generic |
| **general** | Everything else |

## Usage

### Enable Explanatory Output Style

First, ensure you're using the Explanatory output style:

```bash
/output-style explanatory
```

### Work Normally

The hook runs automatically after every Claude response. When Claude provides an insight, it's automatically extracted and saved.

### Review Insights

Browse your accumulated knowledge:

```bash
# View the index
cat docs/lessons-learned/README.md

# View testing insights
cat docs/lessons-learned/testing/insights.md

# Search all insights
grep -r "your search term" docs/lessons-learned/
```

## Manual Recategorization

If an insight is categorized incorrectly:

1. Cut the insight from the current category file
2. Paste it into the appropriate category file
3. The index will auto-update on the next extraction

## Requirements

- **Claude Code**: >=1.0.0
- **Bash**: >=4.0
- **jq**: >=1.6 (for JSON parsing)

## Exit Codes

- `0`: Success (insights extracted or none found)
- `1`: No insights found (silent)
- `2`: Error (blocks execution)

## Privacy & Safety

- The hook only reads Claude's responses from transcripts
- No data is sent externally
- All insights are stored locally in your project
- The hook skips execution in non-project directories (like `~/.claude`)

## Examples

### Example Insight Entry

```markdown
## Strategic Architecture Decision

**Captured**: 2025-11-14 18:45:23
**Session**: abc123

**Strategic Architecture Decision**: The v1.0.0 restructure represents a maturation
from "skill marketplace" to "comprehensive plugin marketplace." By organizing
features into type-specific directories (skills/, hooks/, commands/, agents/),
we're following Anthropic's official plugin structure while setting up for
sustainable growth.

---
```

## Troubleshooting

### Hook Not Triggering

1. Verify hook is installed: `/plugin list`
2. Check settings: `cat .claude/settings.json`
3. Ensure Explanatory style is active: `/output-style`

### Insights Not Being Extracted

1. Verify Claude is providing `★ Insight` blocks
2. Check permissions on the hook script: `ls -l .claude/hooks/`
3. Review hook logs in Claude Code console

### Categories Not Auto-Creating

The hook creates categories on-demand. If a category doesn't exist, no insights in that category have been captured yet.

## License

Apache-2.0

## Contributing

Issues and pull requests welcome at: https://github.com/cskiro/claudex
