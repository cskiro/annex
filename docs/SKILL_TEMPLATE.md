# Claudex Skill Template

This document provides a template for creating new skills for the Claudex marketplace.

## Required Files

Every skill must include the following files:

```
skill-name/
├── SKILL.md           # Agent manifest (required)
├── README.md          # User documentation (required)
├── plugin.json        # Marketplace metadata (required)
├── CHANGELOG.md       # Version history (recommended)
└── [additional files as needed]
```

## File Templates

### 1. SKILL.md Template

```markdown
---
name: skill-name
version: 0.1.0
description: Brief description of what your skill does (1-2 sentences)
author: Your Name
---

# Skill Name

## Overview

Detailed description of skill capabilities and purpose.

## When to Use This Skill

**Trigger Phrases:**
- "phrase 1"
- "phrase 2"
- "phrase 3"

**Use Cases:**
- Use case 1
- Use case 2
- Use case 3

## Response Style

- **Characteristic 1**: Description
- **Characteristic 2**: Description
- **Characteristic 3**: Description

## Quick Decision Matrix

\`\`\`
User Request                → Mode/Action    → What to Do
────────────────────────────────────────────────────────
"trigger 1"                 → Mode 1         → Action 1
"trigger 2"                 → Mode 2         → Action 2
\`\`\`

## Mode Detection Logic

\`\`\`javascript
// Mode 1: Description
if (userMentions("keyword1")) {
  return "mode1-name";
}

// Mode 2: Description
if (userMentions("keyword2")) {
  return "mode2-name";
}

// Ambiguous - ask user
return askForClarification();
\`\`\`

## Core Responsibilities

### 1. First Responsibility
- ✓ Detail 1
- ✓ Detail 2
- ✓ Detail 3

### 2. Second Responsibility
- ✓ Detail 1
- ✓ Detail 2

## Workflow

### Phase 1: Initial Assessment
1. Step 1
2. Step 2
3. Step 3

### Phase 2: Main Operation
1. Step 1
2. Step 2

### Phase 3: Verification
1. Step 1
2. Step 2

## Error Handling

Common issues and how to handle them:
- **Error 1**: Solution
- **Error 2**: Solution

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Reference Materials

See additional documentation in:
- \`data/\` - Best practices and standards
- \`modes/\` - Detailed mode workflows
- \`examples/\` - Sample outputs
- \`templates/\` - Reusable templates
\`\`\`

### 2. README.md Template

\`\`\`markdown
# Skill Name

Brief description (1-2 sentences)

## Quick Start

\`\`\`
User: "Example trigger phrase"
\`\`\`

Claude will:
1. Action 1
2. Action 2
3. Action 3

## Features

### Feature 1
- Capability 1
- Capability 2
- Capability 3

### Feature 2
- Capability 1
- Capability 2

## Installation

\`\`\`bash
/plugin install skill-name@claudex
\`\`\`

## Usage Examples

### Example 1: Scenario Name

**Scenario:** Description

\`\`\`
User: "Example request"
\`\`\`

**Result:**
- Outcome 1
- Outcome 2

### Example 2: Another Scenario

**Scenario:** Description

\`\`\`
User: "Another request"
\`\`\`

**Result:**
- Outcome 1
- Outcome 2

## Requirements

- Requirement 1
- Requirement 2
- Requirement 3

## Configuration

If applicable, describe any configuration options.

## Troubleshooting

### Issue 1
**Problem:** Description
**Solution:** Steps to resolve

### Issue 2
**Problem:** Description
**Solution:** Steps to resolve

## Best Practices

- Practice 1
- Practice 2
- Practice 3

## Limitations

- Limitation 1
- Limitation 2

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for contribution guidelines.

## License

Apache 2.0

## Version History

See [CHANGELOG.md](./CHANGELOG.md) for version history.
\`\`\`

### 3. plugin.json Template

\`\`\`json
{
  "name": "skill-name",
  "version": "0.1.0",
  "description": "Brief description matching SKILL.md",
  "author": "Your Name",
  "license": "Apache-2.0",
  "homepage": "https://github.com/cskiro/claudex/tree/main/skill-name",
  "repository": {
    "type": "git",
    "url": "https://github.com/cskiro/claudex"
  },
  "keywords": [
    "keyword1",
    "keyword2",
    "keyword3"
  ],
  "requirements": {
    "optional-tool": ">=1.0.0"
  },
  "components": {
    "agents": [
      {
        "name": "skill-name",
        "manifestPath": "SKILL.md"
      }
    ]
  },
  "metadata": {
    "category": "analysis|tooling|productivity|devops",
    "status": "proof-of-concept",
    "tested": "1-2 projects locally"
  }
}
\`\`\`

### 4. CHANGELOG.md Template

\`\`\`markdown
# Changelog

All notable changes to the skill-name skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - YYYY-MM-DD

### Added
- Initial release of skill-name
- Feature 1
- Feature 2
- Feature 3

### Features
- **Key Feature 1**: Description
- **Key Feature 2**: Description

### Status
- Proof of concept
- Tested locally on 1-2 projects
- Ready for community feedback and testing

[0.1.0]: https://github.com/cskiro/claudex/releases/tag/skill-name@0.1.0
\`\`\`

## Directory Structure Patterns

### Minimal Skill (Simple Tasks)
\`\`\`
skill-name/
├── SKILL.md
├── README.md
├── plugin.json
└── CHANGELOG.md
\`\`\`

### Standard Skill (Most Common)
\`\`\`
skill-name/
├── SKILL.md
├── README.md
├── plugin.json
├── CHANGELOG.md
├── data/              # Reference materials, standards
├── examples/          # Sample outputs
└── templates/         # Reusable templates
\`\`\`

### Complex Skill (Multiple Modes)
\`\`\`
skill-name/
├── SKILL.md
├── README.md
├── plugin.json
├── CHANGELOG.md
├── modes/             # Mode-specific workflows
│   ├── mode1-name.md
│   ├── mode2-name.md
│   └── mode3-name.md
├── data/              # Reference materials
│   ├── best-practices.md
│   └── troubleshooting.md
├── examples/          # Sample outputs
├── templates/         # Reusable templates
└── scripts/           # Helper scripts (if needed)
\`\`\`

## Metadata Categories

Choose the most appropriate category for your skill:

- **analysis** - Code analysis, auditing, quality checking
- **tooling** - Development tools, configuration validators
- **productivity** - Developer workflow, automation, insights
- **devops** - Infrastructure, deployment, monitoring

## Version Guidelines

Follow [Semantic Versioning](https://semver.org/):

- **0.1.0** - Initial proof of concept
- **0.x.x** - Pre-release versions with improvements
- **1.0.0** - Production-ready release
- **1.x.x** - Minor features, bug fixes
- **2.0.0** - Breaking changes

## Quality Checklist

Before submitting your skill:

- [ ] All required files present (SKILL.md, README.md, plugin.json)
- [ ] Version starts at 0.1.0
- [ ] Clear trigger phrases in SKILL.md
- [ ] Usage examples in README.md
- [ ] Appropriate category in plugin.json
- [ ] Keywords for discoverability
- [ ] Tested locally on at least 1 project
- [ ] Documentation is clear and complete
- [ ] No sensitive data or credentials
- [ ] License is Apache 2.0

## Testing Your Skill Locally

Before submitting:

1. Copy skill to `~/.claude/skills/skill-name/`
2. Test all trigger phrases
3. Verify all modes work as expected
4. Check error handling
5. Validate documentation accuracy

## Submission Process

See [CONTRIBUTING.md](../CONTRIBUTING.md) for:
- Branch workflow
- Commit conventions
- PR submission process
- Review criteria

## Examples

See existing skills for reference:
- [codebase-auditor](../codebase-auditor/) - Analysis skill
- [otel-monitoring-setup](../otel-monitoring-setup/) - DevOps skill with multiple modes
- [cc-insights](../cc-insights/) - Productivity skill
- [git-worktree-setup](../git-worktree-setup/) - Productivity skill with batch operations

## Support

Questions? Open a [discussion](https://github.com/cskiro/claudex/discussions)
