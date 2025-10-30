# Migration Guide: Manual to Marketplace Installation

This guide helps you migrate from manual skill installation (copying files) to the new marketplace-based installation system for claudex skills.

## Why Migrate?

**Benefits of Marketplace Installation:**
- ✅ **Automatic updates**: Get new features and bug fixes automatically
- ✅ **Version management**: Pin specific versions for stability
- ✅ **Team synchronization**: Same plugins for everyone via `.claude/settings.json`
- ✅ **Easy discovery**: Browse all available plugins via `/plugin`
- ✅ **Dependency resolution**: Future multi-plugin dependencies handled automatically
- ✅ **Simplified maintenance**: No manual file copying or symlink management

## Migration Steps

### Step 1: Check Current Installation

First, check if you have manually installed skills:

```bash
# Check global skills directory
ls ~/.claude/skills/

# Check project-local skills (in each project)
ls .claude/skills/
```

If these directories contain `codebase-auditor`, `bulletproof-react-auditor`, `claude-md-auditor`, or `cc-insights`, you have manual installations that should be migrated.

### Step 2: Remove Manual Installations

**Global Skills (remove from home directory):**

```bash
# Remove all manually installed claudex skills
rm -rf ~/.claude/skills/codebase-auditor
rm -rf ~/.claude/skills/bulletproof-react-auditor
rm -rf ~/.claude/skills/claude-md-auditor
rm -rf ~/.claude/skills/cc-insights
```

**Project-Local Skills (remove from each project):**

```bash
# In each project directory with manual installations
rm -rf .claude/skills/codebase-auditor
rm -rf .claude/skills/bulletproof-react-auditor
rm -rf .claude/skills/claude-md-auditor
rm -rf .claude/skills/cc-insights

# Optional: Remove the entire skills directory if it's empty
rmdir .claude/skills/ 2>/dev/null || true
```

### Step 3: Add Marketplace

In Claude Code, add the claudex marketplace:

```bash
/plugin marketplace add cskiro/claudex
```

You should see confirmation that the marketplace was added successfully.

### Step 4: Install Skills via Marketplace

**Option A: Browse and Install Interactively**

```bash
# Open the plugin browser
/plugin

# Select skills to install from the claudex marketplace
# Follow the interactive prompts
```

**Option B: Install Directly**

```bash
# Install specific skills
/plugin install codebase-auditor@claudex
/plugin install bulletproof-react-auditor@claudex
/plugin install claude-md-auditor@claudex
/plugin install cc-insights@claudex
```

**Option C: Install All at Once (Recommended)**

```bash
/plugin install codebase-auditor@claudex bulletproof-react-auditor@claudex claude-md-auditor@claudex cc-insights@claudex
```

### Step 5: Verify Installation

Test that your skills are working:

```bash
# In Claude Code, try invoking a skill
# For example: "Audit this codebase"
# Or: "Search my conversations about testing"
```

If the skill responds correctly, your migration is complete!

### Step 6: Configure Team Auto-Install (Optional)

For projects where you want all team members to have the same skills, add this to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "claudex": {
      "source": {
        "source": "github",
        "repo": "cskiro/claudex"
      }
    }
  },
  "enabledPlugins": [
    "codebase-auditor@claudex",
    "bulletproof-react-auditor@claudex",
    "claude-md-auditor@claudex",
    "cc-insights@claudex"
  ]
}
```

**How it works:**
1. Commit `.claude/settings.json` to your repository
2. When team members clone/pull and trust the repository folder
3. Claude Code automatically installs the marketplace and plugins
4. Everyone has the same skills with zero manual setup

## Troubleshooting

### Issue: Skills not showing up after installation

**Solution:**
```bash
# Refresh marketplace metadata
/plugin marketplace update claudex

# Verify installation
/plugin list
```

### Issue: Old manual skills still responding

**Solution:**
Claude Code checks `.claude/skills/` before marketplace plugins. Ensure you've removed all manual installations:

```bash
# Double-check removal
ls -la ~/.claude/skills/
ls -la .claude/skills/

