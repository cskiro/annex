---
name: semantic-release-tagger
description: Automated git tagging agent that analyzes your repository, parses conventional commits, recommends semantic versions, and executes tag creation with your confirmation
---

# Semantic Release Tagger

## Overview

This skill is an **interactive automation agent** that handles the complete git tagging workflow. It analyzes your repository state, detects existing conventions, parses conventional commits to determine version bumps, and executes tag creation commands with your confirmation.

**Key Capabilities**:
- **Auto-analyze repository context**: Detect existing tags, conventions, and monorepo structure
- **Intelligent version calculation**: Parse conventional commits (feat/fix/BREAKING) to determine MAJOR.MINOR.PATCH bumps
- **Convention detection & consistency auditing**: Identify tag patterns, detect inconsistencies
- **Automated tag creation**: Execute git commands after user confirmation
- **GitHub release integration**: Optional release creation with auto-generated changelog
- **Monorepo awareness**: Component-specific versioning with namespace support

**Based On**: 7 version-control insights from production release workflows (2025-11-14 to 2025-11-15)

## When to Use This Skill

**Trigger Phrases**:
- "how should I tag this release?"
- "version this component"
- "create semantic git tags"
- "tag naming convention"
- "monorepo versioning strategy"
- "git tag vs github release"
- "semantic versioning guidance"

**Use PROACTIVELY when**:
- User is about to create a release or tag
- User asks about versioning strategy for a project
- User mentions monorepo or multi-component versioning
- User is setting up release automation
- User asks about tag organization or cleanup

**Do NOT use when**:
- User wants to create a branch (not a tag)
- User is working with version numbers in code (package.json, etc.) - this skill is for git tags only
- User needs help with changelog generation (use release-management skill instead)

## Response Style

**Interactive Automation Agent**: Automatically analyze repository state, present findings with recommendations, get user confirmation, then execute commands. Prioritize automation over documentation. Always run analysis commands before presenting options.

**Execution Pattern**:
1. **Auto-execute**: Run git commands to gather context (no user prompt needed)
2. **Present findings**: Show detected conventions, latest versions, commits since last tag
3. **Recommend action**: Calculate next version based on conventional commits
4. **Confirm with user**: "Create tag `component@X.Y.Z`? [Yes/No/Customize]"
5. **Execute**: Run git tag/push commands after confirmation
6. **Verify**: Show results and next steps

---

## Workflow

### Phase 0: Auto-Context Analysis (Runs First, Automatically)

**Purpose**: Gather repository state without user interaction to provide intelligent recommendations.

**Steps** (execute immediately when skill activates):

1. **Detect repository structure**:
   ```bash
   # Check if git repository
   git rev-parse --git-dir 2>/dev/null

   # List all tags sorted by version
   git tag -l --sort=-v:refname

   # Count unique tag patterns
   git tag -l | grep -E '@|/' | wc -l
   ```

2. **Identify existing convention**:
   - Parse tag patterns: Look for `@`, `/v`, or flat `v` patterns
   - Detect most common convention (majority wins)
   - Flag inconsistencies if multiple patterns found
   - Example output:
     ```
     ✅ Detected convention: npm-style @ separator
     📊 Tags analyzed: 15
     ⚠️  Found inconsistency: 2 tags use /v separator (outdated)
     ```

3. **Parse latest versions per component** (if monorepo):
   ```bash
   # For @ convention
   git tag -l | grep '@' | cut -d'@' -f1 | sort -u

   # For each component, get latest version
   for component in $(git tag -l | grep '@' | cut -d'@' -f1 | sort -u); do
     git tag -l "${component}@*" --sort=-v:refname | head -1
   done
   ```

4. **Analyze commits since last tag**:
   ```bash
   # Get latest tag for component (or overall)
   LAST_TAG=$(git tag -l "marketplace@*" --sort=-v:refname | head -1)

   # Get commits since last tag
   git log ${LAST_TAG}..HEAD --oneline --format="%s"
   ```

5. **Classify changes using conventional commits**:
   - Parse commit prefixes: `feat:`, `fix:`, `chore:`, `BREAKING CHANGE:`
   - Determine version bump type:
     - BREAKING CHANGE or `!` suffix → MAJOR
     - `feat:` → MINOR
     - `fix:` or `chore:` → PATCH
   - Count commits by type for changelog

