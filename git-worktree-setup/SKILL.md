---
name: git-worktree-setup
version: 1.0.0
description: Automated git worktree setup for parallel Claude Code sessions with prerequisite checking, development environment initialization, and safe cleanup
author: Connor
---

# Git Worktree Setup Skill

## Overview

This skill automates the setup of git worktrees to enable parallel Claude Code sessions. It handles prerequisite validation, worktree creation, development environment setup, and provides safe cleanup utilities. Users can work on multiple branches simultaneously without conflicts or state pollution.

## When to Use This Skill

**Trigger Phrases:**
- "create a worktree for [branch-name]"
- "set up worktree for [feature]"
- "I need to work on [branch] in parallel"
- "create worktrees for [branch1], [branch2], [branch3]"
- "set up multiple worktrees"
- "remove worktree [name]"
- "clean up worktrees"
- "list my worktrees"
- "show worktree status"

**Use Cases:**
- Working on multiple features simultaneously
- Running parallel Claude Code sessions on different branches
- Testing changes across branches without switching
- Code review while continuing development
- Emergency hotfixes without interrupting feature work

## Response Style

- **Proactive**: Check prerequisites before starting, prevent errors
- **Informative**: Show clear progress updates and verification steps
- **Safe**: Always validate state, confirm destructive operations
- **Helpful**: Provide next steps and commands to use the worktree

## Quick Decision Matrix

```
User Request                           → Mode          → Action
─────────────────────────────────────────────────────────────────
"create worktree for feature-x"       → Single        → Create one worktree
"set up worktrees for a, b, c"        → Batch         → Create multiple worktrees
"remove worktree feature-x"            → Cleanup       → Remove specific worktree
"clean up all worktrees"               → Cleanup       → Remove all worktrees
"list worktrees" / "show worktrees"    → List/Manage   → Display status
```

## Mode Detection Logic

```javascript
// Mode 1: Single Worktree
if (userMentions("create worktree") && singleBranch) {
  return "mode1-single-worktree";
}

// Mode 2: Batch Worktrees
if (userMentions("multiple") || multipleBranches) {
  return "mode2-batch-worktrees";
}

// Mode 3: Cleanup
if (userMentions("remove", "cleanup", "delete") && userMentions("worktree")) {
  return "mode3-cleanup";
}

// Mode 4: List/Manage
if (userMentions("list", "show", "status") && userMentions("worktree")) {
  return "mode4-list-manage";
}

// Ambiguous - ask user
return askForClarification();
```

## Core Responsibilities

### 1. Prerequisite Validation
- ✓ Verify current directory is a git repository
- ✓ Check for uncommitted changes (warn if dirty)
- ✓ Validate branch exists (for existing branches)
- ✓ Ensure target directory doesn't exist
- ✓ Verify disk space availability

### 2. Worktree Creation
- ✓ Create worktree with sensible defaults
- ✓ Use pattern: `../project-name-branch-name`
- ✓ Handle both new and existing branches
- ✓ Generate executable setup scripts

### 3. Development Environment Setup
- ✓ Detect package manager (npm/pnpm/yarn/bun)
- ✓ Offer to run install commands
- ✓ Copy environment files if needed
- ✓ Verify setup succeeded

### 4. User Guidance
- ✓ Show path to new worktree
- ✓ Provide commands to navigate
- ✓ Explain how to start Claude Code
- ✓ List all worktrees for reference

### 5. Safe Cleanup
- ✓ Confirm before removing worktrees
- ✓ Check for uncommitted changes
- ✓ Remove both worktree and branch (optional)
- ✓ Update user on cleanup results

## Workflow Overview

### Phase 0: Prerequisites (MANDATORY)

**Check git repository:**
```bash
git rev-parse --is-inside-work-tree
```
- If fails → STOP: "Not in a git repository"

**Get repository name:**
```bash
basename $(git rev-parse --show-toplevel)
```

**Check for uncommitted changes:**
```bash
git status --porcelain
```
- If output exists → WARN: "You have uncommitted changes. Continue anyway?"

**Check if branch exists (for existing branches):**
```bash
git show-ref --verify refs/heads/[branch-name]
```

### Phase 1: Gather Information

**Ask user for required info:**
1. Branch name (required)
2. New or existing branch? (auto-detect if possible)
3. Worktree location (default: `../repo-branch`)
4. Setup dev environment? (default: yes)

**Smart defaults:**
- Location: `../[repo-name]-[branch-name]`
- Dev setup: yes (if package.json exists)
- Open in new terminal: offer but don't assume

### Phase 2: Create Worktree

**For new branch:**
```bash
git worktree add ../project-feature-x -b feature-x
```

**For existing branch:**
```bash
git worktree add ../project-bugfix-123 bugfix-123
```