# Remove any remaining skills
rm -rf ~/.claude/skills/codebase-auditor
rm -rf .claude/skills/codebase-auditor
```

Then restart Claude Code if necessary.

### Issue: Marketplace not found

**Solution:**
Ensure you're using the correct syntax:

```bash
# Correct format
/plugin marketplace add cskiro/claudex

# If using SSH authentication
/plugin marketplace add git@github.com:cskiro/claudex.git
```

### Issue: cc-insights dependencies missing

**Solution:**
The cc-insights skill requires Python dependencies. Install them manually:

```bash
# Navigate to the installed plugin directory
cd ~/.claude/plugins/cc-insights@claudex/

# Install Python requirements
pip3 install -r requirements.txt
```

Or use the automatic installation script (coming in future release):
```bash
/plugin install cc-insights@claudex --install-deps
```

## Rollback (If Needed)

If you need to temporarily roll back to manual installation:

```bash
# Remove marketplace plugins
/plugin uninstall codebase-auditor@claudex
/plugin marketplace remove claudex

# Reinstall manually (legacy method)
git clone https://github.com/cskiro/claudex.git
cp -r claudex/codebase-auditor ~/.claude/skills/
```

**Note**: We strongly recommend using the marketplace system. Manual installation is deprecated and may not be supported in future Claude Code versions.

## Version Pinning (Advanced)

For production environments, you may want to pin specific versions:

```json
{
  "enabledPlugins": [
    "codebase-auditor@claudex@1.0.0-beta",
    "cc-insights@claudex@2.0.0-beta"
  ]
}
```

**Benefits:**
- Prevents unexpected changes from auto-updates
- Ensures reproducible builds in CI/CD
- Allows gradual rollout of new versions

**Drawbacks:**
- Must manually update to get bug fixes
- Can miss important security updates

**Recommendation**: Pin versions in production, use latest in development.

## FAQ

### Q: Will my existing skill data be lost?

**A**: No. Skills use standard directories for generated data:
- Audit reports are saved to your project directories
- cc-insights data is in `~/.cc-insights/`
- CLAUDE.md auditor doesn't persist data

Your data remains intact after migration.

### Q: Can I use both manual and marketplace installation?

**A**: Not recommended. Claude Code prioritizes `.claude/skills/` over marketplace plugins, which can cause confusion about which version is active. Choose one method.

### Q: How do I update plugins after migration?

**A**: Marketplace plugins update automatically by default. You can also manually trigger updates:

```bash
# Update all plugins
/plugin update

# Update specific marketplace
/plugin marketplace update claudex
```

### Q: What if I have local modifications to a skill?

**A**: Marketplace plugins overwrite local changes. If you've customized a skill:

1. Fork the claudex repository
2. Add your fork as a separate marketplace
3. Maintain your custom version there

Or continue using manual installation for that specific skill.

### Q: Do I need internet access for marketplace plugins?

**A**: Yes, for initial installation and updates. Once installed, skills work offline (except cc-insights web search features).

## Support

If you encounter issues during migration:

1. Check this guide's [Troubleshooting](#troubleshooting) section
2. Review the [main README](../README.md) for updated instructions
3. Open an issue: [github.com/cskiro/claudex/issues](https://github.com/cskiro/claudex/issues)

## Migration Checklist

Use this checklist to track your migration:

- [ ] Checked for existing manual installations (global and project-local)
- [ ] Removed all manual skill installations from `~/.claude/skills/`
- [ ] Removed all manual skill installations from project `.claude/skills/`
- [ ] Added claudex marketplace: `/plugin marketplace add cskiro/claudex`
- [ ] Installed required skills via `/plugin install`
- [ ] Verified skills work by testing invocation
- [ ] (Optional) Added team configuration to `.claude/settings.json`
- [ ] (Optional) Committed `.claude/settings.json` to repository
- [ ] Informed team members about the migration

---

**Need help?** Open an issue at [github.com/cskiro/claudex/issues](https://github.com/cskiro/claudex/issues) with the "migration" label.
