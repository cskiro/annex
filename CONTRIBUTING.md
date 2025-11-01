# Contributing to Claudex

Thank you for your interest in contributing to Claudex! This guide will help you submit new skills, improvements, and bug fixes.

---

## Quick Start

1. **Check Issues** - Review [existing issues](https://github.com/cskiro/claudex/issues) to avoid duplicate work
2. **Create Issue** - Open a new issue to discuss your proposed changes (optional but recommended for large contributions)
3. **Fork Repository** - Create your own fork of the repository
4. **Create Branch** - Branch from `main` for your changes
5. **Make Changes** - Implement your feature or bug fix
6. **Test Locally** - Verify your skill works as expected
7. **Submit PR** - Open a pull request to merge your branch into `main`

---

## Reporting Bugs

Found a bug? Please help us fix it!

### Before Reporting

1. **Search existing issues** - Check if the bug has already been reported
2. **Verify the bug** - Try to reproduce the issue consistently
3. **Gather information** - Collect relevant details (Claude Code version, OS, error messages)

### Creating a Bug Report

Open a new issue at: https://github.com/cskiro/claudex/issues/new

**Please include:**

1. **Title**: Clear, descriptive summary (e.g., "otel-monitoring-setup crashes on Docker v20.10")
2. **Environment**:
   - Claude Code version
   - Operating System (macOS 14.5, Ubuntu 22.04, Windows 11, etc.)
   - Python version (if applicable)
   - Docker version (if applicable)
3. **Description**: What happened vs. what you expected to happen
4. **Steps to Reproduce**:
   ```
   1. Run command: /plugin install skill-name@claudex
   2. Execute skill with: "Audit this codebase"
   3. Error appears: [paste error message]
   ```
5. **Screenshots/Logs**: Include relevant error messages, stack traces, or screenshots
6. **Workaround**: If you found a temporary fix, share it!

**Example Bug Report:**

```markdown
Title: otel-monitoring-setup: OTEL Collector crashes with Loki exporter error

Environment:
- Claude Code: v1.2.3
- OS: macOS 14.5
- Docker: v20.10.23

Description:
When running the otel-monitoring-setup skill, the OTEL Collector container crashes immediately with error: "otlphttp/loki exporter not available"

Steps to Reproduce:
1. Install skill: /plugin install otel-monitoring-setup@claudex
2. Run: "Set up telemetry locally"
3. Docker compose starts but collector crashes
4. docker logs claude-otel-collector shows config error

Expected: Collector should start successfully
Actual: Collector crashes with invalid exporter error

Workaround: Manually remove otlphttp/loki from otel-collector-config.yml
```

---

## Contributing Code

### Branch Workflow

We use a **feature branch** workflow:

```bash
# 1. Fork the repository on GitHub

# 2. Clone your fork
git clone https://github.com/YOUR_USERNAME/claudex.git
cd claudex

# 3. Add upstream remote
git remote add upstream https://github.com/cskiro/claudex.git

# 4. Create a feature branch from main
git checkout -b feature/your-feature-name

# Examples:
git checkout -b feature/add-terraform-auditor
git checkout -b bugfix/otel-collector-loki-crash
git checkout -b docs/update-installation-guide
```

**Branch Naming Conventions:**
- `feature/` - New skills or features
- `bugfix/` - Bug fixes
- `docs/` - Documentation updates
- `chore/` - Maintenance tasks

### Making Changes

1. **Implement your changes** following the skill structure guidelines
2. **Test thoroughly** - Verify your skill works in a clean environment
3. **Update documentation** - Ensure README.md and SKILL.md are accurate
4. **Follow conventions** - Match existing code style and structure

### Committing Changes

Use **conventional commits** format:

```bash
# Format: <type>(<scope>): <subject>

git commit -m "feat(otel-monitoring-setup): add preflight validation script"
git commit -m "fix(codebase-auditor): resolve OWASP false positives"
git commit -m "docs(readme): update installation instructions"
git commit -m "chore: update Python dependencies to latest versions"
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `chore`: Maintenance tasks
- `refactor`: Code refactoring
- `test`: Adding tests

### Submitting a Pull Request

```bash
# 1. Push your branch to your fork
git push origin feature/your-feature-name

# 2. Open a Pull Request on GitHub
# Navigate to: https://github.com/cskiro/claudex/pulls
# Click "New Pull Request"
# Select: base: main <- compare: your-branch

# 3. Fill out the PR template with:
```

**PR Title Format:**
```
feat: Add Terraform infrastructure auditor skill
fix: Resolve OTEL Collector Loki exporter crash
docs: Update Quick Start guide with troubleshooting
```

**PR Description Template:**
```markdown
## Description
Brief summary of changes

## Type of Change
- [ ] New skill
- [ ] Bug fix
- [ ] Documentation update
- [ ] Performance improvement

## Testing
- [ ] Tested locally on macOS/Linux/Windows
- [ ] Verified skill works with Claude Code v1.x.x
- [ ] Documentation is accurate and complete

## Checklist
- [ ] Code follows repository structure guidelines
- [ ] README.md is updated
- [ ] SKILL.md is accurate
- [ ] plugin.json has correct metadata
- [ ] Version starts at 0.1.0 for new skills
- [ ] All files are properly formatted

## Related Issues
Closes #123
Relates to #456
```

---

## Contributing a New Skill

### Skill Structure Requirements

**Required Files:**
```
your-skill-name/
├── SKILL.md           # Agent manifest
├── README.md          # User documentation
└── plugin.json        # Marketplace metadata
```

**Recommended Files:**
```
your-skill-name/
├── SKILL.md
├── README.md
├── plugin.json
├── CHANGELOG.md       # Version history
├── requirements.txt   # Python dependencies (if applicable)
├── scripts/           # Implementation code
├── reference/         # Standards and best practices
└── examples/          # Sample outputs
```

### SKILL.md Template

```markdown
---
name: your-skill-name
version: 0.1.0
description: Brief description of what your skill does
author: Your Name
---

# Your Skill Name

Detailed description of skill capabilities.

## Response Style

- Be systematic - Follow structured approach
- Verify prerequisites - Check environment
- Test thoroughly - Validate results
- Provide clear output - Show next steps

## Quick Decision Matrix

| User Request | Action |
|--------------|--------|
| "trigger phrase 1" | Do X |
| "trigger phrase 2" | Do Y |

## Workflow

1. Step 1
2. Step 2
3. Step 3
```

### plugin.json Template

```json
{
  "name": "your-skill-name",
  "version": "0.1.0",
  "description": "Brief description",
  "author": "Your Name",
  "license": "Apache-2.0",
  "homepage": "https://github.com/cskiro/claudex/tree/main/your-skill-name",
  "repository": {
    "type": "git",
    "url": "https://github.com/cskiro/claudex"
  },
  "keywords": ["keyword1", "keyword2"],
  "requirements": {
    "python": ">=3.8"
  },
  "components": {
    "agents": [
      {
        "name": "your-skill-name",
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
```

### README.md Template

```markdown
# Your Skill Name

Brief description

## Features

- Feature 1
- Feature 2
- Feature 3

## Installation

\`\`\`bash
/plugin install your-skill-name@claudex
\`\`\`

## Usage

\`\`\`
"Natural language trigger phrase"
→ Expected behavior
\`\`\`

## Requirements

- Requirement 1
- Requirement 2

## Examples

Show example usage and outputs

## Troubleshooting

Common issues and solutions
```

---

## Quality Standards

### All Contributions Must:

- ✅ **Follow existing structure** - Match repository patterns
- ✅ **Include documentation** - README.md and SKILL.md
- ✅ **Start at v0.1.0** - Initial proof of concept
- ✅ **Be tested locally** - Verify functionality before submission
- ✅ **Use clear language** - Documentation should be easy to understand
- ✅ **Provide examples** - Show how to use the skill

### Code Quality:

- ✅ **Python 3.8+** - Use modern Python features
- ✅ **Type hints** - Include type annotations where applicable
- ✅ **Error handling** - Handle edge cases gracefully
- ✅ **Comments** - Explain complex logic
- ✅ **Dependencies** - Minimize external dependencies

### Documentation Quality:

- ✅ **Clear descriptions** - Explain what the skill does
- ✅ **Usage examples** - Show real-world usage
- ✅ **Prerequisites** - List all requirements
- ✅ **Troubleshooting** - Include common issues
- ✅ **No broken links** - Verify all URLs work

---

## Versioning Guidelines

### Semantic Versioning

We follow [Semantic Versioning](https://semver.org/):

- **0.1.0** - Initial proof of concept
- **0.2.0** - Bug fixes and improvements
- **0.x.x** - Pre-release versions
- **1.0.0** - Production-ready release
- **1.x.x** - Minor features and bug fixes
- **2.0.0** - Breaking changes

### Version Bump Guidelines

- **Patch** (0.1.0 → 0.1.1): Bug fixes only
- **Minor** (0.1.0 → 0.2.0): New features, backward compatible
- **Major** (0.x.x → 1.0.0): Production-ready or breaking changes

### Git Tags

After merging to `main`, maintainers will create git tags:

```bash
git tag -a skill-name@0.1.0 -m "Initial release of skill-name"
git push origin skill-name@0.1.0
```

---

## Review Process

### What Happens After You Submit

1. **Automated checks** - CI runs linting and validation
2. **Maintainer review** - Code review within 3-5 business days
3. **Feedback** - Requested changes or approval
4. **Merge** - PR merged to `main` branch
5. **Git tag** - Version tag created following semver
6. **Marketplace** - Skill available via `/plugin install`

### What We Look For

- ✅ **Functionality** - Does it work as described?
- ✅ **Documentation** - Is it clear and complete?
- ✅ **Structure** - Does it follow conventions?
- ✅ **Quality** - Is the code clean and maintainable?
- ✅ **Value** - Does it provide value to users?

---

## Need Help?

- **Questions?** Open a [discussion](https://github.com/cskiro/claudex/discussions)
- **Found a bug?** Create an [issue](https://github.com/cskiro/claudex/issues)
- **Want to chat?** Reach out to Connor (repository maintainer)

---

## License

By contributing to Claudex, you agree that your contributions will be licensed under the Apache 2.0 License.

---

**Thank you for contributing to Claudex!** 🎉

Every contribution, no matter how small, helps make Claude Code more powerful for everyone.
