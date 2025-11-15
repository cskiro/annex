---
name: codebase-auditor
version: 0.1.0
description: Comprehensive codebase audit tool that analyzes software engineering practices, detects code quality issues, security vulnerabilities, technical debt, and generates prioritized remediation plans based on modern SDLC best practices (2024-25 standards). Use this skill when conducting code reviews, assessing project health, preparing for production deployments, or evaluating legacy codebases.
author: Connor
---

# Codebase Auditor

Perform comprehensive codebase audits using modern software engineering standards, detecting quality issues, security vulnerabilities, and technical debt while generating actionable remediation plans.

## When to Use This Skill

Activate this skill when you need to:
- Audit a codebase for quality, security, and maintainability issues
- Assess technical debt and estimate remediation effort
- Prepare a production readiness report
- Evaluate a legacy codebase for modernization
- Generate prioritized improvement recommendations
- Analyze SDLC maturity and DevOps practices

## Audit Scope

### Phase 1: Initial Assessment (Progressive Disclosure)

Start with a lightweight scan to understand the codebase:

1. **Project Discovery**
   - Identify tech stack, languages, frameworks, and build tools
   - Detect package managers and dependency files
   - Identify test frameworks and CI/CD configurations
   - Map directory structure and architectural patterns

2. **Quick Health Check**
   - Count total files, lines of code, and file types
   - Check for basic documentation (README, CONTRIBUTING, etc.)
   - Identify version control practices (git history quality)
   - Detect obvious red flags (secrets in code, massive files, etc.)

### Phase 2: Deep Analysis (Load on Demand)

Based on Phase 1 findings, perform targeted deep analysis:

#### 2.1 Code Quality Analysis

**Complexity Metrics:**
- Calculate cyclomatic complexity for functions/methods
- Identify overly complex code (complexity > 10 = warning, > 20 = critical)
- Measure cognitive complexity and nesting depth
- Detect long methods/functions (> 50 LOC)
- Find large files (> 500 LOC)

**Code Duplication:**
- Detect duplicate code blocks (> 6 lines repeated)
- Calculate duplication percentage (> 5% = concern)
- Identify copy-paste anti-patterns
- Find similar code that could be abstracted

**Code Smells:**
- God objects/classes (too many responsibilities)
- Feature envy (excessive coupling)
- Dead code (unused imports, variables, functions)
- Magic numbers and hard-coded values
- Inconsistent naming conventions
- Missing error handling
- Console.log statements (production code)

**TypeScript/JavaScript Specific:**
- Use of `any` type (strict mode violations)
- Use of `var` instead of `const`/`let`
- Loose equality (`==` instead of `===`)
- Missing return type annotations
- Non-null assertions without justification

#### 2.2 Testing & Coverage Analysis

**Coverage Metrics:**
- Line coverage percentage (minimum: 80%)
- Branch coverage percentage
- Function coverage percentage
- Statement coverage percentage
- Identify untested critical paths (authentication, payment, data processing)

**Testing Trophy Distribution:**
- Integration tests: Should be ~70%
- Unit tests: Should be ~20%
- E2E tests: Should be ~10%
- Analyze actual distribution vs. ideal

**Test Quality:**
- Test naming conventions ("should X when Y" pattern)
- Test isolation and independence
- Brittle tests (testing implementation details)
- Test smells (no assertions, multiple assertions per test)
- Missing edge case coverage
- Flaky test detection

**Test Performance:**
- Test execution time
- CPU usage during tests (check for runaway processes)
- Test parallelization opportunities

#### 2.3 Security Vulnerability Scan

**Dependency Vulnerabilities:**
- Scan for known CVEs in dependencies
- Check for outdated packages with security patches
- Identify dependencies with no recent maintenance
- Detect dependency confusion risks
- License compliance check

**OWASP Top 10 (2024):**
- Broken Access Control
- Cryptographic Failures
- Injection vulnerabilities (SQL, XSS, command injection)
- Insecure Design patterns
- Security Misconfiguration
- Vulnerable and Outdated Components
- Authentication failures
- Software and Data Integrity Failures
- Security Logging and Monitoring Failures
- Server-Side Request Forgery (SSRF)

**Secrets Detection:**
- API keys, tokens, passwords in code
- Hardcoded credentials
- Private keys committed to repository
- Environment variables exposed in client code
- Database connection strings

**Security Best Practices:**
- Input validation and sanitization
- Output encoding
- CSRF protection
- Secure session management
- HTTPS enforcement
- Content Security Policy headers

#### 2.4 Architecture & Design Analysis

**SOLID Principles:**
- Single Responsibility violations
- Open/Closed principle adherence
- Liskov Substitution violations
- Interface Segregation issues
- Dependency Inversion patterns

**Design Patterns:**
- Appropriate pattern usage
- Anti-pattern detection
- Over-engineering indicators
- Under-engineering indicators

**Modularity:**
- Module coupling metrics
- Module cohesion analysis
- Circular dependencies
- Proper separation of concerns
- API design quality

#### 2.5 Performance Analysis

**Build Performance:**
- Build time analysis
- Bundle size measurement
- Chunk splitting effectiveness
- Tree-shaking effectiveness
- Source map configuration

**Runtime Performance:**
- Memory leaks detection
- Inefficient algorithms (O(n²) or worse)
- Excessive re-renders (React)
- Unnecessary computations
- Large asset sizes (images, videos)

**CI/CD Performance:**
- Pipeline execution time
- Deployment frequency
- Test execution time
- Docker image sizes

#### 2.6 Documentation Quality

