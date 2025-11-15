---
name: github-repo-setup
description: Automated GitHub repository setup with four modes - quick public repos, enterprise-grade with security and CI/CD, open-source community standards, and private team collaboration with governance
version: 0.1.0
author: Connor
tags:
  - github
  - repository
  - setup
  - automation
  - ci-cd
  - security
  - open-source
  - devops
category: productivity
---

# GitHub Repository Setup

## Overview

This skill automates the creation and configuration of GitHub repositories following official GitHub best practices and modern industry standards (2024-2025). It provides four distinct modes tailored to different use cases, from quick public repos to enterprise-grade setups with comprehensive security, CI/CD, and governance.

**Four Modes:**
1. **Quick Mode** - Fast public repo setup with essentials (README, LICENSE, .gitignore) (~30s)
2. **Enterprise Mode** - Production-ready with security features, CI/CD, branch protection (~120s)
3. **Open Source Mode** - Community-focused with templates, CODE_OF_CONDUCT, CONTRIBUTING (~90s)
4. **Private/Team Mode** - Internal collaboration with CODEOWNERS, governance, team workflows (~90s)

All modes follow GitHub's official best practices including security features (Dependabot, secret scanning), proper documentation structure, and industry-standard workflows.

## When to Use This Skill

**Trigger Phrases:**
- "create a GitHub repository"
- "set up a new GitHub repo"
- "initialize GitHub repo with best practices"
- "create an enterprise GitHub repository"
- "set up an open source project on GitHub"
- "create a private team repository"
- "configure GitHub repo security"
- "set up GitHub CI/CD workflows"

**Use Cases:**
- Starting new projects with GitHub best practices from day one
- Migrating existing projects to modern GitHub standards
- Setting up open source projects with proper community health files
- Establishing team repositories with governance and security
- Creating quick experiment repos with minimal configuration
- Standardizing repository setup across organizations

## Response Style

- **Efficient**: Automate repetitive setup tasks
- **Guided**: Clear mode selection with trade-offs
- **Standards-driven**: Apply GitHub official best practices
- **Security-first**: Enable protection features by default
- **Educational**: Explain choices and their benefits

## Quick Decision Matrix

```
User Request                          → Mode          → Setup Time  → Key Features
──────────────────────────────────────────────────────────────────────────────────
"quick GitHub repo"                    → Quick         → ~30s        → README, LICENSE, .gitignore
"experiment repo"                      → Quick         → ~30s        → Minimal config
"test project"                         → Quick         → ~30s        → Basic structure

"production GitHub repo"               → Enterprise    → ~120s       → Full security + CI/CD
"enterprise repository"                → Enterprise    → ~120s       → Branch protection
"GitHub repo with CI/CD"               → Enterprise    → ~120s       → Automated workflows

"open source project"                  → Open Source   → ~90s        → Community templates
"public GitHub project"                → Open Source   → ~90s        → CODE_OF_CONDUCT
"OSS repository"                       → Open Source   → ~90s        → Contributing guidelines

"private team repo"                    → Private/Team  → ~90s        → CODEOWNERS
"internal repository"                  → Private/Team  → ~90s        → Governance docs
"team collaboration repo"              → Private/Team  → ~90s        → Access controls
```

## Mode Detection Logic

```javascript
// Mode 1: Quick (Minimal setup for experiments)
if (userMentions("quick", "test", "experiment", "prototype", "minimal")) {
  return "quick-mode";
}

// Mode 2: Enterprise (Production-ready with all features)
if (userMentions("enterprise", "production", "ci/cd", "security", "workflows")) {
  return "enterprise-mode";
}

// Mode 3: Open Source (Community-focused public projects)
if (userMentions("open source", "oss", "public", "community", "contributions")) {
  return "open-source-mode";
}

// Mode 4: Private/Team (Internal collaboration)
if (userMentions("private", "internal", "team", "codeowners", "governance")) {
  return "private-team-mode";
}

// Ambiguous - ask user
return askForModeSelection();
```

## Core Responsibilities

### 1. Mode Selection & Validation
- ✓ Detect user intent from natural language
- ✓ Present clear mode options with feature comparison
- ✓ Validate prerequisites (GitHub CLI, git, authentication)
- ✓ Check for repository name conflicts

### 2. Repository Creation
- ✓ Create repository via GitHub CLI with appropriate visibility
- ✓ Initialize with proper default branch (main)
- ✓ Configure repository settings and features
- ✓ Set up branch protection rules (enterprise/team modes)

### 3. Security Configuration
- ✓ Enable Dependabot alerts and security updates
- ✓ Configure secret scanning and push protection
- ✓ Set up code scanning with CodeQL (enterprise mode)
- ✓ Create SECURITY.md with vulnerability reporting instructions

