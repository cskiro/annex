# Changelog

All notable changes to the git-worktree-setup skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-11-01

### Added
- Initial release of git-worktree-setup skill
- Mode 1: Single worktree creation with full environment setup
- Mode 2: Batch worktree creation for multiple branches
- Mode 3: Safe cleanup with uncommitted changes detection
- Mode 4: List and manage existing worktrees
- Automatic prerequisite validation (git repo, uncommitted changes, branch existence, disk space)
- Smart package manager detection (npm/pnpm/yarn/bun)
- Development environment setup automation
- Environment file copying support
- Comprehensive troubleshooting guide
- Best practices documentation
- Sample workflow examples
- Shell script templates for setup automation

### Features
- **Parallel Development**: Work on multiple branches simultaneously
- **Smart Defaults**: Automatic location pattern `../repo-name-branch-name`
- **Safe Operations**: Validation and confirmation before destructive actions
- **Developer Experience**: Clear progress updates and next steps guidance

### Status
- Proof of concept
- Tested locally on 1-2 projects
- Ready for community feedback and testing

[0.1.0]: https://github.com/cskiro/claudex/releases/tag/git-worktree-setup@0.1.0