**Code Documentation:**
- JSDoc/TSDoc coverage for public APIs
- Inline comments for complex logic
- README completeness
- Architecture documentation (ADRs)
- API documentation
- Contributing guidelines
- Code of conduct

**Documentation Maintenance:**
- Outdated documentation detection
- Broken links
- Missing sections
- Code examples correctness

#### 2.7 DevOps & DORA Metrics

**CI/CD Maturity:**
- Automated testing in pipeline
- Deployment automation
- Environment parity
- Rollback capabilities
- Feature flags usage

**DORA 4 Metrics:**
- Deployment Frequency (Elite: Multiple times per day)
- Lead Time for Changes (Elite: Less than 1 hour)
- Change Failure Rate (Elite: < 1%)
- Time to Restore Service (Elite: < 1 hour)

**Infrastructure as Code:**
- Configuration management
- Infrastructure versioning
- Secrets management
- Environment configuration

#### 2.8 Accessibility (WCAG 2.1 AA)

**Semantic HTML:**
- Proper heading hierarchy
- ARIA labels and roles
- Form label associations
- Landmark regions

**Keyboard Navigation:**
- Focus management
- Keyboard shortcuts
- Tab order
- Focus indicators

**Screen Reader Support:**
- Alt text for images
- ARIA live regions
- Descriptive link text
- Form error announcements

**Color Contrast:**
- Text contrast ratios (4.5:1 for normal text)
- UI component contrast
- Color-blind friendly palettes

#### 2.9 Technical Debt Calculation

**SQALE Rating (A-E Scale):**
- Calculate remediation effort in person-days
- A: <= 5% of development time
- B: 6-10% of development time
- C: 11-20% of development time
- D: 21-50% of development time
- E: > 50% of development time

**Debt Categorization:**
- Code smell debt
- Test debt
- Documentation debt
- Security debt
- Performance debt
- Architecture debt

### Phase 3: Report Generation

Generate a comprehensive audit report with the following sections:

#### Executive Summary
- Overall health score (0-100)
- SQALE rating
- Critical findings count
- Top 5 priorities
- Estimated remediation timeline

#### Detailed Findings
For each issue category:
- **Severity**: Critical, High, Medium, Low
- **Category**: Quality, Security, Performance, etc.
- **Location**: File path and line numbers
- **Description**: What the issue is
- **Impact**: Why it matters
- **Remediation**: How to fix it
- **Effort**: Estimated time to fix

#### Metrics Dashboard
- Code quality score
- Test coverage percentage
- Security score
- Performance score
- Documentation score
- DevOps maturity score

#### Trend Analysis
- Compare against previous audits (if available)
- Identify improving vs. degrading metrics
- Project future debt accumulation

### Phase 4: Remediation Planning

Generate a prioritized action plan:

#### Priority 1: Critical Issues (Fix Immediately)
- Security vulnerabilities (CVEs, secrets exposure)
- Production-breaking bugs
- Data loss risks
- Authentication/authorization failures

#### Priority 2: High-Impact Issues (Fix This Sprint)
- Test coverage gaps in critical paths
- Performance bottlenecks
- Accessibility violations (WCAG AA)
- TypeScript strict mode violations

#### Priority 3: Medium-Impact Issues (Fix Next Quarter)
- Code smells and complexity
- Documentation gaps
- Test quality improvements
- Refactoring opportunities

#### Priority 4: Low-Impact Issues (Backlog)
- Stylistic improvements
- Minor optimizations
- Nice-to-have features
- Long-term architectural improvements

## Usage Instructions

### Basic Audit
```
Audit this codebase using the codebase-auditor skill.
```

### Focused Audit
```
Run a security-focused audit on this codebase.
```

### Quick Health Check
```
Give me a quick health check of this codebase (Phase 1 only).
```

### Custom Scope
```
Audit this codebase focusing on:
- Test coverage and quality
- Security vulnerabilities
- Technical debt estimation
```

## Output Formats

The skill supports multiple output formats:

1. **Markdown Report** (Default)
   - Human-readable, suitable for PR comments or documentation

2. **JSON Report**
   - Machine-readable, suitable for CI/CD integration
   - Schema includes: `{ findings: [], metrics: {}, score: 0-100 }`

3. **HTML Dashboard**
   - Interactive visualization with charts
   - Filterable and sortable findings
   - Exportable to PDF

4. **Remediation Plan** (Markdown)
   - Prioritized action items
   - Effort estimates
   - Assignment suggestions

## Best Practices

1. **Run incrementally** for large codebases (use progressive disclosure)
2. **Focus on critical paths** first (authentication, payment, data processing)
3. **Baseline audits** before major releases
4. **Track metrics over time** to measure improvement
5. **Integrate with CI/CD** for continuous monitoring
6. **Customize severity thresholds** based on project maturity
7. **Involve the team** in remediation planning

## Integration with Existing Tools

This skill complements and integrates with:
- **SonarQube**: Import findings for deeper analysis
- **ESLint/TSLint**: Validate linting rules
- **Jest/Vitest**: Parse coverage reports
- **npm audit/yarn audit**: Dependency vulnerability scanning
- **Lighthouse**: Performance and accessibility scoring
- **GitHub Actions**: CI/CD integration

## Limitations

- Analysis is based on static code analysis (no runtime profiling)
- Requires access to source code and configuration files
- Dependency vulnerability data requires internet access
- Large codebases may require chunked analysis
- Test execution is not included (use existing test runners)

## References

See the `reference/` directory for:
- Complete audit criteria checklist
- Severity matrix and scoring rubric
- 2024-25 SDLC best practices guide
- Industry benchmarks and standards
