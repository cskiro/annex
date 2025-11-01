---
name: playwright-e2e-automation
version: 0.2.0
description: Automated Playwright e2e testing framework that captures screenshots, enables LLM-powered visual analysis, detects UI bugs, generates fix recommendations, and creates regression test suites. Zero-setup automation for React/Vite, Node.js, static sites, and full-stack applications. Now with framework version detection and pre-flight validation.
author: Connor
category: tooling
tags: [playwright, e2e-testing, visual-regression, screenshot-analysis, automated-testing, llm-debugging, version-aware]
---

# Playwright E2E Automation

## Overview

This skill automates the complete lifecycle of Playwright e2e testing with LLM-powered visual debugging capabilities. It detects your application type, installs and configures Playwright with zero user intervention, generates screenshot-enabled test suites, performs visual analysis to identify UI bugs, compares against baselines for regression detection, and generates specific fix recommendations with file paths and line numbers.

**Key Capabilities:**
- **Zero-setup automation**: Detects app type, installs Playwright, configures everything automatically
- **Multi-framework support**: React/Vite, Node.js/Express, static HTML/CSS/JS, full-stack applications
- **Visual debugging**: Captures screenshots at key interaction points for LLM analysis
- **Intelligent bug detection**: Analyzes screenshots for UI bugs, broken layouts, accessibility issues, missing elements
- **Regression testing**: Compares current screenshots against baselines, highlights unexpected changes
- **Fix generation**: Produces actionable code fixes with specific file paths and line numbers
- **Test suite creation**: Generates production-ready Playwright test suites for ongoing use
- **CI/CD ready**: Documents integration patterns for GitHub Actions, GitLab CI, and other platforms

## When to Use This Skill

**Trigger Phrases:**
- "set up playwright testing for my app"
- "help me debug UI issues with screenshots"
- "create e2e tests with visual regression"
- "analyze my app's UI with screenshots"
- "automate playwright setup and testing"
- "generate playwright tests for [my app]"
- "check for visual regressions in my app"
- "take screenshots and analyze UI bugs"

**Use Cases:**
- Setting up Playwright testing infrastructure from scratch
- Debugging visual/UI bugs that are hard to describe in text
- Creating automated screenshot-based regression testing
- Generating comprehensive e2e test suites for new applications
- Identifying accessibility issues through visual inspection
- Comparing UI states before/after changes
- Enabling LLM-assisted visual debugging workflows
- Establishing visual regression baselines for CI/CD

## Response Style

- **Automated**: Execute entire workflow with minimal user intervention - detect, install, configure, test, analyze
- **Informative**: Provide clear progress updates at each phase with estimated times and completion status
- **Visual**: Always capture and analyze screenshots; show visual evidence for identified issues
- **Actionable**: Generate specific fix recommendations with file paths, line numbers, and code snippets
- **Educational**: Explain Playwright concepts and decisions while automating, teaching through doing

## Data Flow Architecture

```
App Detection → Playwright Setup → Test Generation → Screenshot Capture → Visual Analysis → Regression Check → Fix Generation → Test Suite Export
     ↓                ↓                  ↓                    ↓                   ↓                ↓                 ↓                   ↓
  package.json    npm install      templates/tests/     screenshots/       LLM vision      baselines/        fix-report.md      tests/ directory
  framework ID    config files     generated tests      timestamped/       analysis        comparison        with diffs         runnable suite
```

## Core Responsibilities

### 1. Application Detection & Analysis
- ✓ Detect application type (React/Vite, Node.js/Express, static, full-stack)
- ✓ Identify framework version and dev server configuration
- ✓ Locate entry points (index.html, app.tsx, server.js)
- ✓ Determine appropriate Playwright configuration based on app type
- ✓ Validate app is running or can be started automatically

### 2. Playwright Installation & Configuration
- ✓ Install Playwright and required browsers automatically
- ✓ Generate playwright.config.ts with optimal settings for app type
- ✓ Configure base URLs, viewports, and browser targets
- ✓ Set up screenshot directories and naming conventions
- ✓ Configure test retry logic and timeout values
- ✓ Integrate with existing test infrastructure (Vitest, Jest, etc.)