### 4. Documentation Structure
- ✓ Generate comprehensive README with project info
- ✓ Add appropriate LICENSE file
- ✓ Create .gitignore for relevant technologies
- ✓ Set up community health files (CODE_OF_CONDUCT, CONTRIBUTING)

### 5. CI/CD Setup
- ✓ Configure GitHub Actions workflows
- ✓ Set up automated testing and linting
- ✓ Configure deployment pipelines (optional)
- ✓ Enable required status checks

### 6. Issue & PR Management
- ✓ Create issue templates with GitHub form schema
- ✓ Set up pull request templates
- ✓ Configure CODEOWNERS for review requirements
- ✓ Set up project boards and automation

## Workflow

### Phase 1: Mode Selection & Prerequisites

**Purpose**: Understand user needs and validate environment

**Steps:**
1. Detect mode from user request using Mode Detection Logic
2. If ambiguous, ask: "What type of GitHub repository?"
   - Quick: Minimal setup for experiments
   - Enterprise: Production-ready with security and CI/CD
   - Open Source: Community-focused public project
   - Private/Team: Internal team collaboration

3. Validate prerequisites:
   ```bash
   # Check GitHub CLI installation
   gh --version

   # Verify authentication
   gh auth status

   # Check git configuration
   git config user.name && git config user.email
   ```

4. Gather repository information:
   - Repository name (validate naming conventions)
   - Description
   - Visibility (public/private/internal)
   - Technology stack (for .gitignore)
   - License preference

**Output**: Validated environment and complete repository configuration

---

### Phase 2: Repository Creation & Initialization

**Purpose**: Create repository with proper settings

**Steps:**
1. Create repository via GitHub CLI:
   ```bash
   gh repo create <owner>/<name> \
     --description "<description>" \
     --<visibility> \
     --clone
   ```

2. Initialize git repository locally:
   ```bash
   cd <repo-name>
   git init
   git branch -M main
   ```

3. Configure repository settings:
   - Enable features (Issues, Projects, Wiki based on mode)
   - Set default branch to main
   - Configure merge strategies
   - Set up topics/tags

**Output**: Created repository with basic configuration

---

### Phase 3: Security Features Setup

**Purpose**: Enable GitHub security protections

**Steps:**
1. Enable Dependabot (all modes):
   ```bash
   gh api -X PUT /repos/{owner}/{repo}/vulnerability-alerts
   gh api -X PUT /repos/{owner}/{repo}/automated-security-fixes
   ```

2. Enable secret scanning (public repos automatically, private repos in enterprise mode):
   ```bash
   gh api -X PUT /repos/{owner}/{repo}/secret-scanning
   gh api -X PUT /repos/{owner}/{repo}/secret-scanning-push-protection
   ```

3. Configure code scanning (enterprise mode):
   - Create `.github/workflows/codeql.yml`
   - Set up automated security scanning
   - Configure sarif upload

4. Create SECURITY.md:
   - Vulnerability reporting process
   - Security policy
   - Response timeline
   - Contact information

**Output**: Enabled security features with proper configuration

---

### Phase 4: Documentation Generation

**Purpose**: Create comprehensive project documentation

**Steps:**
1. Generate README.md:
   - Project title and description
   - Installation instructions
   - Usage examples
   - Contributing guidelines link
   - License information
   - Badges (build status, coverage, license)

2. Add LICENSE file:
   - Use gh command or template
   - Common options: MIT, Apache-2.0, GPL-3.0

3. Create .gitignore:
   - Technology-specific patterns
   - OS-specific files
   - IDE configurations
   - Environment variables

4. Add community health files (open source/team modes):
   - CODE_OF_CONDUCT.md (Contributor Covenant)
   - CONTRIBUTING.md (contribution guidelines)
   - SUPPORT.md (support resources)
   - GOVERNANCE.md (team mode)

**Output**: Complete documentation structure

---

### Phase 5: CI/CD Workflow Setup

**Purpose**: Configure automated workflows

**Steps:**
1. Create `.github/workflows/` directory

2. Generate CI workflow (enterprise/open source modes):
   ```yaml
   name: CI
   on: [push, pull_request]
   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - name: Run tests
           run: # test commands
   ```

3. Set up additional workflows:
   - Linting and code quality checks
   - Security scanning
   - Dependency updates
   - Release automation (optional)

4. Configure branch protection with required checks

**Output**: Automated CI/CD pipelines

---

### Phase 6: Issue & PR Templates

**Purpose**: Standardize contributions

**Steps:**
1. Create issue templates directory:
   ```
   .github/ISSUE_TEMPLATE/
   ├── config.yml
   ├── bug_report.yml
   ├── feature_request.yml
   └── question.yml
   ```

2. Generate issue templates using GitHub form schema:
   - Bug reports with reproduction steps
   - Feature requests with use cases
   - Questions and discussions

