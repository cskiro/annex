---
name: claude-md-auditor
description: Comprehensive CLAUDE.md audit tool that validates memory files against official Anthropic documentation (docs.claude.com), community best practices, and academic research on LLM context optimization. Detects security violations, anti-patterns, and compliance issues. Generates detailed audit reports or refactored CLAUDE.md files that enforce standards across all conversations. Use this skill when reviewing CLAUDE.md configurations, onboarding projects, or ensuring LLMs strictly adhere to documented standards.
---

# CLAUDE.md Auditor

Comprehensive validation and optimization tool for CLAUDE.md memory files in Claude Code. This skill analyzes configuration files against three authoritative sources and generates actionable recommendations or production-ready refactored files.

## Validation Sources

This skill validates against **three distinct categories**, clearly labeled in all findings:

### 1. ✅ Official Anthropic Guidance
- **Source**: docs.claude.com (verified 2025-10-26)
- **Authority**: Highest (these are requirements from Anthropic)
- **Examples**:
  - Memory hierarchy (Enterprise → Project → User)
  - "Keep them lean" guidance
  - Import syntax and limitations (max 5 hops)
  - What NOT to include (secrets, generic content)

### 2. 💡 Community Best Practices
- **Source**: Field experience and practitioner wisdom
- **Authority**: Medium (recommended but not mandatory)
- **Examples**:
  - 100-300 line target range
  - 80/20 rule (essential vs. supporting content)
  - Organizational patterns
  - Maintenance cadence

### 3. 🔬 Research-Based Optimization
- **Source**: Academic research (MIT, Google Cloud AI, Anthropic papers)
- **Authority**: Medium (evidence-based recommendations)
- **Examples**:
  - "Lost in the middle" positioning strategy
  - Token budget optimization
  - Attention pattern considerations
  - U-shaped performance curves

## When to Use This Skill

Activate this skill when you need to:

- **Audit existing CLAUDE.md files** for compliance and optimization
- **Review CLAUDE.md before committing** to source control
- **Onboard new projects** and validate their memory configuration
- **Troubleshoot why Claude isn't following standards** (check CLAUDE.md quality)
- **Refactor legacy CLAUDE.md files** to modern best practices
- **Generate production-ready CLAUDE.md** from scratch
- **CI/CD integration** for automated CLAUDE.md validation

## Audit Capabilities

### Security Validation (CRITICAL)

**Detects**:
- 🚨 API keys, tokens, passwords in memory files
- 🚨 Database connection strings with credentials
- 🚨 Private keys (PEM format)
- 🚨 Internal IP addresses and infrastructure details
- 🚨 AWS access keys, OpenAI API keys (pattern matching)

**Why Critical**: CLAUDE.md files are often committed to source control. Exposed secrets can leak through git history, PR comments, logs, or backups.

### Official Compliance Validation

**Checks**:
- ✅ File length (official guidance: "keep them lean")
- ✅ Generic programming content (Claude already knows this)
- ✅ Import syntax correctness (@path/to/import)
- ✅ Broken import paths
- ✅ Vague instructions ("write good code" vs. specific standards)
- ✅ Proper markdown structure

**Reference**: All checks map to specific official documentation pages.

### Best Practices Validation

**Evaluates**:
- 💡 File length (community: 100-300 lines optimal)
- 💡 Token usage (< 3,000 tokens recommended)
- 💡 Organizational patterns (sections, headers, hierarchy)
- 💡 Priority markers (CRITICAL, IMPORTANT, RECOMMENDED)
- 💡 Update dates and version information
- 💡 Duplicate or conflicting sections

**Note**: These are community-derived, not Anthropic requirements.

### Research Optimization Validation

**Analyzes**:
- 🔬 Critical information positioning (avoid middle sections)
- 🔬 Token efficiency and context utilization
- 🔬 Chunking and information architecture
- 🔬 Attention pattern optimization

**Based On**: "Lost in the Middle" research (Liu et al., 2023), Claude-specific performance studies, and attention calibration research (MIT/Google Cloud AI, 2024).

## Output Modes

