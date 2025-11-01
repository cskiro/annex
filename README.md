# Claudex - Claude Code Skills

> A curated collection of production-quality skills for [Claude Code](https://claude.com/claude-code)

## Executive Summary

**Claudex** is a marketplace-ready repository of specialized skills that extend Claude Code's capabilities across critical software engineering workflows. Each skill provides domain-specific expertise - from comprehensive codebase auditing to OpenTelemetry observability setup - packaged as invokable agents with built-in validation, troubleshooting, and best practices.

**Current Focus Areas:**
- **Code Quality & Security** - Automated auditing against modern SDLC standards
- **Architecture Patterns** - React/TypeScript application validation
- **Observability** - OpenTelemetry setup and configuration automation
- **Developer Productivity** - Conversation analysis and semantic search
- **Configuration Management** - CLAUDE.md validation and compliance

**Status:** Proof of concept (v0.1.0) - All skills tested locally on 1-2 projects. Not production-validated.

### How Skills Work

1. **Discovery**: Claude Code automatically scans `~/.claude/skills/` (global) and `.claude/skills/` (local)
2. **Loading**: Each skill has a `SKILL.md` file that Claude reads to understand capabilities
3. **Invocation**: Simply describe what you want in natural language
4. **Execution**: Claude uses the skill's scripts and reference materials to complete the task

---

## Prerequisites

To use skills from this repository, you need:

### Required
- **Claude Code** - Latest version ([Download](https://claude.com/claude-code))
- **Git** - For cloning and marketplace integration
- **Node.js** 18+ - For marketplace infrastructure
- **Python** 3.8+ - For Python-based skills (codebase-auditor, bulletproof-react-auditor, etc.)

### Optional (Skill-Specific)
- **Docker Desktop** - Required for `otel-monitoring-setup` skill
- **Python Packages** - Install per skill's `requirements.txt`:
  - `cc-insights`: sentence-transformers, chromadb, jinja2, click, python-dateutil
  - `codebase-auditor`: PyYAML, requests
  - `bulletproof-react-auditor`: PyYAML
  - `claude-md-auditor`: PyYAML, jsonschema

### System Requirements
- **Disk Space**: 100MB-2GB depending on skills installed
- **RAM**: 2GB minimum (4GB recommended for cc-insights)
- **OS**: macOS, Linux, or Windows with WSL2

---

## Quick Start

### Option 1: Install via Marketplace (Recommended)

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
/plugin install otel-monitoring-setup@claudex
```

### Option 2: Team Configuration (Auto-Install)

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
    "cc-insights@claudex",
    "otel-monitoring-setup@claudex"
  ]
}
```

When team members trust your repository, these plugins install automatically.

---

## Available Skills

| Skill | Description | Version | Category |
|-------|-------------|---------|----------|
| **[codebase-auditor](./codebase-auditor/)** | Comprehensive codebase analysis for quality, security, and technical debt. Audits against 2024-25 SDLC standards (OWASP, WCAG, DORA). | `0.1.0` | Analysis |
| **[bulletproof-react-auditor](./bulletproof-react-auditor/)** | React application auditor based on Bulletproof React architecture guide. Evaluates project structure, component patterns, state management, and performance. | `0.1.0` | Analysis |
| **[claude-md-auditor](./claude-md-auditor/)** | Validates CLAUDE.md configuration files against official schema standards and community best practices for LLM context optimization. | `0.1.0` | Tooling |
| **[cc-insights](./cc-insights/)** | RAG-powered conversation analysis with semantic search. Automatically processes Claude Code history to generate insight reports and detect development patterns. | `0.1.0` | Productivity |
| **[otel-monitoring-setup](./otel-monitoring-setup/)** | Automated OpenTelemetry setup with local PoC mode (Docker stack + Grafana) and enterprise mode. Includes validation scripts and troubleshooting. | `0.1.0` | DevOps |

**All skills are currently at version 0.1.0 (proof of concept)**. Production-ready versions will follow semantic versioning with git tags after successful merges to main.

---

## License

**License**: Apache 2.0

---

**Maintained by**: Connor

**Current Version**: v0.1.0 (Proof of Concept)

**Status**: Beta - All skills tested locally on 1-2 projects

**Last Updated**: 2025-11-01

*Experimental skills for extending Claude Code capabilities. Versioning via git tags follows successful merges to main.*