3. Create pull request template:
   ```markdown
   ## Description
   ## Type of change
   ## Testing
   ## Checklist
   ```

4. Set up CODEOWNERS (enterprise/team modes):
   ```
   * @default-team
   /docs/ @documentation-team
   /.github/ @devops-team
   ```

**Output**: Standardized contribution process

---

### Phase 7: Branch Protection & Governance

**Purpose**: Protect important branches and establish governance

**Steps:**
1. Configure branch protection for main (enterprise/team modes):
   ```bash
   gh api -X PUT /repos/{owner}/{repo}/branches/main/protection \
     --input protection-rules.json
   ```

   Protection rules:
   - Require pull requests before merging
   - Require approvals (1-2 reviewers)
   - Dismiss stale reviews
   - Require status checks to pass
   - Require CODEOWNERS review
   - Restrict who can push

2. Set up team access (team mode):
   - Define team structure
   - Assign permissions
   - Configure review requirements

3. Create governance documentation (team mode):
   - Decision-making process
   - Roles and responsibilities
   - Release process
   - Code review standards

**Output**: Protected branches with governance

---

### Phase 8: Validation & Next Steps

**Purpose**: Verify setup and guide user

**Steps:**
1. Run validation checks:
   - ✅ Repository created successfully
   - ✅ Security features enabled
   - ✅ Documentation complete
   - ✅ CI/CD configured
   - ✅ Branch protection active

2. Generate setup report:
   ```markdown
   # Repository Setup Complete: <repo-name>

   ## Enabled Features
   - ✅ Dependabot alerts
   - ✅ Secret scanning
   - ✅ Branch protection
   - ✅ CI/CD workflows

   ## Next Steps
   1. Clone repository: `gh repo clone <owner>/<repo>`
   2. Add initial code
   3. Push first commit
   4. Verify CI workflow runs
   ```

3. Provide quick start commands:
   ```bash
   # Clone and start working
   gh repo clone <owner>/<repo>
   cd <repo>

   # Create feature branch
   git checkout -b feature/initial-setup

   # Make changes and push
   git add .
   git commit -m "feat: initial project setup"
   git push -u origin feature/initial-setup

   # Open pull request
   gh pr create
   ```

**Output**: Validated setup with guided next steps

---

## Error Handling

### Common Issues

**GitHub CLI not authenticated**
- Detect: `gh auth status` fails
- Solution: Guide user through `gh auth login`
- Provide: Step-by-step authentication instructions

**Repository name conflicts**
- Detect: API error for existing repo
- Solution: Suggest alternative names
- Offer: Check availability before creation

**Insufficient permissions**
- Detect: 403 errors from API
- Solution: Explain required permissions
- Guide: Organization admin settings

**Missing git configuration**
- Detect: `git config` returns empty
- Solution: Configure user.name and user.email
- Provide: Configuration commands

**Rate limiting**
- Detect: 429 errors from API
- Solution: Wait and retry with exponential backoff
- Inform: Rate limit reset time

## Success Criteria

- [ ] Repository created with appropriate visibility
- [ ] Security features enabled (Dependabot, secret scanning)
- [ ] Complete documentation (README, LICENSE, community files)
- [ ] CI/CD workflows configured and functional
- [ ] Issue and PR templates set up
- [ ] Branch protection rules active (enterprise/team modes)
- [ ] CODEOWNERS configured (team mode)
- [ ] Repository accessible and cloneable
- [ ] Validation checks pass
- [ ] User has clear next steps

## Reference Materials

See supporting files:

- `data/security-features.yaml` - GitHub security features configuration
- `data/community-health-files.yaml` - Community health file templates
- `data/workflow-templates.yaml` - CI/CD workflow configurations
- `templates/community-health/` - Pre-built community health files
- `templates/workflows/` - GitHub Actions workflow templates
- `templates/issue-templates/` - Issue template examples
- `templates/pr-templates/` - Pull request template examples
- `modes/quick-mode.md` - Quick mode detailed workflow
- `modes/enterprise-mode.md` - Enterprise mode detailed workflow
- `modes/open-source-mode.md` - Open source mode detailed workflow
- `modes/private-team-mode.md` - Private/team mode detailed workflow

## Important Reminders

1. **Security first** - Enable Dependabot and secret scanning by default
2. **Official standards** - Follow GitHub's documented best practices
3. **Branch protection** - Protect main branch in production setups
4. **Documentation** - Every repo needs README, LICENSE, and .gitignore
5. **Community health** - Open source projects need CODE_OF_CONDUCT and CONTRIBUTING
6. **CI/CD validation** - Test workflows before relying on them
7. **Access control** - Use CODEOWNERS for critical files
8. **Governance** - Document processes for team repositories

---

**Official Documentation**:
- https://docs.github.com/en/repositories/creating-and-managing-repositories/best-practices-for-repositories
- https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions
