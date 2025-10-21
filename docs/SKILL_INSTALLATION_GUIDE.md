# Codebase Auditor Skill - Installation & Usage Guide

## Quick Start

The codebase-auditor skill can be used in three ways:
1. **Project-specific installation** (recommended for single project)
2. **Global installation** (available across all projects)
3. **Direct Python execution** (no skill installation needed)

---

## Installation Options

### Option 1: Project-Specific Installation

Install the skill in a specific project's `.claude/skills` directory:

```bash
# Navigate to your project
cd /path/to/your-project

# Create skills directory if it doesn't exist
mkdir -p .claude/skills

# Copy the skill from annex repository
cp -r /Users/connor/Desktop/Development/annex/codebase-auditor \
  .claude/skills/

# Verify installation
ls .claude/skills/codebase-auditor/SKILL.md
```

**When to use**: When you want the skill only for a specific project.

**Pros**:
- Project-specific customization possible
- Version control the skill with your project
- No global namespace pollution

**Cons**:
- Must install in each project separately
- Updates require manual sync

---

### Option 2: Global Installation

Install once, use everywhere:

```bash
# Install to global Claude skills directory
mkdir -p ~/.claude/skills
cp -r /Users/connor/Desktop/Development/annex/codebase-auditor \
  ~/.claude/skills/

# Verify installation
ls ~/.claude/skills/codebase-auditor/SKILL.md
```

**When to use**: When you want the skill available in all your projects.

**Pros**:
- Available everywhere Claude Code runs
- Install once, use many times
- Easy to update globally

**Cons**:
- Same version across all projects (no per-project customization)
- Harder to version control with specific projects

---

### Option 3: Symlink (Best of Both Worlds)

Create a symlink from project to annex repository:

```bash
# Navigate to your project
cd /path/to/your-project

# Create skills directory
mkdir -p .claude/skills

# Symlink to annex repository (always stays up-to-date)
ln -s /Users/connor/Desktop/Development/annex/codebase-auditor \
  .claude/skills/codebase-auditor

# Verify
ls -la .claude/skills/codebase-auditor
```

**When to use**: When you want automatic updates from annex repository.

**Pros**:
- Always uses latest version from annex
- No manual updates needed
- Single source of truth

**Cons**:
- Changes to annex affect all symlinked projects
- Symlink must point to valid path

---

## How Claude Code Discovers Skills

When you invoke Claude Code in a project, it automatically:

1. **Scans** `.claude/skills/` directory in your project
2. **Scans** `~/.claude/skills/` global directory
3. **Loads** SKILL.md files from discovered skill directories
4. **Matches** your request to the appropriate skill based on the `description` field

### Skill Discovery Example

Given this structure:
```
/path/to/your-project/
└── .claude/
    └── skills/
        └── codebase-auditor/
            └── SKILL.md  ← Claude loads this
```

Claude will:
- Read the `description` field in SKILL.md frontmatter
- Match your request ("audit this codebase") to the skill
- Load and execute the skill instructions

---

## Usage Examples

Once installed in `.claude/skills/`, you can invoke the skill using natural language:

### Basic Invocation

```plaintext
Audit this codebase using the codebase-auditor skill.
```

Claude will:
1. Recognize the skill name
2. Load `codebase-auditor/SKILL.md`
3. Execute Phase 1 (Discovery)
4. Execute Phase 2 (Deep Analysis)
5. Generate a report

### Natural Language Triggers

Claude also recognizes these patterns (no explicit skill name needed):

```plaintext
# General audit
"Audit this codebase"
"Run a code quality analysis"
"Check this project for issues"

# Focused audits
"Run a security audit on this codebase"
"Check test coverage for this project"
"Analyze technical debt"
"Find code quality issues"

# Quick checks
"Give me a quick health check of this codebase"
"What's the overall quality score?"
```

### Custom Scope Requests

```plaintext
Audit this codebase focusing on:
- Test coverage and quality
- Security vulnerabilities
- Code complexity

# Or more specific:
Run a security-focused audit on this codebase, checking for:
- Secrets in code
- OWASP Top 10 issues
- Vulnerable dependencies
```

### Specify Output Format

```plaintext
# Markdown (default)
Audit this codebase and generate a Markdown report.

# JSON for CI/CD
Audit this codebase and output JSON format.

# HTML dashboard
Audit this codebase and create an HTML dashboard.
```

---

## Direct Python Usage (No Skill Installation)

You can also use the audit engine directly without installing as a skill:

```bash
# Basic usage
python /Users/connor/Desktop/Development/annex/codebase-auditor/scripts/audit_engine.py \
  /path/to/your-project \
  --output audit-report.md

# Security-focused
python /Users/connor/Desktop/Development/annex/codebase-auditor/scripts/audit_engine.py \
  /path/to/your-project \
  --scope security \
  --output security-report.md

# JSON for CI/CD
python /Users/connor/Desktop/Development/annex/codebase-auditor/scripts/audit_engine.py \
  /path/to/your-project \
  --format json \
  --output audit-report.json

# Quick health check (Phase 1 only)
python /Users/connor/Desktop/Development/annex/codebase-auditor/scripts/audit_engine.py \
  /path/to/your-project \
  --phase quick

# Multiple scopes
python /Users/connor/Desktop/Development/annex/codebase-auditor/scripts/audit_engine.py \
  /path/to/your-project \
  --scope quality,security,testing \
  --output full-audit.md

# HTML dashboard
python /Users/connor/Desktop/Development/annex/codebase-auditor/scripts/audit_engine.py \
  /path/to/your-project \
  --format html \
  --output audit-dashboard.html
```

### CLI Options

```
positional arguments:
  codebase              Path to the codebase to audit

optional arguments:
  --scope SCOPE         Comma-separated list of analysis categories
                        (quality,testing,security,dependencies,performance,technical_debt)
  --phase {quick,full}  Analysis depth: quick (Phase 1) or full (Phase 1 + 2)
  --format {markdown,json,html}
                        Output format
  --output OUTPUT       Output file path (default: stdout)
```

---

## CI/CD Integration

### GitHub Actions Example

Create `.github/workflows/code-audit.yml`:

```yaml
name: Codebase Audit

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  audit:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Run Codebase Audit
        run: |
          python .claude/skills/codebase-auditor/scripts/audit_engine.py . \
            --format json \
            --output audit-report.json

      - name: Check for Critical Issues
        run: |
          CRITICAL=$(jq '.summary.critical_issues' audit-report.json)
          HIGH=$(jq '.summary.high_issues' audit-report.json)

          echo "📊 Audit Results:"
          echo "Critical Issues: $CRITICAL"
          echo "High Issues: $HIGH"

          if [ "$CRITICAL" -gt 0 ]; then
            echo "❌ Build failed: Found $CRITICAL critical issues"
            exit 1
          fi

          if [ "$HIGH" -gt 5 ]; then
            echo "⚠️  Warning: Found $HIGH high-severity issues"
          fi

      - name: Upload Audit Report
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: audit-report
          path: audit-report.json

      - name: Generate Markdown Report
        if: github.event_name == 'pull_request'
        run: |
          python .claude/skills/codebase-auditor/scripts/audit_engine.py . \
            --format markdown \
            --output audit-report.md

      - name: Comment PR with Results
        if: github.event_name == 'pull_request'
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs');
            const report = fs.readFileSync('audit-report.md', 'utf8');

            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: report
            });
```

### GitLab CI Example

Create `.gitlab-ci.yml`:

```yaml
code-audit:
  stage: test
  image: python:3.11
  script:
    - python .claude/skills/codebase-auditor/scripts/audit_engine.py . --format json --output audit-report.json
    - CRITICAL=$(jq '.summary.critical_issues' audit-report.json)
    - |
      if [ "$CRITICAL" -gt 0 ]; then
        echo "❌ Critical issues found"
        exit 1
      fi
  artifacts:
    reports:
      junit: audit-report.json
    paths:
      - audit-report.json
    expire_in: 30 days
```

---

## Project Structure After Installation

### Project-Specific Installation

```
/path/to/your-project/
├── .claude/
│   └── skills/
│       └── codebase-auditor/         ← Skill installed here
│           ├── SKILL.md              ← Claude loads this
│           ├── README.md
│           ├── scripts/
│           │   ├── audit_engine.py
│           │   ├── analyzers/
│           │   └── ...
│           ├── reference/
│           └── examples/
├── src/
├── tests/
└── package.json
```

### Global Installation

```
~/.claude/
└── skills/
    └── codebase-auditor/              ← Globally available
        ├── SKILL.md
        └── ...
```

---

## Customizing the Skill for Your Project

### Per-Project Thresholds

Edit `.claude/skills/codebase-auditor/reference/severity_matrix.md`:

```markdown
# Adjust for startup vs. enterprise

## For Startups (move fast, fix later)
- Critical: Security only
- High: Production-breaking
- Medium: Everything else
- Low: Nice-to-have

## For Enterprise (quality first)
- Critical: Security + major quality issues
- High: Anything that impacts users
- Medium: Technical debt
- Low: Stylistic
```

### Custom Analyzers

Add project-specific analyzers in `.claude/skills/codebase-auditor/scripts/analyzers/`:

```python
# custom_business_logic.py
def analyze(codebase_path, metadata):
    findings = []

    # Your company's specific rules
    # Example: Enforce specific import patterns
    # Example: Check for deprecated internal APIs
    # Example: Validate domain-specific logic

    return findings
```

Then update `audit_engine.py`:

```python
ANALYZERS = {
    'quality': 'analyzers.code_quality',
    'custom': 'analyzers.custom_business_logic',  # Add this
    # ...
}
```