### 3. Test Suite Generation
- ✓ Create test structure following best practices
- ✓ Generate tests for critical user journeys
- ✓ Add screenshot capture at interaction points
- ✓ Include accessibility checks (WCAG 2.1 AA compliance)
- ✓ Set up page object models for maintainability
- ✓ Add explicit waits and proper selectors

### 4. Screenshot Capture & Management
- ✓ Capture screenshots at defined interaction points
- ✓ Organize screenshots by test, timestamp, viewport
- ✓ Generate comparison views (before/after, expected/actual)
- ✓ Store baseline images for regression testing
- ✓ Handle screenshot naming and metadata

### 5. Visual Analysis (LLM-Powered)
- ✓ Analyze screenshots for UI bugs and broken layouts
- ✓ Detect missing or misaligned elements
- ✓ Identify accessibility violations (color contrast, missing labels)
- ✓ Compare visual states across viewports (responsive issues)
- ✓ Flag unexpected visual changes from baselines
- ✓ Generate natural language descriptions of issues

### 6. Regression Detection
- ✓ Compare current screenshots with baseline images
- ✓ Calculate visual difference scores
- ✓ Highlight changed regions with pixel-level precision
- ✓ Classify changes (expected, suspicious, critical)
- ✓ Generate visual diff reports

### 7. Fix Recommendation Generation
- ✓ Map visual issues to source code locations
- ✓ Generate specific fix recommendations with file:line references
- ✓ Provide code snippets showing before/after fixes
- ✓ Prioritize fixes by severity (critical, high, medium, low)
- ✓ Include testing guidance for validating fixes

### 8. Test Suite Export
- ✓ Export production-ready test suite to tests/ directory
- ✓ Include README with usage instructions
- ✓ Add npm scripts for test execution
- ✓ Document CI/CD integration patterns
- ✓ Provide maintenance guidelines

## Workflow

### Phase 1: Application Discovery & Version Detection

**Purpose**: Understand the application architecture, detect framework versions, and determine optimal Playwright setup

**Steps:**
1. **Detect application type and versions**
   - Read package.json to identify frameworks (React, Vite, Next.js, Express, etc.)
   - Check for common files (vite.config.ts, next.config.js, app.js, index.html)
   - Identify build tools and dev server configuration
   - **NEW**: Extract installed package versions for version-aware configuration

2. **Consult version compatibility database**
   - Load `data/framework-versions.yaml` compatibility rules
   - Match installed versions against version ranges using semver
   - Determine appropriate templates for each framework version
   - Identify potential breaking changes or incompatibilities
   - **Example**: Tailwind v4 detected → use `@import` syntax, not `@tailwind`

3. **Validate application access**
   - Check if dev server is running (ports 3000, 5173, 8080, etc.)
   - If not running, determine how to start it (npm run dev, npm start, etc.)
   - Verify application loads successfully

4. **Map critical user journeys**
   - Identify key pages/routes from routing configuration
   - Detect authentication flows
   - Find form submissions and interactive elements
   - Locate API integrations

**Version Detection Logic**:
```typescript
// Load compatibility database
const versionDb = parseYAML('data/framework-versions.yaml');

// Detect versions
const detectedVersions = {
  tailwind: detectVersion(deps.tailwindcss, versionDb.tailwindcss),
  react: detectVersion(deps.react, versionDb.react),
  vite: detectVersion(deps.vite, versionDb.vite),
};

// Select appropriate templates
const templates = {
  css: detectedVersions.tailwind?.templates.css || 'templates/css/vanilla.css',
  postcss: detectedVersions.tailwind?.templates.postcss_config,
  playwright: 'templates/playwright.config.template.ts',
};
```

**Output**: Application profile with framework, versions, URLs, test targets, and selected templates

**Transition**: Proceed to Playwright setup with version-aware configuration

---

### Phase 2: Playwright Installation & Setup

**Purpose**: Install Playwright and generate optimal configuration

**Steps:**
1. **Install Playwright**
   ```bash
   npm init playwright@latest -- --yes
   # Installs Playwright, test runners, and browsers (Chromium, Firefox, WebKit)
   ```

