# Changelog

All notable changes to the Semantic Release Tagger skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-11-16

### Added
- **Initial marketplace release** - Automated git tagging agent for semantic versioning
- **Phase 0: Auto-Context Analysis** - Automatically analyzes repository state
  - Detects existing tag conventions (@ vs / vs flat)
  - Identifies monorepo components
  - Parses latest versions per component
  - Analyzes commits since last tag
  - Classifies changes using conventional commits
  - Calculates recommended next version

- **Intelligent Version Calculation** - Parse conventional commits for automatic version bumps
  - Detects `feat:`, `fix:`, `chore:`, `BREAKING CHANGE:` commit prefixes
  - Auto-determines MAJOR/MINOR/PATCH version bumps
  - Groups commits by type for changelog generation

- **Automated Tag Creation** - Execute git commands after user confirmation
  - Pre-flight validation checks
  - Shows exact commands before execution
  - Atomic tag creation and push workflow
  - Comprehensive error handling and rollback

- **GitHub Release Integration** - One-command release publishing
  - Auto-generated changelogs from conventional commits
  - Smart pre-release detection (versions < 1.0.0)
  - GitHub CLI (`gh`) integration
  - Commit grouping by type (features/fixes/maintenance)

- **Monorepo Support** - Component-specific versioning
  - Namespace detection and consistency auditing
  - Support for slash-based (`component/vX.Y.Z`) and npm-style (`component@X.Y.Z`) conventions
  - Tag filtering and maintenance patterns

### Features
- 5-phase automated workflow (Analysis → Convention → Version → Tag → Release)
- Interactive confirmation before execution
- Comprehensive troubleshooting guide
- Real-world examples and usage scenarios
- Based on 7 production insights from version-control workflows

### Documentation
- Complete SKILL.md with detailed workflow phases
- README.md with quick start guide
- data/insights-reference.md with source insights
- examples/tag-examples.md with 8 real-world scenarios

[0.1.0]: https://github.com/cskiro/claudex/releases/tag/semantic-release-tagger@0.1.0