6. **Calculate recommended next version**:
   ```
   Current: marketplace@1.1.3
   Commits: 1 chore (README update)
   Type: PATCH bump
   Recommended: marketplace@1.1.4
   ```

7. **Present findings to user**:
   ```
   📦 Repository Analysis:
   - Convention: @ separator (npm-style)
   - Latest tag: marketplace@1.1.3
   - Commits since tag: 1
     • chore: Update README.md
   - Change classification: PATCH (documentation only)

   💡 Recommendation: marketplace@1.1.4

   Proceed with tag creation? [Yes/No/Customize]
   ```

**Output**: Complete repository context analysis with version recommendation.

**Common Issues**:
- **No existing tags**: Recommend starting at `component@0.1.0`
- **Mixed conventions**: Warn and recommend migration path
- **No conventional commits**: Fall back to user-guided version selection

---

### Phase 1: Choose Tag Naming Convention (If No Convention Detected)

**Purpose**: Select the optimal tag naming pattern based on repository structure and team conventions.

**Steps**:

1. **Assess repository structure**:
   - Ask: "Is this a monorepo with multiple independently-versioned components?"
   - Single-component repo: Simpler flat tags work well
   - Multi-component repo: Namespaced tags provide clarity

2. **Understand existing conventions**:
   - Check current tags: `git tag -l`
   - If tags exist, recommend consistency with current pattern
   - If no tags exist, choose based on best practices below

3. **Choose namespace separator** (for multi-component repos):

   **Option A: Slash-based namespacing** (`component/vX.Y.Z`)
   - Pros: Hierarchical, supports git tag filtering (`git tag -l "hook/*"`)
   - Pros: CI/CD can trigger on patterns (`hook/*` vs `skill/*`)
   - Cons: Can be confused with directory paths
   - Example: `marketplace/v1.0.0`, `hook/extract-insights/v2.1.0`

   **Option B: NPM-style @ separator** (`component@X.Y.Z`)
   - Pros: Familiar to JavaScript developers (`@scope/package@version`)
   - Pros: Cleaner URLs, semantic clarity, path-safe
   - Pros: No confusion with directory separators
   - Cons: Less common in non-JS ecosystems
   - Note: `v` prefix optional with `@` (separator itself indicates version)
   - Example: `marketplace@1.0.0`, `extract-insights@2.1.0`

   **Option C: Flat tags with prefixes** (`vX.Y.Z`)
   - Pros: Simple, universal, works everywhere
   - Cons: Doesn't scale to multi-component repos
   - Example: `v1.0.0`, `v2.1.0`

4. **Recommend based on context**:
   - **Monorepo with multiple components**: Use Option A or B
   - **JavaScript/npm ecosystem**: Prefer Option B (`@` separator)
   - **Single component**: Use Option C (flat `vX.Y.Z`)
   - **Team familiarity**: If team uses npm daily, choose Option B

5. **Document the decision**:
   - Add tag convention to project README or CONTRIBUTING.md
   - Example:
     ```markdown
     ## Versioning

     We use namespaced semantic versioning with @ separator:
     - Marketplace: `marketplace@X.Y.Z`
     - Skills: `skill-name@X.Y.Z`
     - Hooks: `hook-name@X.Y.Z`
     ```

**Output**: Chosen tag naming convention documented and agreed upon.

**Common Issues**:
- **Mixing conventions**: Once chosen, stick to one convention. Mixing `marketplace/v1.0.0` and `marketplace@2.0.0` creates confusion.
- **Forgetting namespace**: In monorepos, always include namespace even for "main" component. Use `marketplace@1.0.0`, not `v1.0.0`.

---

### Phase 2: Determine Version Number

**Purpose**: Calculate the correct semantic version number following SemVer rules.

**Steps**:

1. **Understand semantic versioning format**: `MAJOR.MINOR.PATCH`
   - **MAJOR**: Breaking changes, incompatible API changes
   - **MINOR**: New features, backward-compatible additions
   - **PATCH**: Bug fixes, backward-compatible fixes

2. **Identify the current version**:
   - Find latest tag: `git tag -l "component@*" --sort=-v:refname | head -1`
   - If no tags exist, start at `0.1.0` (not `1.0.0`)
   - Why `0.1.0`? Signals "initial public release, not production-ready"