2. **Generate playwright.config.ts**
   - Set base URL based on app type (http://localhost:5173 for Vite, etc.)
   - Configure viewport sizes (desktop: 1280x720, tablet: 768x1024, mobile: 375x667)
   - Set screenshot directory: `screenshots/{test-name}/{timestamp}/`
   - Enable trace on failure for debugging
   - Configure retries (2 attempts) and timeout (30s)

3. **Set up directory structure**
   ```
   tests/
   ├── setup/
   │   └── global-setup.ts    # Start dev server
   ├── pages/
   │   └── *.page.ts         # Page object models
   ├── specs/
   │   └── *.spec.ts         # Test specifications
   └── utils/
       └── screenshot-helper.ts

   screenshots/
   ├── baselines/            # Reference images
   ├── current/              # Latest test run
   └── diffs/                # Visual comparisons
   ```

4. **Integrate with existing test setup**
   - Add playwright scripts to package.json
   - Configure alongside Vitest/Jest (no conflicts)
   - Set up TypeScript types for Playwright

**Output**: Fully configured Playwright environment with version-appropriate templates

**Performance**: ~2-3 minutes for installation and setup

---

### Phase 2.5: Pre-flight Health Check (NEW)

**Purpose**: Validate app loads correctly before running full test suite - catches configuration errors early

**Steps:**
1. **Launch browser and attempt to load app**
   ```typescript
   const browser = await chromium.launch();
   const page = await browser.newPage();

   try {
     const response = await page.goto(baseURL, { timeout: 30000 });

     if (!response || !response.ok()) {
       throw new Error(`App returned ${response?.status()}`);
     }
   } catch (error) {
     // Analyze error and provide guidance
   }
   ```

2. **Monitor console for critical errors**
   - Listen for console errors during page load
   - Collect all error messages for pattern analysis
   - Wait 2-3 seconds to let errors surface

3. **Analyze errors against known patterns**
   - Load `data/error-patterns.yaml` error database
   - Match error messages against known patterns
   - Identify root cause and suggested fixes
   - **Example patterns detected**:
     - Tailwind v4 syntax mismatch: "Cannot apply unknown utility class"
     - PostCSS plugin error: "Plugin tailwindcss not found"
     - Missing dependencies: "Module not found"

4. **Provide actionable diagnostics**
   ```
   ❌ Pre-flight check failed: Critical errors detected

   Issue: Tailwind CSS v4 syntax mismatch
   Root cause: CSS file uses @tailwind directives but v4 requires @import

   Fix:
   1. Update src/index.css (or globals.css):
      Change from: @tailwind base; @tailwind components; @tailwind utilities;
      Change to: @import "tailwindcss";

   2. Update postcss.config.js:
      Change from: plugins: { tailwindcss: {} }
      Change to: plugins: { '@tailwindcss/postcss': {} }

   3. Restart dev server: npm run dev

   Documentation: https://tailwindcss.com/docs/upgrade-guide
   ```

5. **Auto-fix if possible, otherwise halt with guidance**
   - For known issues with clear fixes, offer to fix automatically
   - For ambiguous issues, halt and require user intervention
   - Prevent running 10+ tests that will all fail due to one config issue

**Error Pattern Analysis**:
```typescript
function analyzeErrors(consoleErrors) {
  const errorPatterns = parseYAML('data/error-patterns.yaml');
  const issues = [];

  for (const error of consoleErrors) {
    for (const [name, pattern] of Object.entries(errorPatterns.css_errors)) {
      if (pattern.pattern.test(error) ||
          pattern.alternative_patterns?.some(alt => alt.test(error))) {
        issues.push({
          name,
          severity: pattern.severity,
          diagnosis: pattern.diagnosis,
          recovery_steps: pattern.recovery_steps,
          documentation: pattern.documentation,
        });
      }
    }
  }

  return {
    critical: issues.filter(i => i.severity === 'critical'),
    allIssues: issues,
  };
}
```

**Benefits**:
- **Fast feedback**: 2-3 seconds vs 30+ seconds for full test suite
- **Clear guidance**: Specific fix steps, not generic "tests failed"
- **Prevents cascade failures**: One config error won't fail all 10 tests
- **Educational**: Explains what went wrong and why

**Output**: Health check passed, or detailed error diagnostics with fix steps

**Performance**: ~2-5 seconds

**Transition**: If health check passes, proceed to test generation. If fails, provide fixes and halt.

---

### Phase 3: Test Generation

**Purpose**: Create screenshot-enabled test suite covering critical workflows

**Steps:**
1. **Generate page object models**
   - Create POM classes for each major page/component
   - Define locators using best practices (getByRole, getByLabel, getByText)
   - Add screenshot capture methods to each POM

2. **Create test specifications**
   - Generate tests for each critical user journey
   - Add screenshot capture at key points:
     - Initial page load
     - Before interaction (button click, form fill)
     - After interaction
     - Error states
     - Success states

3. **Add accessibility checks**
   - Integrate axe-core for automated a11y testing
   - Capture accessibility violations in screenshots
   - Generate accessibility reports

4. **Set up screenshot helpers**
   ```typescript
   // templates/screenshot-helper.ts
   export async function captureWithContext(
     page: Page,
     name: string,
     context?: string
   ) {
     const timestamp = new Date().toISOString();
     const path = `screenshots/current/${name}-${timestamp}.png`;
     await page.screenshot({ path, fullPage: true });
     return { path, context, timestamp };
   }
   ```

**Output**: Complete test suite with screenshot automation

**Test Coverage**: Aim for critical user journeys (80/20 rule)

---

### Phase 4: Screenshot Capture & Execution

**Purpose**: Run tests and capture comprehensive visual data

**Steps:**
1. **Execute test suite**
   ```bash
   npx playwright test --project=chromium --headed=false
   ```

2. **Capture screenshots systematically**
   - Full-page screenshots for layout analysis
   - Element-specific screenshots for component testing
   - Different viewports (desktop, tablet, mobile)
   - Different states (hover, focus, active, disabled)

3. **Organize screenshot artifacts**
   - Group by test name
   - Add timestamp and viewport metadata
   - Generate index file for easy navigation

4. **Handle failures gracefully**
   - On test failure, capture additional debug screenshots
   - Save page HTML snapshot
   - Record network activity
   - Generate Playwright trace for replay

**Output**: Organized screenshot directory with metadata

**Performance**: ~30-60 seconds for typical app (5-10 tests)

---

### Phase 5: Visual Analysis

**Purpose**: Use LLM vision capabilities to analyze screenshots and identify issues

**Steps:**
1. **Batch screenshot analysis**
   - Read all captured screenshots
   - For each screenshot, ask LLM to identify:
     - UI bugs (broken layouts, overlapping elements, cut-off text)
     - Accessibility issues (low contrast, missing labels, improper heading hierarchy)
     - Responsive problems (elements not scaling, overflow issues)
     - Missing or misaligned elements
     - Unexpected visual artifacts

2. **Categorize findings**
   - **Critical**: App is broken/unusable (crashes, white screen, no content)
   - **High**: Major UI bugs affecting core functionality
   - **Medium**: Visual inconsistencies that impact UX
   - **Low**: Minor alignment or styling issues

3. **Generate issue descriptions**
   - Natural language description of each issue
   - Screenshot reference with highlighted problem area
   - Affected viewport/browser if relevant
   - User impact assessment

**Output**: Structured list of visual issues with severity ratings

**LLM Analysis Time**: ~5-10 seconds per screenshot

---

### Phase 6: Regression Detection

**Purpose**: Compare current screenshots against baselines to detect changes

**Steps:**
1. **Load baseline images**
   - Check if baselines exist in screenshots/baselines/
   - If first run, current screenshots become baselines
   - If baselines exist, proceed to comparison

2. **Perform pixel-level comparison**
   ```typescript
   import { compareScreenshots } from 'playwright-core/lib/utils';

   const diff = await compareScreenshots(
     baselinePath,
     currentPath,
     diffPath,
     { threshold: 0.2 } // 20% difference threshold
   );
   ```

3. **Generate visual diff reports**
   - Create side-by-side comparison images
   - Highlight changed regions in red
   - Calculate difference percentage
   - Classify changes:
     - **Expected**: Intentional changes (new features, fixes)
     - **Suspicious**: Unintended changes requiring review
     - **Critical**: Major regressions (broken features)

4. **Update baselines if approved**
   - Ask user: "Accept these changes as new baseline?"
   - If yes, copy current → baselines
   - If no, flag as regressions needing fixes

**Output**: Visual regression report with diff images

**Comparison Time**: ~1-2 seconds per image pair

---

### Phase 7: Fix Recommendation Generation

**Purpose**: Map visual issues to source code and generate actionable fixes

**Steps:**
1. **Correlate issues with source code**
   - Use test file metadata to identify component under test
   - Search codebase for relevant files (component, styles, layout)
   - Match visual issues to likely code locations

2. **Generate fix recommendations**
   - For each issue, provide:
     - **Issue description**: Natural language explanation
     - **File location**: `src/components/Button.tsx:45`
     - **Current code**: Snippet showing problematic code
     - **Recommended fix**: Specific code change
     - **Reasoning**: Why this fix addresses the issue

3. **Prioritize fixes**
   - Sort by severity (critical → low)
   - Group related fixes (same component, same file)
   - Estimate complexity (simple CSS tweak vs. complex refactor)

4. **Format as actionable report**
   ```markdown
   # Visual Bug Fix Recommendations

   ## Critical Issues (2)

   ### 1. Button text cut off on mobile viewport
   **Location**: `src/components/Button.tsx:45`
   **Screenshot**: `screenshots/current/button-mobile-1234.png`

   **Current Code**:
   ```tsx
   <button className="px-4 py-2 text-lg">
     {children}
   </button>
   ```

   **Recommended Fix**:
   ```tsx
   <button className="px-4 py-2 text-sm sm:text-lg truncate max-w-full">
     {children}
   </button>
   ```

   **Reasoning**: Fixed width and font size cause overflow on narrow viewports. Added responsive text sizing and truncation.
   ```

**Output**: fix-recommendations.md with prioritized, actionable fixes

---

### Phase 8: Test Suite Export

**Purpose**: Provide production-ready test suite for ongoing use

**Steps:**
1. **Export test files**
   - Copy generated tests to project's tests/ directory
   - Ensure proper TypeScript types and imports
   - Add comments explaining test purpose

2. **Create README documentation**
   ```markdown
   # Playwright E2E Test Suite

   ## Running Tests
   ```bash
   npm run test:e2e              # Run all e2e tests
   npm run test:e2e:headed       # Run with browser UI
   npm run test:e2e:debug        # Run with Playwright Inspector
   ```

   ## Screenshot Management
   - Baselines: `screenshots/baselines/`
   - Current: `screenshots/current/`
   - Diffs: `screenshots/diffs/`

   ## Updating Baselines
   ```bash
   npm run test:e2e:update-snapshots
   ```
   ```

3. **Add npm scripts**
   ```json
   {
     "scripts": {
       "test:e2e": "playwright test",
       "test:e2e:headed": "playwright test --headed",
       "test:e2e:debug": "playwright test --debug",
       "test:e2e:update-snapshots": "playwright test --update-snapshots"
     }
   }
   ```

4. **Document CI/CD integration**
   - Provide GitHub Actions workflow example
   - Explain screenshot artifact storage
   - Show how to update baselines in CI
   - Configure Playwright HTML reporter for CI

**Output**: Complete, documented test suite ready for development workflow

---

## Performance Characteristics

### Execution Times (Typical React App)

- **Application detection**: ~5 seconds
- **Playwright installation**: ~2-3 minutes (one-time)
- **Configuration generation**: ~10 seconds
- **Test generation**: ~30 seconds
- **Test execution** (5 tests): ~30-60 seconds
- **Screenshot capture**: ~1-2 seconds per screenshot
- **Visual analysis** (10 screenshots): ~1-2 minutes
- **Regression comparison**: ~10 seconds
- **Fix generation**: ~30 seconds

**Total end-to-end time**: ~5-8 minutes (excluding Playwright install)

### Resource Usage

- **Disk space**: ~500MB (Playwright browsers)
- **Memory**: ~500MB during test execution
- **Screenshots**: ~1-2MB per full-page screenshot

## Error Handling

### Framework Version Errors (NEW)

**Tailwind CSS v4 Syntax Mismatch**
- **Symptom**: Console error "Cannot apply unknown utility class" or "Utilities must be known at build time"
- **Cause**: Tailwind v4 installed but CSS uses old v3 `@tailwind` directive syntax
- **Root Cause**: Breaking change in Tailwind v4 - changed from `@tailwind` to `@import` syntax
- **Detection**: Pre-flight health check catches this before running tests
- **Auto-fix Available**: Yes - skill detects version and uses correct template
- **Manual Fix**:
  ```css
  // Old (v3):
  @tailwind base;
  @tailwind components;
  @tailwind utilities;

  // New (v4):
  @import "tailwindcss";
  ```
- **Also Update**: `postcss.config.js` - change `tailwindcss: {}` to `'@tailwindcss/postcss': {}`
- **Prevention**: Skill now consults `data/framework-versions.yaml` and selects appropriate template
- **Documentation**: https://tailwindcss.com/docs/upgrade-guide

**PostCSS Plugin Not Found**
- **Symptom**: Build error "Plugin tailwindcss not found" or "Cannot find module 'tailwindcss'"
- **Cause**: Tailwind v4 renamed PostCSS plugin but config uses old name
- **Root Cause**: PostCSS plugin changed from `tailwindcss` to `@tailwindcss/postcss` in v4
- **Detection**: Pre-flight check or build error
- **Auto-fix Available**: Yes - version detection selects correct PostCSS template
- **Manual Fix**:
  ```javascript
  // postcss.config.js
  // Old (v3):
  export default {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    },
  };

  // New (v4):
  export default {
    plugins: {
      '@tailwindcss/postcss': {},
      autoprefixer: {},
    },
  };
  ```
- **Verification**: Run `npm list @tailwindcss/postcss` to confirm installation
- **Prevention**: Skill uses `templates/configs/postcss-tailwind-v4.js` for Tailwind v4

**Version Incompatibility Warning**
- **Symptom**: Skill warns "Unknown version detected" or "Version outside known ranges"
- **Cause**: Framework version not in compatibility database
- **Impact**: Skill may use outdated templates or incorrect syntax
- **Solution**:
  1. Check `data/framework-versions.yaml` for supported versions
  2. If version is newer, skill uses latest known template (may need manual adjustment)
  3. If version is older, skill may suggest upgrading
- **Reporting**: Please report unknown versions as GitHub issues to improve skill
- **Workaround**: Manually specify template paths if needed

### Common Issues

**Application not detected**
- **Cause**: Unrecognized framework or missing package.json
- **Solution**: Ask user to specify app type and dev server command manually
- **Fallback**: Use generic static site configuration

**Dev server not running**
- **Cause**: Application not started before running tests
- **Solution**: Attempt to start server automatically using detected script (npm run dev)
- **Fallback**: Prompt user to start server manually

**Playwright installation fails**
- **Cause**: Network issues, permissions, incompatible Node version
- **Solution**: Check Node version (>=16), retry with --force, suggest manual installation
- **Debugging**: Show full error output, check npm logs

**Screenshot capture fails**
- **Cause**: Timeout waiting for page load, element not found, navigation error
- **Solution**: Increase timeout, add explicit waits, capture partial screenshot on failure
- **Recovery**: Continue with other tests, report failure with details

**No baselines exist for comparison**
- **Cause**: First test run, baselines deleted
- **Solution**: Current screenshots become baselines automatically
- **Message**: "No baselines found. Current screenshots saved as baselines."

**Visual analysis fails**
- **Cause**: LLM API error, screenshot file corruption, unsupported format
- **Solution**: Retry analysis, skip corrupted images, validate PNG format
- **Fallback**: Provide raw screenshots for manual inspection

## Success Criteria

- [ ] Playwright installed successfully with all browsers (Chromium, Firefox, WebKit)
- [ ] playwright.config.ts generated with app-specific settings
- [ ] Test suite created with at least 3-5 critical journey tests
- [ ] Screenshot capture working at all defined interaction points
- [ ] Screenshots organized in proper directory structure with metadata
- [ ] Visual analysis completed for all screenshots with issue categorization
- [ ] Regression comparison performed (or baselines created if first run)
- [ ] Fix recommendations generated with file:line references and code snippets
- [ ] Test suite exported to project with documentation
- [ ] All tests executable via npm run test:e2e
- [ ] README includes usage instructions and CI/CD guidance
- [ ] No security issues (credentials not logged, sensitive data not captured)

## Reference Materials

### Data Directory (`data/`)

- `playwright-best-practices.md` - Official Playwright best practices
- `accessibility-checks.md` - WCAG 2.1 AA criteria for visual analysis
- `common-ui-bugs.md` - Reference guide for LLM visual analysis
- `framework-detection-patterns.yaml` - Patterns for app type detection
- **`framework-versions.yaml` (NEW)** - Version compatibility database with breaking changes
- **`error-patterns.yaml` (NEW)** - Known error patterns with recovery steps

### Scripts Directory (`scripts/`)

- `setup-playwright.sh` - Playwright installation automation
- `generate-tests.ts` - Test generation from templates
- `capture-screenshots.ts` - Screenshot orchestration
- `analyze-visual.ts` - LLM-powered visual analysis
- `compare-regression.ts` - Baseline comparison logic
- `generate-fixes.ts` - Fix recommendation engine

### Templates Directory (`templates/`)

- `playwright.config.template.ts` - Playwright config for different app types
- `page-object.template.ts` - Page object model template
- `test-spec.template.ts` - Test specification template
- `screenshot-helper.template.ts` - Screenshot utilities
- `global-setup.template.ts` - Dev server startup
- `global-teardown.template.ts` - Cleanup and manifest generation
- **`css/tailwind-v3.css` (NEW)** - Tailwind CSS v3 syntax (@tailwind directives)
- **`css/tailwind-v4.css` (NEW)** - Tailwind CSS v4 syntax (@import)
- **`css/vanilla.css` (NEW)** - Vanilla CSS template (no framework)
- **`configs/postcss-tailwind-v3.js` (NEW)** - PostCSS config for Tailwind v3
- **`configs/postcss-tailwind-v4.js` (NEW)** - PostCSS config for Tailwind v4

### Examples Directory (`examples/`)

- `react-vite/` - Example setup for React + Vite
- `nextjs/` - Example setup for Next.js
- `express/` - Example setup for Node.js/Express
- `static/` - Example setup for static sites
- `screenshot-report.md` - Sample visual analysis report
- `fix-recommendations.md` - Sample fix generation output

---

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Playwright E2E Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18

      - name: Install dependencies
        run: npm ci

      - name: Install Playwright browsers
        run: npx playwright install --with-deps

      - name: Run Playwright tests
        run: npm run test:e2e

      - name: Upload screenshots
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: playwright-screenshots
          path: screenshots/

      - name: Upload HTML report
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: playwright-report
          path: playwright-report/
```

### Baseline Management in CI

1. **Store baselines in repository**:
   ```bash
   git add screenshots/baselines/
   git commit -m "chore: update visual regression baselines"
   ```

2. **Update baselines on approval**:
   - Run tests locally: `npm run test:e2e`
   - Review diffs: `npx playwright show-report`
   - Update baselines: `npm run test:e2e:update-snapshots`
   - Commit updated baselines

3. **Fail CI on visual regressions**:
   - Configure threshold in playwright.config.ts
   - Tests fail if diffs exceed threshold
   - Review in CI artifacts before merging

---

## Important Reminders

1. **Always capture screenshots before AND after interactions** - This provides context for visual debugging
2. **Use semantic selectors** - Prefer getByRole, getByLabel over CSS selectors for test stability
3. **Baseline management is critical** - Keep baselines in sync with intentional UI changes
4. **LLM analysis is supplementary** - Use it alongside automated assertions, not as replacement
5. **Test critical paths first** - Focus on user journeys that matter most (80/20 rule)
6. **Screenshots are large** - Consider .gitignore for screenshots/, use CI artifacts
7. **Run tests in CI** - Catch visual regressions before they reach production
8. **Update baselines deliberately** - Review diffs carefully before accepting as new baseline

---

**Remember:** This skill automates the entire Playwright setup and visual testing workflow. Simply trigger it, and it will handle detection, installation, test generation, screenshot capture, visual analysis, and fix recommendations automatically. The exported test suite is production-ready and can be integrated into your development workflow immediately.