### Mode 1: Audit Report (Default)

Generate comprehensive markdown audit report with:

```
# CLAUDE.md Audit Report

## Executive Summary
- Overall health score (0-100)
- Critical/High/Medium/Low findings count
- Security, compliance, best practices scores

## File Metrics
- Line count, token estimate, context usage
- Comparison against recommendations

## Detailed Findings
- Grouped by severity and category
- Line numbers and code snippets
- Impact assessment
- Specific remediation steps
- Source attribution (official/community/research)

## Priority Recommendations
- P0: IMMEDIATE (critical security issues)
- P1: THIS SPRINT (high priority)
- P2: NEXT QUARTER (medium priority)
- P3: BACKLOG (low priority optimizations)
```

**Use Case**: Code reviews, PR checks, regular audits

### Mode 2: JSON Report

Machine-readable format for CI/CD integration:

```json
{
  "metadata": {...},
  "scores": {...},
  "findings": [
    {
      "severity": "critical",
      "category": "security",
      "title": "API Key Detected",
      "line_number": 42,
      "remediation": "..."
    }
  ],
  "summary": {...}
}
```

**Use Case**: Automated pipelines, quality gates, metrics tracking

### Mode 3: Refactored CLAUDE.md

Generate production-ready CLAUDE.md with:

- ✅ **Optimal structure** (critical at top, reference at bottom)
- ✅ **Research-optimized positioning** (lost in the middle mitigation)
- ✅ **All findings fixed** (security issues removed, content improved)
- ✅ **Best practices applied** (proper organization, clear sections)
- ✅ **Comments and guidance** inline for future maintenance

**Use Case**: Project initialization, legacy file modernization, template generation

## Usage Examples

### Basic Audit

```
Audit my CLAUDE.md file using the claude-md-auditor skill.
```

Claude will:
1. Locate CLAUDE.md in current directory or parent directories
2. Run comprehensive analysis
3. Generate markdown audit report
4. Highlight critical issues first

### Focused Security Audit

```
Run a security-focused audit on my CLAUDE.md to check for secrets.
```

Claude will:
1. Prioritize security validation
2. Check for all secret patterns (API keys, tokens, passwords)
3. Report any findings as CRITICAL
4. Provide remediation steps (remove + rotate + clean git history)

### Generate Refactored File

```
Audit my CLAUDE.md and generate a refactored version following best practices.
```

Claude will:
1. Analyze existing file
2. Extract valid project-specific content
3. Generate improved structure
4. Apply research-based positioning
5. Save as CLAUDE_refactored.md

### Compare Multiple Files

```
Audit CLAUDE.md files in my project hierarchy (Enterprise, Project, User tiers).
```

Claude will:
1. Find all CLAUDE.md files in hierarchy
2. Audit each independently
3. Check for conflicts between tiers
4. Report on tier-specific issues

### CI/CD Integration

```
Generate JSON audit report for CI pipeline integration.
```

Claude will:
1. Run full analysis
2. Generate JSON format
3. Include exit code recommendation (0 = pass, 1 = critical issues)
4. Provide metrics for tracking over time

## Interpretation Guide

### Understanding Findings

Each finding includes:

**Severity**: How urgent is this?
- 🚨 **CRITICAL**: Security risk or blocking issue (fix immediately)
- ⚠️ **HIGH**: Significant quality/compliance issue (fix this sprint)
- 📋 **MEDIUM**: Moderate improvement opportunity (schedule for next quarter)
- ℹ️ **LOW**: Minor optimization (backlog)

**Category**: What type of issue?
- **Security**: Secrets, sensitive information, vulnerabilities
- **Official Compliance**: Violations of Anthropic documentation
- **Best Practices**: Community recommendations
- **Research Optimization**: Academic research insights
- **Structure**: Organization and formatting
- **Maintenance**: Staleness, broken links, outdated info

**Source**: Where does this recommendation come from?
- **Official**: Anthropic documentation (highest authority)
- **Community**: Field experience (recommended)
- **Research**: Academic studies (evidence-based)

### Score Interpretation

