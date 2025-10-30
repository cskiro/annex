# Claudex - Claude Code Skills

> A curated collection of experimental skills for [Claude Code](https://claude.com/claude-code)

This repository contains skills that extend Claude Code's capabilities for common software engineering tasks. Currently in proof-of-concept/beta phase with local testing.

## ✨ Featured: cc-insights (NEW!)

**Never lose a conversation again.** The cc-insights skill automatically indexes your Claude Code conversations with RAG-powered semantic search. Find past solutions, generate insight reports, and track development patterns—completely automatic.

```
"Search my conversations about React accessibility"
→ Returns ranked semantic matches with context

"Generate a weekly insights report"
→ Activity timeline, file hotspots, tool usage analytics
```

[Try it now →](./cc-insights/README.md)

## Quick Start

### Install via Marketplace (Recommended)

Add the claudex marketplace to your Claude Code:

```bash
/plugin marketplace add cskiro/claudex
```

Then browse and install skills:

```bash
# Browse all available skills
/plugin

# Or install specific skills directly
/plugin install codebase-auditor@claudex
/plugin install bulletproof-react-auditor@claudex
/plugin install claude-md-auditor@claudex
/plugin install cc-insights@claudex
```

### Team Configuration (Auto-Install)

Add to your project's `.claude/settings.json` for automatic setup:

```json
{
  "extraKnownMarketplaces": {
    "claudex": {
      "source": {
        "source": "github",
        "repo": "cskiro/claudex"
      }
    }
  },
  "enabledPlugins": [
    "codebase-auditor@claudex",
    "bulletproof-react-auditor@claudex",
    "claude-md-auditor@claudex",
    "cc-insights@claudex"
  ]
}
```

When team members trust your repository, these plugins install automatically.

### Manual Installation (Legacy)

<details>
<summary>Click to expand legacy installation instructions</summary>

#### Global Installation

```bash
# Clone this repository
git clone https://github.com/cskiro/claudex.git

# Install a skill globally
cp -r claudex/codebase-auditor ~/.claude/skills/

# Use in any project
cd /path/to/your-project
# In Claude Code, just ask: "Audit this codebase"
```

#### Project-Local Installation

```bash
# In your project directory
mkdir -p .claude/skills
cp -r /path/to/claudex/codebase-auditor .claude/skills/

# Skill now available only in this project
```

**Note**: Manual installation is deprecated in favor of marketplace installation. See [Migration Guide](./docs/MIGRATION_GUIDE.md) for upgrade instructions.

</details>

## Available Skills

### 🔍 Codebase Auditor

Comprehensive static analysis tool that audits codebases for quality, security, and technical debt.

- **Categories**: Code quality, security, testing, dependencies, performance
- **Output**: Markdown reports with prioritized remediation plans
- **Standards**: Based on 2024-25 SDLC best practices (OWASP, WCAG, DORA)

**Usage**: "Audit this codebase" or "Run a security audit"

[📖 Full Documentation](./codebase-auditor/README.md)

---

### ⚛️ Bulletproof React Auditor

React application auditor based on the comprehensive [Bulletproof React](https://github.com/alan2207/bulletproof-react) architecture guide. Evaluates React projects against production-ready standards.

- **Categories**: Project structure, component patterns, state management, performance, security
- **Output**: Detailed markdown reports with actionable recommendations
- **Standards**: Bulletproof React architecture patterns + React 18 best practices

**Usage**: "Audit my React application" or "Review this React codebase against Bulletproof standards"

[📖 Full Documentation](./bulletproof-react-auditor/README.md)

---

### 📋 CLAUDE.md Auditor

Validates and audits CLAUDE.md configuration files for Claude Code. Ensures compliance with schema standards and best practices for LLM configuration.

- **Categories**: Schema validation, structure compliance, best practices, completeness
- **Output**: Validation reports with severity levels (critical, warning, info)
- **Standards**: CLAUDE.md schema v1.0 specification

**Usage**: "Audit my CLAUDE.md file" or "Validate the Claude configuration"

[📖 Full Documentation](./claude-md-auditor/README.md)

---

### 💡 cc-insights (Conversation Insights)

Automatically processes Claude Code conversation history, enables RAG-powered semantic search, and generates intelligent insight reports about development patterns.

- **Features**: Semantic search, pattern detection, file hotspots, tool usage analytics
- **Technology**: RAG (sentence-transformers), ChromaDB, SQLite
- **Output**: Weekly reports, activity trends, searchable knowledge base
- **Zero Manual Effort**: Fully automatic processing of existing conversations

**Usage**: "Search my conversations about React testing" or "Generate a weekly insights report"

[📖 Full Documentation](./cc-insights/README.md)

---

## Repository Structure

```
claudex/
├── codebase-auditor/              # General codebase auditor
│   ├── SKILL.md                   # Skill definition
│   ├── README.md                  # Documentation
│   ├── scripts/                   # Python analysis engine
│   ├── reference/                 # Audit standards
│   └── examples/                  # Sample reports
│
├── bulletproof-react-auditor/     # React-specific auditor
│   ├── SKILL.md                   # Skill definition
│   ├── README.md                  # Documentation
│   ├── scripts/                   # Analysis scripts
│   └── reference/                 # Bulletproof React standards
│
├── claude-md-auditor/             # CLAUDE.md validator
│   ├── SKILL.md                   # Skill definition
│   ├── README.md                  # Documentation
│   ├── scripts/                   # Validation scripts
│   └── reference/                 # Schema specifications
│
├── cc-insights/                   # Conversation insights
│   ├── SKILL.md                   # Skill definition
│   ├── README.md                  # Documentation
│   ├── requirements.txt           # Python dependencies
│   ├── scripts/                   # Processing & search
│   │   ├── conversation-processor.py
│   │   ├── rag_indexer.py
│   │   ├── search-conversations.py
│   │   └── insight-generator.py
│   └── templates/                 # Report templates
│
└── docs/                          # General documentation
    ├── SKILL_INSTALLATION_GUIDE.md
    └── CODEBASE_AUDITOR_SKILL.md
```

## How Skills Work

1. **Discovery**: Claude Code automatically scans `~/.claude/skills/` (global) and `.claude/skills/` (local)
2. **Loading**: Each skill has a `SKILL.md` file that Claude reads to understand capabilities
3. **Invocation**: Simply describe what you want in natural language
4. **Execution**: Claude uses the skill's scripts and reference materials to complete the task

## Creating Your Own Skills

See [SKILL_INSTALLATION_GUIDE.md](./docs/SKILL_INSTALLATION_GUIDE.md) for detailed instructions on:
- Skill structure and conventions
- Writing effective `SKILL.md` files
- Testing and debugging skills
- Global vs. local skill installation

## Contributing

Have a useful skill to share? Contributions welcome!

1. Fork this repository
2. Create a new directory for your skill (follow existing structure)
3. Include: `SKILL.md`, `README.md`, scripts, reference materials, examples
4. Submit a pull request

**Skill Quality Standards:**
- Clear documentation with examples
- Follows modern best practices (2024-25)
- Includes reference materials for context
- Documented code (testing in progress)

## Best Practices

✅ **Do:**
- Install skills via marketplace for automatic updates: `/plugin install skill-name@claudex`
- Use team configuration (`.claude/settings.json`) to standardize plugins across projects
- Pin specific versions for production stability (when available)
- Review generated reports before taking action
- Use descriptive natural language when invoking skills

⚠️ **Don't:**
- Manually copy skills anymore (use marketplace installation)
- Commit `.claude/skills/` in projects (already in `.gitignore`)
- Store sensitive data in skill directories
- Skip version pinning in production environments

## Documentation

### Skill Documentation
- [Codebase Auditor](./codebase-auditor/README.md) - General code quality auditing
- [Bulletproof React Auditor](./bulletproof-react-auditor/README.md) - React architecture patterns
- [CLAUDE.md Auditor](./claude-md-auditor/README.md) - Configuration validation
- [cc-insights](./cc-insights/README.md) - Conversation analysis & semantic search

### General Documentation
- [Migration Guide](./docs/MIGRATION_GUIDE.md) - Upgrade from manual to marketplace installation
- [Skill Installation Guide](./docs/SKILL_INSTALLATION_GUIDE.md) - Complete setup instructions (legacy)
- [Handoff Summaries](./docs/) - Development session summaries

## Requirements

- [Claude Code](https://claude.com/claude-code) - Latest version
- Python 3.8+ (for Python-based skills)
- Git (for version control and updates)

### Additional Requirements for cc-insights
- Python dependencies: `sentence-transformers`, `chromadb`, `jinja2`, `click`, `python-dateutil`
- ~500MB disk space (for 1,000 conversations)
- 2GB RAM (for embedding generation)

## Version History

**v2.0.0-beta** (2025-10-26) - Expanded Skills Collection (Proof of Concept)
- ✨ NEW: cc-insights - RAG-powered conversation analysis
- Added: Bulletproof React Auditor
- Added: CLAUDE.md Auditor
- Enhanced: Codebase Auditor with updated standards
- Note: Tested locally on 1-2 projects, not production-validated

**v1.0.0-beta** (2025-10-25) - Initial release with Codebase Auditor skill

## License

Apache 2.0

---

**Maintained by**: Connor
**Last Updated**: 2025-10-26
**Current Version**: v2.0.0-beta
**Status**: Proof of Concept / Beta

*Experimental skills for extending Claude Code capabilities across auditing, validation, and conversation analysis. Tested locally on limited projects.*
