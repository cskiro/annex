# Changelog

All notable changes to the github-repo-setup skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2025-11-07

### Added
- Initial release of github-repo-setup skill
- Four distinct modes for different use cases:
  - Quick Mode: Fast setup with essentials (~30s)
  - Enterprise Mode: Production-ready with full security and CI/CD (~120s)
  - Open Source Mode: Community-focused with health files (~90s)
  - Private/Team Mode: Internal collaboration with governance (~90s)
- Comprehensive security features following GitHub best practices:
  - Dependabot alerts and automated security fixes
  - Secret scanning with push protection
  - Code scanning with CodeQL (enterprise mode)
  - SECURITY.md vulnerability reporting
- Complete documentation structure:
  - README.md with project information and badges
  - LICENSE file selection and generation
  - Technology-specific .gitignore files
  - Community health files (CODE_OF_CONDUCT, CONTRIBUTING, SUPPORT)
- CI/CD workflow automation:
  - GitHub Actions workflow generation
  - Automated testing and linting
  - Security scanning integration
  - Deployment pipeline templates
- Issue and PR management:
  - Issue templates using GitHub form schema
  - Pull request templates with checklists
  - CODEOWNERS configuration for review requirements
  - Branch protection with required status checks
- Repository governance:
  - Branch protection rules configuration
  - Team access control setup
  - Review requirement configuration
  - Governance documentation (team mode)
- Prerequisites validation:
  - GitHub CLI installation check
  - Authentication status verification
  - Git configuration validation
  - Permission checks
- Intelligent mode detection from natural language requests
- Comprehensive validation and setup reporting

### Features
- Automated repository creation via GitHub CLI
- Security-first approach with default protections
- Official GitHub best practices implementation
- Modern CI/CD workflow templates (2024-2025)
- Community standards compliance
- Enterprise-grade governance options
- Flexible customization after initial setup

### Documentation
- Comprehensive SKILL.md with 8-phase workflow
- README.md with usage examples and troubleshooting
- Mode-specific documentation files
- Template library for common configurations
- Data files with security and community standards

### Validation
- ✅ Follows GitHub official best practices
- ✅ Security features properly configured
- ✅ Documentation standards met
- ✅ CI/CD workflows functional
- ✅ Branch protection active where appropriate

## Future Enhancements

### Planned Features
- Repository migration mode (existing → standards-compliant)
- Multi-repository batch setup
- Organization-wide defaults configuration
- Advanced CI/CD templates (deployment strategies)
- Integration with project management tools
- Custom workflow generator
- Repository health scoring and recommendations

### Planned Improvements
- Interactive repository settings adjustment
- Template customization wizard
- Automated security audit reports
- Team onboarding automation
- Repository analytics and insights

---

**Note:** This skill follows GitHub's official documentation and implements industry best practices as of 2024-2025.

[Unreleased]: https://github.com/cskiro/claudex/compare/github-repo-setup@0.1.0...HEAD
[0.1.0]: https://github.com/cskiro/claudex/releases/tag/github-repo-setup@0.1.0