**Overall Health Score (0-100)**:
- **90-100**: Excellent - minor optimizations only
- **75-89**: Good - some improvements recommended
- **60-74**: Fair - schedule improvements this quarter
- **40-59**: Poor - significant issues to address
- **0-39**: Critical - immediate action required

**Category Scores**:
- **Security**: Should always be 100 (any security issue is critical)
- **Official Compliance**: Aim for 80+ (official guidance should be followed)
- **Best Practices**: 70+ is good (community recommendations are flexible)
- **Research Optimization**: 60+ is acceptable (optimizations, not requirements)

## Reference Documentation

All validation criteria are documented in the `reference/` directory:

### official_guidance.md
Complete compilation of official Anthropic documentation:
- Memory hierarchy and precedence
- File locations and loading behavior
- Import functionality and limitations
- Official best practices (keep lean, be specific, use structure)
- What NOT to include
- Validation methods (/memory command, /init command)

### best_practices.md
Community-derived best practices:
- Size recommendations (100-300 lines)
- Content organization (80/20 rule)
- Import strategies
- Version control practices
- Maintenance cadence
- Multi-project strategies

### research_insights.md
Academic research findings:
- "Lost in the Middle" phenomenon (Liu et al., 2023)
- Claude-specific performance data
- Context awareness in Claude 4/4.5
- Positioning strategies (top/bottom vs. middle)
- Token efficiency research
- Attention calibration solutions (2024)

### anti_patterns.md
Catalog of common mistakes:
- Critical violations (secrets, exposed infrastructure)
- High-severity issues (generic content, excessive verbosity, vague instructions)
- Medium issues (outdated info, duplicates, missing context)
- Low issues (poor organization, broken links, inconsistent formatting)
- Structural anti-patterns (circular imports, deep nesting)

## Validation Workflow

### Step 1: Discovery
```
The skill will:
1. Locate CLAUDE.md file(s) in project hierarchy
2. Detect memory tier (Enterprise/Project/User)
3. Calculate file metrics (lines, tokens, context usage)
4. Read file content for analysis
```

### Step 2: Analysis
```
Run validators in order:
1. Security Validation (CRITICAL) - Check for secrets/sensitive data
2. Official Compliance - Validate against docs.claude.com
3. Best Practices - Check community recommendations
4. Research Optimization - Apply academic insights
5. Structure - Validate markdown and organization
6. Maintenance - Check for staleness and broken links
```

### Step 3: Scoring
```
Calculate scores:
- Overall health (0-100)
- Category-specific scores
- Finding counts by severity
- Context usage metrics
```

### Step 4: Reporting
```
Generate output:
- Markdown report (human-readable)
- JSON report (machine-readable)
- Refactored file (production-ready)
```

## Integration with Existing Workflows

### Pre-Commit Hook

```bash
# .git/hooks/pre-commit
#!/bin/bash

if git diff --cached --name-only | grep -q "CLAUDE.md"; then
  echo "Validating CLAUDE.md..."

  # Generate JSON report
  python claude-md-auditor/scripts/analyzer.py CLAUDE.md > /tmp/audit.json

  # Check for critical issues
  CRITICAL=$(jq '.summary.critical' /tmp/audit.json)

  if [ "$CRITICAL" -gt 0 ]; then
    echo "❌ CLAUDE.md has critical issues. Run audit for details."
    exit 1
  fi

  echo "✅ CLAUDE.md validation passed"
fi
```

### GitHub Actions

```yaml
name: CLAUDE.md Audit

on:
  pull_request:
    paths:
      - '**/CLAUDE.md'
      - '**/.claude/CLAUDE.md'

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Audit CLAUDE.md
        run: |
          python claude-md-auditor/scripts/analyzer.py CLAUDE.md \
            --format json \
            --output audit-report.json

      - name: Check Critical Issues
        run: |
          CRITICAL=$(jq '.summary.critical' audit-report.json)
          if [ "$CRITICAL" -gt 0 ]; then
            echo "Critical issues found in CLAUDE.md"
            exit 1
          fi

      - name: Post Report as Comment
        if: always()
        uses: actions/github-script@v6
        with:
          script: |
            // Post audit summary as PR comment
```