---

## Troubleshooting

### Skill Not Found

**Problem**: Claude doesn't recognize the skill

**Solutions**:
```bash
# Verify installation
ls -la .claude/skills/codebase-auditor/SKILL.md

# Check frontmatter in SKILL.md
head -5 .claude/skills/codebase-auditor/SKILL.md

# Should see:
# ---
# name: codebase-auditor
# description: ...
# ---
```

### Permission Issues

**Problem**: Cannot execute Python scripts

**Solution**:
```bash
# Make scripts executable
chmod +x .claude/skills/codebase-auditor/scripts/*.py
chmod +x .claude/skills/codebase-auditor/scripts/analyzers/*.py
```

### Python Version Issues

**Problem**: Script fails with syntax errors

**Solution**:
```bash
# Check Python version (needs 3.8+)
python --version

# Use python3 explicitly
python3 .claude/skills/codebase-auditor/scripts/audit_engine.py
```

### Large Codebase Performance

**Problem**: Audit takes too long

**Solutions**:
```bash
# Use quick mode (Phase 1 only)
python audit_engine.py /path/to/project --phase quick

# Use specific scope
python audit_engine.py /path/to/project --scope security,testing

# Exclude directories (edit the script to add more excludes)
# Current excludes: node_modules, .git, dist, build, __pycache__
```

---

## Verification Commands

### Test Skill Installation

```bash
# From your project directory
cd /path/to/your-project

# Verify skill exists
test -f .claude/skills/codebase-auditor/SKILL.md && echo "✅ Skill installed" || echo "❌ Skill not found"

# Test direct execution
python .claude/skills/codebase-auditor/scripts/audit_engine.py . --phase quick

# Expected output:
# 🚀 Starting codebase audit...
#    Codebase: /path/to/your-project
#    ...
```

### Test with Claude Code

```bash
# Start Claude Code in your project
claude-code

# Then in Claude Code prompt:
> Audit this codebase using the codebase-auditor skill.

# Claude should respond with audit execution
```

---

## Best Practices

### 1. Start with Quick Mode

```plaintext
Give me a quick health check of this codebase (Phase 1 only).
```

This helps you understand the project structure before running a full audit.

### 2. Use Focused Audits

For specific concerns:
```plaintext
Run a security-focused audit on this codebase.
```

This is faster and more targeted than full audits.

### 3. Establish Baselines

```bash
# Before major refactoring
python audit_engine.py . --output baseline-audit.md

# After refactoring
python audit_engine.py . --output post-refactor-audit.md

# Compare
diff baseline-audit.md post-refactor-audit.md
```

### 4. Integrate with Pre-Commit Hooks

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash
# Run security-only audit before commit

python .claude/skills/codebase-auditor/scripts/audit_engine.py . \
  --scope security \
  --format json \
  --output /tmp/audit.json

CRITICAL=$(jq '.summary.critical_issues' /tmp/audit.json)

if [ "$CRITICAL" -gt 0 ]; then
  echo "❌ Commit blocked: $CRITICAL critical security issues found"
  echo "Run: python .claude/skills/codebase-auditor/scripts/audit_engine.py . --scope security"
  exit 1
fi
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

---

## Updating the Skill

### Global Installation Updates

```bash
# Update from annex repository
cp -r /Users/connor/Desktop/Development/annex/codebase-auditor \
  ~/.claude/skills/codebase-auditor

# Or if using git in annex
cd /Users/connor/Desktop/Development/annex
git pull
cp -r codebase-auditor ~/.claude/skills/
```

### Project-Specific Updates

```bash
# From annex repository
cp -r /Users/connor/Desktop/Development/annex/codebase-auditor \
  /path/to/your-project/.claude/skills/

# Or update just the scripts
cp -r /Users/connor/Desktop/Development/annex/codebase-auditor/scripts \
  /path/to/your-project/.claude/skills/codebase-auditor/
```

### Symlink (Auto-Updates)

No action needed! Symlinks always point to the latest version in annex.

---

## Summary

**Recommended Setup**:
1. Global install for personal projects: `~/.claude/skills/`
2. Project-specific for work projects: `.claude/skills/`
3. Symlink for development/testing: Link to annex repo

**Quick Reference**:
```bash
# Install globally
cp -r /Users/connor/Desktop/Development/annex/codebase-auditor ~/.claude/skills/

# Install per-project
cp -r /Users/connor/Desktop/Development/annex/codebase-auditor /path/to/project/.claude/skills/

# Use with Claude Code
"Audit this codebase using the codebase-auditor skill."

# Use directly
python codebase-auditor/scripts/audit_engine.py /path/to/project
```

---

**Questions?** See the main [README.md](../codebase-auditor/README.md) or [CODEBASE_AUDITOR_SKILL.md](CODEBASE_AUDITOR_SKILL.md) for more details.