3. **Analyze changes since last tag**:
   - Review commits: `git log <last-tag>..HEAD --oneline`
   - Check for:
     - Breaking changes (MAJOR bump)
     - New features (MINOR bump)
     - Bug fixes only (PATCH bump)

4. **Apply version bump rules**:

   | Change Type | Current | New Version |
   |-------------|---------|-------------|
   | Breaking change | `1.2.3` | `2.0.0` |
   | New feature | `1.2.3` | `1.3.0` |
   | Bug fix | `1.2.3` | `1.2.4` |
   | First release | N/A | `0.1.0` |
   | Production ready | `0.x.x` | `1.0.0` |

5. **Special version bump scenarios**:
   - **Pre-1.0.0 versions**: Breaking changes still bump MINOR (0.2.0 → 0.3.0)
   - **Multiple change types**: Use highest severity (feature + bug fix → MINOR)
   - **No changes**: Don't create a tag (wait for actual changes)

6. **Validate version number**:
   - Confirm version doesn't already exist: `git tag -l "component@X.Y.Z"`
   - Ensure version is higher than latest: `X.Y.Z > current version`

**Output**: Calculated semantic version number ready for tagging.

**Common Issues**:
- **Starting at 1.0.0**: Reserve for production-ready releases. Use 0.1.0 for initial releases.
- **Skipping versions**: Don't skip (e.g., 1.0.0 → 1.2.0). Increment by 1 only.
- **Inconsistent component versioning**: Component version ≠ internal script version. Tag what users see.

---

### Phase 3: Create Git Tags (Automated with Confirmation)

**Purpose**: Execute tag creation commands after user confirmation.

**Steps**:

1. **Prepare tag details** (from Phase 0 analysis and Phase 2 calculation):
   ```
   Tag name: marketplace@1.1.4
   Tag message: "Release marketplace 1.1.4"
   Tag type: Annotated (with metadata)
   ```

2. **Show exact commands to be executed**:
   ```bash
   # Commands that will run:
   git tag -a "marketplace@1.1.4" -m "Release marketplace 1.1.4"
   git push origin marketplace@1.1.4
   ```

3. **Request user confirmation**:
   ```
   Ready to create and push tag marketplace@1.1.4?
   - This will create an annotated tag on current HEAD
   - Tag will be pushed to remote origin
   - Tag cannot be easily modified once pushed

   [Yes, create tag] [No, cancel] [Customize message]
   ```

4. **Execute commands** (after user confirms "Yes"):
   ```bash
   # Create annotated tag
   git tag -a "marketplace@1.1.4" -m "Release marketplace 1.1.4"

   # Verify tag created
   git show marketplace@1.1.4 --quiet

   # Push to remote
   git push origin marketplace@1.1.4
   ```

5. **Verify and report results**:
   ```bash
   # Check tag exists locally
   git tag -l "marketplace@1.1.4"

   # Check tag pushed to remote
   git ls-remote --tags origin | grep marketplace@1.1.4

   # Show tag details
   git show marketplace@1.1.4
   ```

6. **Present success confirmation**:
   ```
   ✅ Tag created successfully!

   Tag: marketplace@1.1.4
   Commit: abc123de (current HEAD)
   Pushed to: origin
   Tagger: Connor <connor@example.com>
   Date: 2025-11-16 10:51:00

   View on GitHub:
   https://github.com/user/repo/releases/tag/marketplace@1.1.4

   Next steps:
   - Create GitHub release? [Yes/No]
   - Tag another component? [Yes/No]
   ```

**Output**: Git tag created, pushed to remote, and verified with success confirmation.

**Automation Features**:
- ✅ **Auto-generates tag message** from component name and version
- ✅ **Pre-flight checks**: Verifies tag doesn't already exist
- ✅ **Atomic execution**: Tag creation + push in sequence
- ✅ **Error handling**: Rolls back local tag if push fails
- ✅ **Verification**: Confirms tag exists both locally and remotely

**Common Issues** (handled automatically):
- **Tag already exists**: Check before creation, prompt to overwrite or choose new version
- **Push fails**: Keep local tag, warn user, offer retry
- **Wrong commit**: Ask user to confirm current HEAD before tagging

---

### Phase 4: Create GitHub Release (Automated with Confirmation)

**Purpose**: Create user-friendly GitHub release with auto-generated changelog from commits.

**Steps**:

1. **Check if GitHub CLI is available**:
   ```bash
   # Verify gh CLI installed
   gh --version

   # Check authentication
   gh auth status
   ```

2. **Auto-generate changelog from commits** (since last tag):
   ```bash
   # Get commits between tags
   git log marketplace@1.1.3..marketplace@1.1.4 --oneline --format="- %s"

   # Group by conventional commit type
   # feat: → ### Features
   # fix: → ### Bug Fixes
   # chore: → ### Maintenance
   ```

   Example generated changelog:
   ```markdown
   ## What's Changed

   ### Maintenance
   - chore: Update README.md with new examples

   **Full Changelog**: https://github.com/user/repo/compare/marketplace@1.1.3...marketplace@1.1.4
   ```

3. **Present release preview to user**:
   ```
   📋 GitHub Release Preview:

   Tag: marketplace@1.1.4
   Title: "Marketplace v1.1.4"
   Pre-release: No (version >= 1.0.0)

   Changelog (auto-generated):
   ### Maintenance
   - chore: Update README.md with new examples

   Create GitHub release now? [Yes/No/Edit changelog]
   ```

4. **Execute release creation** (after confirmation):
   ```bash
   # Determine if pre-release (version < 1.0.0)
   PRERELEASE_FLAG=""
   if [[ "1.1.4" =~ ^0\. ]]; then
     PRERELEASE_FLAG="--prerelease"
   fi

   # Create release with auto-generated notes
   gh release create marketplace@1.1.4 \
     --title "Marketplace v1.1.4" \
     --notes "$(cat /tmp/changelog.md)" \
     ${PRERELEASE_FLAG}
   ```

5. **Verify release created**:
   ```bash
   # Check release exists
   gh release view marketplace@1.1.4

   # Get release URL
   gh release view marketplace@1.1.4 --json url -q .url
   ```

6. **Present success confirmation**:
   ```
   ✅ GitHub Release created successfully!

   Release: marketplace@1.1.4
   URL: https://github.com/user/repo/releases/tag/marketplace@1.1.4
   Pre-release: No
   Published: Yes
   Notifications: Sent to watchers

   Next steps:
   - View release on GitHub: [Open URL]
   - Tag another component? [Yes/No]
   - Done
   ```

**Output**: GitHub release published with auto-generated changelog.

**Automation Features**:
- ✅ **Auto-generated changelog**: Parsed from conventional commits
- ✅ **Smart pre-release detection**: Versions < 1.0.0 marked as pre-release
- ✅ **gh CLI integration**: One-command release creation
- ✅ **Changelog grouping**: Commits grouped by type (feat/fix/chore)
- ✅ **Full changelog link**: Comparison URL auto-included

**Common Issues** (handled automatically):
- **gh CLI not installed**: Warn user, provide installation instructions, fallback to web UI
- **Not authenticated**: Guide user through `gh auth login`
- **Empty changelog**: Use default message "Release vX.Y.Z" if no conventional commits

---

### Phase 5: Maintain Tag History

**Purpose**: Keep tag history clean, organized, and automation-friendly.

**Steps**:

1. **Filter tags by component** (monorepos):
   ```bash
   # List all marketplace tags
   git tag -l "marketplace@*"

   # List all hook tags
   git tag -l "hook/*"

   # List with sort (latest first)
   git tag -l "component@*" --sort=-v:refname
   ```

2. **Find latest version programmatically**:
   ```bash
   # Latest marketplace version
   git tag -l "marketplace@*" --sort=-v:refname | head -1

   # Extract version number only
   git tag -l "marketplace@*" --sort=-v:refname | head -1 | cut -d'@' -f2
   ```

3. **Set up CI/CD tag triggers**:
   - GitHub Actions example:
     ```yaml
     on:
       push:
         tags:
           - 'marketplace@*'  # Trigger on marketplace tags only
           - 'hook/*'         # Trigger on any hook tag
     ```

4. **Clean up tags** (use cautiously):
   ```bash
   # Delete local tag
   git tag -d old-tag-name

   # Delete remote tag (DANGEROUS - coordinate with team)
   git push origin :refs/tags/old-tag-name
   ```

5. **Fast-forward merge awareness**:
   - When GitHub shows "Fast-forward" on PR merge, it means:
     - Main branch pointer moved forward without merge commit
     - Linear history maintained (no divergence)
     - Happens when PR branch is directly ahead of main
   - Tags created after fast-forward merge will reference the correct commit