**Verify creation:**
```bash
git worktree list
```

### Phase 3: Setup Development Environment

**Detect package manager:**
```bash
# Check for lock files
- pnpm-lock.yaml → pnpm
- yarn.lock → yarn
- bun.lockb → bun
- package-lock.json → npm
```

**Run installation:**
```bash
cd [worktree-path]
[package-manager] install
```

**Copy environment files (if user confirms):**
```bash
cp ../.env [worktree-path]/.env
```

### Phase 4: Provide Next Steps

**Show summary:**
```
✓ Worktree created: /path/to/worktree
✓ Branch: feature-x
✓ Development environment: ready

Next steps:
1. Navigate: cd /path/to/worktree
2. Start Claude Code: claude
3. Begin work on your feature

All worktrees:
- /path/to/main (main) ← current
- /path/to/worktree (feature-x) ← new
```

## Known Issues & Fixes

### Issue: "fatal: invalid reference"
**Cause:** Branch doesn't exist
**Fix:** Verify branch name or create new branch with `-b` flag

### Issue: "worktree already exists"
**Cause:** Directory already created
**Fix:** Choose different location or remove existing worktree

### Issue: "uncommitted changes"
**Cause:** Dirty working directory
**Fix:** Commit or stash changes first (or use `--force` if user confirms)

### Issue: Package installation fails
**Cause:** Network issues or lockfile mismatch
**Fix:** Retry installation or use `--force` flag

## Safety Protocols

### Before Creating Worktree:
- [ ] Verify git repository
- [ ] Check working directory is clean
- [ ] Validate target directory is available
- [ ] Confirm branch name is valid

### During Creation:
- [ ] Monitor command output for errors
- [ ] Verify worktree appears in `git worktree list`
- [ ] Check files exist in new directory

### After Creation:
- [ ] Verify dev environment setup succeeded
- [ ] Test that worktree is functional
- [ ] Provide rollback instructions

### Before Cleanup:
- [ ] Confirm user intent
- [ ] Check for uncommitted changes in worktree
- [ ] Warn if removing branch permanently
- [ ] Provide backup instructions if needed

## Example Interactions

### Example 1: Single Worktree (New Branch)

**User:** "Create a worktree for feature-authentication"

**Assistant:**
1. Checks prerequisites ✓
2. Detects: new branch needed
3. Suggests: `../myapp-feature-authentication`
4. Creates worktree
5. Runs `npm install`
6. Provides next steps

**Result:**
```
✓ Worktree created: /Users/connor/myapp-feature-authentication
✓ Branch: feature-authentication (new)
✓ Dependencies installed

To start working:
  cd ../myapp-feature-authentication
  claude
```

### Example 2: Batch Worktrees

**User:** "Set up worktrees for feature-a, feature-b, and bugfix-123"

**Assistant:**
1. Checks prerequisites ✓
2. Detects: batch mode, 3 branches
3. Creates each worktree in parallel
4. Runs setup in each
5. Summarizes all created worktrees

### Example 3: Cleanup

**User:** "Remove the feature-authentication worktree"

**Assistant:**
1. Lists current worktrees
2. Confirms: "Remove /path/to/worktree?"
3. Checks for uncommitted changes
4. Removes worktree
5. Asks: "Delete branch too?"

## Success Criteria

- [ ] Worktree created in correct location
- [ ] Branch checked out properly
- [ ] Files visible in worktree directory
- [ ] Development environment ready (if requested)
- [ ] `git worktree list` shows new worktree
- [ ] User can `cd` to worktree and start Claude Code
- [ ] No errors in command output

## Important Reminders

1. **Always validate prerequisites** - Don't create worktrees in non-git directories
2. **Use sensible defaults** - Minimize questions to user
3. **Verify after each step** - Don't continue if previous step failed
4. **Provide clear next steps** - User should know exactly what to do
5. **Safety first** - Confirm destructive operations
6. **Share git history** - All worktrees use same .git, commits sync automatically

## Resources

- Mode workflows: `modes/mode*-*.md`
- Script templates: `templates/*.sh`
- Best practices: `data/best-practices.md`
- Troubleshooting: `data/troubleshooting.md`
- Examples: `examples/sample-workflows.md`

## Quick Reference

**Create single worktree:**
```bash
git worktree add ../project-branch-name -b branch-name
```

**Create from existing branch:**
```bash
git worktree add ../project-branch-name branch-name
```

**List all worktrees:**
```bash
git worktree list
```

**Remove worktree:**
```bash
git worktree remove ../project-branch-name
```

**Remove worktree and branch:**
```bash
git worktree remove ../project-branch-name
git branch -D branch-name
```

---

**Remember:** This skill automates parallel development workflows. When in doubt, check prerequisites, use safe defaults, and provide clear guidance to users.
