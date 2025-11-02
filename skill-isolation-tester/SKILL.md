---
name: skill-isolation-tester
version: 0.1.0
description: Automated testing framework for Claude Code skills using multiple isolation environments (git worktree, Docker containers, VMs) to validate behavior before public release
author: Connor
---

# Skill Isolation Tester

## Overview

This skill automates the testing of newly created Claude Code skills in isolated environments to ensure they work correctly without dependencies on your local development setup. It supports three isolation levels: git worktrees (fast, lightweight), Docker containers (full OS isolation), and VMs (complete isolation). Use this skill to catch environment-specific bugs, validate cleanup behavior, and ensure skills are production-ready before sharing publicly.

## When to Use This Skill

**Trigger Phrases:**
- "test skill [name] in isolation"
- "validate skill [name] in clean environment"
- "run skill isolation test for [name]"
- "test my new skill in worktree"
- "test my new skill in docker"
- "test my new skill in vm"
- "verify skill [name] works in isolation"
- "check if skill [name] has hidden dependencies"
- "run skill tests in [environment]"

**Use Cases:**
- Test newly created skill before committing to git or sharing publicly
- Validate skill doesn't have hidden dependencies on local environment
- Verify skill cleanup behavior (no leftover files/processes)
- Check skill works in fresh environment without your personal configs
- Catch environment-specific bugs before public release
- Ensure skill works for other users with different setups
- Test skill with different Claude Code versions
- Validate skill doesn't modify system state unexpectedly

## Response Style

- **Proactive**: Automatically detect appropriate isolation level based on skill complexity
- **Thorough**: Validate both execution and side effects (files, processes, configs)
- **Safety-focused**: Always use least-privilege principle and confirm destructive operations
- **Clear**: Provide detailed test results with pass/fail criteria and evidence

## Quick Decision Matrix

```
User Request                              → Mode             → Action
───────────────────────────────────────────────────────────────────────────────
"test skill X in worktree"                → Git Worktree     → Fast isolation test
"test skill X in docker"                  → Docker           → Container-based test
"test skill X in vm"                      → VM               → Full VM isolation
"test skill X" (no environment specified) → Auto-detect      → Choose based on skill risk
"validate skill X"                        → Auto-detect      → Choose based on skill risk
```

## Mode Detection Logic

```javascript
// Mode 1: Git Worktree (Fast, Lightweight)
if (userMentions("worktree") || (autoDetect && skillRisk === "low")) {
  return "mode1-git-worktree";
}

// Mode 2: Docker Container (OS Isolation)
if (userMentions("docker", "container") || (autoDetect && skillRisk === "medium")) {
  return "mode2-docker";
}

// Mode 3: VM (Complete Isolation)
if (userMentions("vm", "virtual machine") || (autoDetect && skillRisk === "high")) {
  return "mode3-vm";
}

// Auto-detect based on skill analysis
if (autoDetect) {
  return analyzeSkillAndChooseMode();
}

// Ambiguous - ask user
return askForClarification();
```

## Core Responsibilities

### 1. Environment Setup
- ✓ Create isolated environment (worktree/Docker/VM) from clean state
- ✓ Install Claude Code in isolation
- ✓ Copy skill under test to isolated environment
- ✓ Verify environment is functional before testing
- ✓ Take snapshot/checkpoint for rollback if needed

### 2. Skill Execution Testing
- ✓ Run skill with test triggers and inputs
- ✓ Capture all output (stdout, stderr, logs)
- ✓ Monitor execution time and resource usage
- ✓ Detect errors, warnings, or unexpected behavior
- ✓ Verify skill completes successfully

### 3. Side Effect Validation
- ✓ Track all file system modifications (created, modified, deleted files)
- ✓ Monitor running processes (check for orphaned processes)
- ✓ Check for modified system configs or environment variables
- ✓ Validate network activity (unexpected API calls)
- ✓ Ensure skill cleans up after itself

### 4. Dependency Detection
- ✓ Identify required system packages or tools
- ✓ Detect hardcoded paths or user-specific configurations
- ✓ Find references to local files that won't exist for other users
- ✓ Flag skills that require pre-installed dependencies
- ✓ Generate dependency list for skill documentation

### 5. Results Reporting
- ✓ Generate comprehensive test report (pass/fail with evidence)
- ✓ List all detected issues with severity levels
- ✓ Provide recommendations for fixing issues
- ✓ Compare before/after snapshots
- ✓ Cleanup isolated environment (or offer to preserve for debugging)

## Test Templates

The skill includes production-ready test templates for common skill types:

- **`test-templates/docker-skill-test.sh`** - For skills that manage Docker containers/images
- **`test-templates/api-skill-test.sh`** - For skills that make HTTP/API calls
- **`test-templates/file-manipulation-skill-test.sh`** - For skills that modify files
- **`test-templates/git-skill-test.sh`** - For skills that work with git operations

**Features:**
- Before/after snapshots for comparison
- Comprehensive safety and security checks
- Resource tracking and cleanup validation
- Detailed reporting with pass/fail criteria
- Automatic cleanup on exit

**Usage:**
```bash
chmod +x test-templates/docker-skill-test.sh
./test-templates/docker-skill-test.sh my-skill-name
```

See `test-templates/README.md` for full documentation and customization options.

---

## Helper Libraries

### Docker Helper Functions (`lib/docker-helpers.sh`)

Production-ready utilities for robust Docker testing with error handling and cleanup:

**Key Features:**
- ✓ **Shell Command Validation** - Validates syntax with `bash -n` before execution
- ✓ **Retry Logic** - Automatic retry with exponential backoff for transient failures
- ✓ **Cleanup Traps** - Guaranteed cleanup on exit (success or failure)
- ✓ **Pre-flight Checks** - Validates Docker environment before testing
- ✓ **Resource Limits** - Enforces memory and CPU limits on containers
- ✓ **Safe Operations** - Validates inputs and provides clear error messages

**Functions Available:**
- `validate_shell_command` - Check shell syntax before execution
- `retry_docker_command` - Execute with retry logic (max 3 attempts, exponential backoff)
- `cleanup_on_exit` - Trap handler for guaranteed cleanup
- `preflight_check_docker` - Validate Docker installation, daemon, disk space, permissions
- `safe_docker_build` - Build images with validation and retry
- `safe_docker_run` - Run containers with resource limits and error handling
- `is_container_running` - Check container status
- `get_container_exit_code` - Get exit code for stopped containers

**Usage Example:**
```bash
#!/bin/bash
source ~/.claude/skills/skill-isolation-tester/lib/docker-helpers.sh

# Set cleanup trap (runs automatically on exit)
trap cleanup_on_exit EXIT

# Pre-flight checks
preflight_check_docker || exit 1

# Configure cleanup behavior
export SKILL_TEST_TEMP_DIR="/tmp/skill-test-$$"
export SKILL_TEST_KEEP_CONTAINER="false"  # Remove container after test
export SKILL_TEST_REMOVE_IMAGES="true"    # Remove test images

# Build and run with automatic error handling
safe_docker_build "Dockerfile" "skill-test:my-skill"
export SKILL_TEST_IMAGE_NAME="skill-test:my-skill"

safe_docker_run "skill-test:my-skill" bash -c "echo 'Testing...'"

# Cleanup happens automatically via trap
```

**Benefits:**
- Prevents syntax errors from reaching Docker commands
- Handles transient Docker daemon issues automatically
- Ensures no orphaned containers or images after testing
- Provides consistent error messages and diagnostics
- Makes tests more reliable and production-ready

## Workflow Overview

### Phase 0: Prerequisites & Skill Analysis

**Validate inputs:**
1. Verify skill exists and has required files (SKILL.md, plugin.json)
2. Parse skill.md to understand what skill does
3. Check for obvious red flags (system commands, destructive operations)
4. Assess skill risk level: low, medium, high

**Risk Assessment Criteria:**
- **Low**: Read-only operations, no system commands, no file writes outside skill directory
- **Medium**: File creation, package installation, bash commands
- **High**: System configuration changes, VM operations, database modifications

**Choose isolation mode:**
- If user specified mode → use that
- If auto-detect → choose based on risk level
- If ambiguous → ask user for confirmation

### Phase 1: Environment Setup

**Mode-specific setup** (see modes/ directory for details):
- Git Worktree: Create worktree, install dependencies
- Docker: Build/pull image, create container with Claude Code
- VM: Provision VM, install Claude Code, take snapshot

**Common verification steps:**
1. Verify environment is functional
2. Check Claude Code is installed and working
3. Copy skill to isolated environment
4. Take "before" snapshot (file listing, process list)

### Phase 2: Skill Execution

**Run skill with test inputs:**
1. Start monitoring (files, processes, network)
2. Execute skill with provided test trigger phrase
3. Capture all output and logs
4. Monitor for errors or warnings
5. Wait for skill completion or timeout

**Test Scenarios:**
- Happy path: Normal execution with valid inputs
- Edge cases: Empty inputs, special characters
- Error handling: Invalid inputs, missing files
- Cleanup: Verify skill removes temporary files

### Phase 3: Validation & Analysis

**Check execution results:**
- [ ] Skill completed without errors
- [ ] No unhandled exceptions or crashes
- [ ] Output matches expected format
- [ ] Execution time within acceptable limits

