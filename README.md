# Annex - Claude Code Skills

> A curated collection of production-ready skills for [Claude Code](https://claude.com/claude-code)

This repository contains reusable, battle-tested skills that extend Claude Code's capabilities for common software engineering tasks.

## Quick Start

### Global Installation (Recommended)

Install skills globally to use them across all your projects:

```bash
# Clone this repository
git clone https://github.com/cskiro/annex.git

# Install a skill globally
cp -r annex/codebase-auditor ~/.claude/skills/

# Use in any project
cd /path/to/your-project
# In Claude Code, just ask: "Audit this codebase"
```

### Project-Local Installation

Install skills for a specific project only:

```bash
# In your project directory
mkdir -p .claude/skills
cp -r /path/to/annex/codebase-auditor .claude/skills/

# Skill now available only in this project
```

## Available Skills

### 🔍 Codebase Auditor

Comprehensive static analysis tool that audits codebases for quality, security, and technical debt.

- **Categories**: Code quality, security, testing, dependencies, performance
- **Output**: Markdown reports with prioritized remediation plans
- **Standards**: Based on 2024-25 SDLC best practices (OWASP, WCAG, DORA)

**Usage**: "Audit this codebase" or "Run a security audit"

[📖 Full Documentation](./codebase-auditor/README.md)

---

## Repository Structure

```
annex/
├── codebase-auditor/     # Comprehensive code audit skill
│   ├── SKILL.md          # Skill definition
│   ├── README.md         # Detailed documentation
│   ├── scripts/          # Python analysis engine
│   ├── reference/        # Audit criteria & standards
│   └── examples/         # Sample reports
│
└── docs/                 # General documentation
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
- Production-ready code quality

## Best Practices

✅ **Do:**
- Install frequently-used skills globally (`~/.claude/skills/`)
- Keep skill-specific docs in the skill directory
- Use descriptive natural language when invoking skills
- Review generated reports before taking action

⚠️ **Don't:**
- Commit `.claude/skills/` in projects (already in `.gitignore`)
- Store sensitive data in skill directories
- Modify global skills for project-specific needs (use local copy instead)

## Documentation

- [Skill Installation Guide](./docs/SKILL_INSTALLATION_GUIDE.md) - Complete setup instructions
- [Codebase Auditor Docs](./codebase-auditor/README.md) - Audit skill reference

## Requirements

- [Claude Code](https://claude.com/claude-code) - Latest version
- Python 3.8+ (for Python-based skills)
- Git (for version control and updates)

## Version

**v1.0.0** - Initial release with Codebase Auditor skill

## License

Apache 2.0

---

**Maintained by**: Connor
**Last Updated**: 2025-10-25

*Built for engineers who value production-ready tooling*
