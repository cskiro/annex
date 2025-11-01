# Repository Structure

Complete directory layout and organization of the claudex skills repository.

## Top-Level Structure

```
claudex/
├── codebase-auditor/              # General codebase auditor
├── bulletproof-react-auditor/     # React-specific auditor
├── claude-md-auditor/             # CLAUDE.md validator
├── cc-insights/                   # Conversation insights
├── otel-monitoring-setup/         # OpenTelemetry setup
├── docs/                          # Repository documentation
├── README.md                      # Main repository documentation
├── CONTRIBUTING.md                # Contribution guidelines
└── LICENSE                        # Apache 2.0 license
```

---

## Skill Directory Pattern

Each skill follows a consistent structure:

```
skill-name/
├── SKILL.md                       # Agent manifest (required)
├── README.md                      # User-facing documentation
├── plugin.json                    # Marketplace metadata
├── CHANGELOG.md                   # Version history (optional)
├── scripts/                       # Executable scripts
├── reference/                     # Standards and best practices
├── templates/                     # Configuration templates (optional)
├── examples/                      # Sample outputs (optional)
└── requirements.txt               # Python dependencies (if applicable)
```

---

## Detailed Skill Structures

### codebase-auditor/

```
codebase-auditor/
├── SKILL.md                       # Skill definition
├── README.md                      # Documentation
├── plugin.json                    # Marketplace metadata (v0.1.0)
├── scripts/                       # Python analysis engine
│   ├── codebase-auditor.py       # Main analysis script
│   └── utils/                     # Helper utilities
├── reference/                     # Audit standards
│   ├── owasp-top-10-2024.md
│   ├── wcag-2.1-aa.md
│   └── dora-metrics.md
└── examples/                      # Sample reports
    ├── sample-audit-report.md
    └── prioritized-remediation-plan.md
```

**Purpose**: Comprehensive static analysis for code quality, security, and technical debt

**Key Features**:
- OWASP Top 10 2024 security checks
- WCAG 2.1 AA accessibility validation
- DORA metrics assessment
- Python-based analysis engine

---

### bulletproof-react-auditor/

```
bulletproof-react-auditor/
├── SKILL.md                       # Skill definition
├── README.md                      # Documentation
├── plugin.json                    # Marketplace metadata (v0.1.0)
├── scripts/                       # Analysis scripts
│   ├── bulletproof-auditor.py    # Main auditor script
│   └── pattern-detectors/        # Architecture pattern detection
├── reference/                     # Bulletproof React standards
│   ├── project-structure.md
│   ├── component-patterns.md
│   ├── state-management.md
│   └── performance-optimization.md
└── examples/                      # Sample audit reports
    └── react-audit-report.md
```

**Purpose**: React application auditor based on Bulletproof React architecture guide

**Key Features**:
- Project structure validation
- Component pattern analysis
- State management best practices
- Performance optimization checks

---

### claude-md-auditor/

```
claude-md-auditor/
├── SKILL.md                       # Skill definition
├── README.md                      # Documentation
├── plugin.json                    # Marketplace metadata (v0.1.0)
├── scripts/                       # Validation scripts
│   ├── claude-md-validator.py    # Schema validator
│   └── compliance-checker.py     # Best practices checker
└── reference/                     # Schema specifications
    ├── claude-md-schema-v1.md
    ├── official-documentation.md
    └── community-best-practices.md
```

**Purpose**: Validates CLAUDE.md configuration files against official schema standards

**Key Features**:
- Schema v1.0 compliance checking
- Official documentation validation
- Community best practices enforcement
- Context optimization recommendations

---

### cc-insights/

```
cc-insights/
├── SKILL.md                       # Skill definition
├── README.md                      # Documentation
├── plugin.json                    # Marketplace metadata (v0.1.0)
├── requirements.txt               # Python dependencies
├── scripts/                       # Processing & search
│   ├── conversation-processor.py # Parse and index conversations
│   ├── rag_indexer.py            # RAG embedding generation
│   ├── search-conversations.py   # Semantic search engine
│   └── insight-generator.py      # Report generation
└── templates/                     # Report templates
    ├── weekly-report.md.j2
    ├── activity-timeline.md.j2
    └── pattern-analysis.md.j2
```