6. **Tag maintenance best practices**:
   - Never modify published tags (immutable release markers)
   - Document tag conventions in repository
   - Use automation to enforce tag format
   - Archive old tags in changelog, don't delete

**Output**: Clean, organized tag history with automation support.

**Common Issues**:
- **Deleting published tags**: Avoid deleting tags that users may depend on
- **Inconsistent tag patterns**: Automation breaks if tags don't follow consistent format
- **Missing tag documentation**: Always document your tagging convention in README

---

## Reference Materials

**Source Insights**:
- [Insights Reference](data/insights-reference.md) - Complete consolidated insights from version-control category

**Examples**:
- [Tag Creation Examples](examples/tag-examples.md) - Real-world tagging scenarios

**Related Skills**:
- `release-management` - For changelog generation and deployment
- `monorepo-workflow` - For managing multi-component repositories

---

## Important Reminders

- **Start at 0.1.0, not 1.0.0**: Reserve 1.0.0 for production-ready releases
- **Consistency is critical**: Pick one tag convention and stick to it across the entire repository
- **Tags are immutable**: Once pushed, don't modify or delete tags (users may depend on them)
- **Annotated tags preferred**: Use `git tag -a` for all releases (stores metadata)
- **Push tags explicitly**: `git push` doesn't push tags automatically, use `git push origin <tagname>`
- **Namespace for monorepos**: Even if you have one "main" component, use namespaced tags for future scalability
- **Git tags ≠ GitHub releases**: Tags are required, releases are optional but add discoverability
- **Fast-forward merges preserve history**: Linear history makes tagging cleaner and more predictable

**Warnings**:
- ⚠️  **Don't mix tag conventions** (e.g., `marketplace/v1.0.0` and `marketplace@2.0.0`)
- ⚠️  **Don't skip version numbers** (e.g., 1.0.0 → 1.2.0). Always increment by 1
- ⚠️  **Don't delete published tags** without team coordination (breaks dependencies)
- ⚠️  **Don't use lightweight tags for releases** (use annotated tags with `-a` flag)

---

## Troubleshooting

### Tag creation fails with "already exists"

**Symptoms**: `git tag` returns error "tag 'component@1.0.0' already exists"

**Solution**:
1. Check if tag exists: `git tag -l "component@1.0.0"`
2. If exists locally but wrong, delete: `git tag -d component@1.0.0`
3. If exists remotely, coordinate with team before deleting
4. Choose next version number instead (e.g., 1.0.1)

**Prevention**: Always check latest version before creating tags: `git tag -l "component@*" --sort=-v:refname | head -1`

---

### Tag pushed but GitHub release not visible

**Symptoms**: `git tag` exists but doesn't show in GitHub releases page

**Solution**:
1. Verify tag pushed to remote: `git ls-remote --tags origin | grep component@1.0.0`
2. Create GitHub release manually: `gh release create component@1.0.0`
3. Or use GitHub web UI: Releases → "Draft a new release" → Choose tag

**Prevention**: Git tags and GitHub releases are separate. Tags don't automatically create releases.

---

### CI/CD not triggering on tag push

**Symptoms**: Pushed tag but workflow didn't run

**Solution**:
1. Check workflow tag pattern: Does `marketplace@*` match your tag format?
2. Verify trigger configured:
   ```yaml
   on:
     push:
       tags:
         - 'marketplace@*'
   ```
3. Test pattern locally: `echo "marketplace@1.0.0" | grep -E "marketplace@.*"`

**Prevention**: Document and test tag patterns before setting up automation

---

### Monorepo tags confusing (which component version?)

**Symptoms**: Hard to tell which version applies to which component

**Solution**:
1. Always use namespaced tags: `component@X.Y.Z`
2. Never use flat tags (`v1.0.0`) in monorepos
3. List tags by component: `git tag -l "component@*"`
4. Update README with tagging convention

**Prevention**: Establish and document tag namespace convention early in project

---

## Metadata

**Version**: 0.1.0
**Created**: 2025-11-16
**Author**: Connor
**Category**: release-management
**Source**: Generated from 7 insights (docs/lessons-learned/version-control/)
**Pattern**: Automated phase-based workflow with execution
**Complexity**: Standard