### VS Code Task

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Audit CLAUDE.md",
      "type": "shell",
      "command": "python",
      "args": [
        "claude-md-auditor/scripts/analyzer.py",
        "${workspaceFolder}/CLAUDE.md"
      ],
      "group": {
        "kind": "test",
        "isDefault": false
      }
    }
  ]
}
```

## Best Practices for Using This Skill

### ✅ DO

1. **Run before committing CLAUDE.md changes** to catch issues early
2. **Fix CRITICAL findings immediately** (especially security issues)
3. **Schedule regular audits** (quarterly recommended)
4. **Use refactored output as template** for new projects
5. **Share findings with team** via PR reviews
6. **Track scores over time** to measure improvement
7. **Distinguish source types** (official vs. community vs. research)

### ❌ DON'T

1. **Don't ignore CRITICAL findings** (especially secrets)
2. **Don't treat all recommendations equally** (check source attribution)
3. **Don't over-optimize** (good enough > perfect)
4. **Don't commit secrets** even temporarily
5. **Don't skip security validation** on any CLAUDE.md
6. **Don't copy-paste without understanding** (refactored files need customization)

## Success Criteria

A well-audited CLAUDE.md should achieve:

- ✅ **Security Score**: 100/100 (no secrets or sensitive data)
- ✅ **Official Compliance**: 80+/100 (follows Anthropic guidance)
- ✅ **Overall Health**: 75+/100 (good condition)
- ✅ **Zero CRITICAL findings** (no security issues)
- ✅ **< 3 HIGH findings** (minimal major issues)
- ✅ **Proper structure** (clear sections, organized content)
- ✅ **Project-specific** (no generic content)
- ✅ **Up-to-date** (no broken links or outdated info)

## Limitations

### What This Skill CANNOT Do

- ❌ Cannot automatically fix security issues (requires manual remediation)
- ❌ Cannot test if Claude actually follows the standards (behavioral testing needed)
- ❌ Cannot validate imported files beyond path existence
- ❌ Cannot detect circular imports (requires graph traversal, TODO)
- ❌ Cannot verify that standards match actual codebase
- ❌ Cannot determine if standards are appropriate for your project
- ❌ Does not run the CLAUDE.md through Claude for effectiveness testing

### Recommendations for Complete Validation

1. **Security**: Manually verify no secrets committed, check git history
2. **Effectiveness**: Test in new Claude session to verify standards are followed
3. **Import graph**: Manually trace imports to ensure no cycles
4. **Content accuracy**: Verify commands, paths, and workflows match actual project
5. **Team alignment**: Review with team to ensure standards are agreed upon

## Troubleshooting

### "Cannot Read File"
- **Cause**: File doesn't exist or permission denied
- **Fix**: Check file path, verify permissions

### "Excessive Verbosity"
- **Cause**: File > 500 lines
- **Fix**: Use @imports to move detailed docs to separate files

### "Generic Content Detected"
- **Cause**: Copy-pasted documentation from official sources
- **Fix**: Remove generic content, keep only project-specific standards

### "No Update Date"
- **Cause**: Missing last-updated information
- **Fix**: Add `**Last Updated**: YYYY-MM-DD` at end of file

### "Broken Import Paths"
- **Cause**: @import references non-existent files
- **Fix**: Update paths or remove stale imports

## Version Information

**Skill Version**: 1.0.0
**Last Updated**: 2025-10-26
**Compatibility**: Claude Code (all versions with Skills support)
**Python Version**: 3.8+
**Dependencies**: None (uses Python standard library only)

## Support and Contribution

This skill is based on:
- Official Anthropic documentation (docs.claude.com)
- Peer-reviewed academic research
- Community field experience

For issues or improvements, validate findings against source documents in `reference/` directory.

---

**Generated by**: claude-md-auditor v1.0.0
**Maintained by**: Connor (based on Anthropic Skills framework)
**License**: Apache 2.0 (example skill for demonstration)