**Purpose**: RAG-powered conversation analysis with semantic search

**Key Features**:
- Automatic conversation indexing
- Semantic search using sentence-transformers
- ChromaDB vector storage
- Intelligent insight report generation
- Pattern detection and trend analysis

**Dependencies**:
- sentence-transformers
- chromadb
- jinja2
- click
- python-dateutil

---

### otel-monitoring-setup/

```
otel-monitoring-setup/
├── SKILL.md                       # Skill definition (v0.1.0)
├── README.md                      # Documentation
├── plugin.json                    # Marketplace metadata (v0.1.0)
├── CHANGELOG.md                   # Version history
├── templates/                     # Config templates
│   ├── docker-compose.yml         # Docker stack definition
│   ├── otel-collector-config.yml  # OTEL Collector config
│   ├── prometheus.yml             # Prometheus scrape config
│   ├── grafana-datasources.yml    # Grafana datasource provisioning
│   ├── settings.json.local        # Local mode settings
│   ├── settings.json.enterprise   # Enterprise mode settings
│   ├── preflight-check.sh         # Pre-setup validation (NEW)
│   ├── verify-setup.sh            # Post-setup verification (NEW)
│   ├── start-telemetry.sh         # Start script
│   └── stop-telemetry.sh          # Stop script
├── dashboards/                    # Grafana dashboards
│   ├── README.md                  # Dashboard import guide
│   ├── claude-code-overview.json  # Comprehensive dashboard
│   └── claude-code-simple.json    # Simplified dashboard
├── modes/                         # Setup workflows
│   ├── mode1-poc-setup.md         # Local PoC setup workflow
│   └── mode2-enterprise.md        # Enterprise setup workflow
└── data/                          # Documentation
    ├── metrics-reference.md       # Complete metrics documentation
    ├── prometheus-queries.md      # Useful PromQL queries
    └── troubleshooting.md         # Common issues and solutions
```

**Purpose**: Automated OpenTelemetry setup for Claude Code monitoring

**Key Features**:
- Local PoC mode (Docker stack + Grafana)
- Enterprise mode (connect to existing infrastructure)
- Automated validation scripts (preflight-check.sh, verify-setup.sh)
- Troubleshooting for common configuration errors
- Pre-configured Grafana dashboards

**Requirements**:
- Docker 20.10.0+
- Docker Compose 2.0.0+

---

## docs/ Directory

```
docs/
├── REPOSITORY_STRUCTURE.md        # This file
├── MIGRATION_GUIDE.md             # Upgrade from manual to marketplace
└── SKILL_INSTALLATION_GUIDE.md    # Legacy installation instructions
```

**Purpose**: Repository-wide documentation and guides

---

## Required Files Per Skill

### Minimum Requirements

1. **SKILL.md** (required)
   - Agent manifest with metadata
   - Contains: name, version, description, author
   - Defines skill capabilities and response style

2. **README.md** (required)
   - User-facing documentation
   - Installation instructions
   - Usage examples
   - Feature descriptions

3. **plugin.json** (required)
   - Marketplace metadata
   - Version information (semver)
   - Dependencies and requirements
   - Category and status

### Optional But Recommended

4. **CHANGELOG.md** (recommended)
   - Version history
   - Bug fixes and new features
   - Breaking changes

5. **requirements.txt** (if Python-based)
   - Python package dependencies
   - Pinned versions for reproducibility

6. **scripts/** (if executable)
   - Implementation code
   - Analysis engines
   - Utilities

7. **reference/** (recommended)
   - Standards and best practices
   - External documentation
   - Context for AI agent

8. **examples/** (recommended)
   - Sample outputs
   - Usage demonstrations

---

## Versioning Strategy

All skills currently at **v0.1.0** (proof of concept):

- `0.1.0` - Initial proof of concept
- `0.2.0` - Bug fixes and improvements
- `1.0.0` - Production-ready release

Git tags follow pattern: `skill-name@version`
- Example: `otel-monitoring-setup@0.1.0`

---

## Status Categories

- **proof-of-concept** - v0.1.0, tested on 1-2 projects
- **beta** - v0.2.0+, tested on 5+ projects
- **stable** - v1.0.0+, production-validated

---

**Last Updated**: 2025-11-01
**Version**: 0.1.0