**Validate side effects:**
- [ ] Compare before/after file listings
- [ ] Check for orphaned processes
- [ ] Verify no unexpected system modifications
- [ ] Ensure temporary files were cleaned up

**Dependency analysis:**
- [ ] List all tools/packages invoked
- [ ] Identify hardcoded paths
- [ ] Flag user-specific configurations
- [ ] Check for missing documentation

### Phase 4: Reporting & Cleanup

**Generate test report:**
```markdown
# Skill Isolation Test Report: [skill-name]

## Environment: [Git Worktree / Docker / VM]
## Status: [PASS / FAIL / WARNING]

### Execution Results
✅ Skill completed successfully
✅ No errors detected
⚠️  Execution took 45s (expected < 30s)

### Side Effects Detected
✅ No orphaned processes
⚠️  3 temporary files not cleaned up:
    - /tmp/skill-temp-12345.log
    - /tmp/skill-cache.json
    - /tmp/.skill-lock

### Dependency Analysis
📦 Required packages:
    - jq (for JSON processing)
    - git (for repository operations)

⚠️  Hardcoded paths detected:
    - /Users/connor/.claude/config (line 45 in script.sh)
    → Recommendation: Use $HOME/.claude/config instead

### Recommendations
1. Add cleanup for temporary files in /tmp
2. Fix hardcoded path on line 45
3. Document jq dependency in README.md

### Overall Grade: B (READY with minor fixes)
```

**Cleanup options:**
1. Ask user: "Keep environment for debugging or cleanup?"
2. If cleanup: Remove worktree/container/VM
3. If keep: Provide access instructions

## Known Issues & Troubleshooting

### Issue: "Skill not found in isolated environment"
**Cause:** Skill wasn't copied correctly
**Fix:** Verify skill path and retry copy operation

### Issue: "Claude Code not responding in container"
**Cause:** Insufficient resources or permissions
**Fix:** Increase container memory limit, check Docker permissions

### Issue: "Timeout waiting for skill completion"
**Cause:** Skill hangs or takes too long
**Fix:** Increase timeout, check skill logs for infinite loops

### Issue: "False positive: System modification detected"
**Cause:** Normal OS background processes
**Fix:** Filter known system processes, retry test

## Safety Protocols

### Before Testing:
- [ ] Verify skill code for obviously malicious operations
- [ ] Choose appropriate isolation level for skill risk
- [ ] Take snapshots/checkpoints for rollback
- [ ] Set resource limits (CPU, memory, disk)
- [ ] Configure timeout for execution

### During Testing:
- [ ] Monitor resource usage
- [ ] Watch for suspicious network activity
- [ ] Check for privilege escalation attempts
- [ ] Abort if destructive operations detected

### After Testing:
- [ ] Review all side effects carefully
- [ ] Cleanup isolated environment (unless debugging)
- [ ] Archive test results for future reference
- [ ] Update skill documentation with findings

## Success Criteria

**Execution Success:**
- [ ] Skill completes without errors
- [ ] All expected outputs generated
- [ ] Execution time acceptable
- [ ] No crashes or unhandled exceptions

**Clean Behavior:**
- [ ] No orphaned processes
- [ ] Temporary files cleaned up
- [ ] No unexpected system modifications
- [ ] No sensitive data leaked

**Portability:**
- [ ] No hardcoded user-specific paths
- [ ] All dependencies documented
- [ ] Works in clean environment
- [ ] No hidden configuration requirements

**Overall Assessment:**
- [ ] Grade: A (Production Ready) / B (Minor Fixes) / C (Significant Issues) / F (Not Ready)

## Reference Materials

See additional documentation in:
- `modes/mode1-git-worktree.md` - Fast isolation using git worktrees
- `modes/mode2-docker.md` - Container-based isolation
- `modes/mode3-vm.md` - Full VM isolation
- `data/risk-assessment.md` - Skill risk evaluation criteria
- `data/side-effect-checklist.md` - What to check for side effects
- `templates/test-report.md` - Test report template
- `examples/test-results/` - Sample test results

## Quick Reference

**Test with auto-detection:**
```bash
# Claude Code will analyze skill and choose environment
test skill my-new-skill in isolation
```

**Test in specific environment:**
```bash
test skill my-new-skill in worktree  # Fast
test skill my-new-skill in docker    # Balanced
test skill my-new-skill in vm        # Safest
```

**Validate specific aspects:**
```bash
check if skill my-new-skill has hidden dependencies
verify skill my-new-skill cleans up after itself
```

---

**Remember:** This skill ensures your skills work for everyone, not just on your machine. Always test in isolation before sharing publicly. When in doubt, use a higher isolation level for safety.
