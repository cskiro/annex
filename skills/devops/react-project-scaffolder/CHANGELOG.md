# Changelog

All notable changes to the React Project Scaffolder skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-11-02

### Added
- Initial release of React Project Scaffolder skill
- Three distinct project modes:
  - Sandbox Mode: Vite + React + TypeScript (minimal, fast setup)
  - Enterprise Mode: Next.js + full tooling (production-ready)
  - Mobile Mode: Expo + React Native (cross-platform)
- Connor's development standards integrated:
  - TypeScript strict mode
  - Testing Trophy approach
  - 80% test coverage threshold
  - Pre-commit hooks (Husky + lint-staged)
  - Conventional commits
- Smart mode detection from natural language
- Hybrid configuration approach (automated for sandbox, minimal questions for enterprise/mobile)
- Comprehensive documentation for each mode
- Environment validation script
- Template files for key configurations
- Dependencies reference (data/dependencies.yaml)
- Example project outputs

### Features
- **Sandbox Mode** (~15s setup):
  - Vite for ultra-fast dev server
  - React 18+ with TypeScript strict mode
  - ESLint + Prettier (minimal config)
  - Git initialization

- **Enterprise Mode** (~60s setup):
  - Next.js 14+ with App Router
  - Vitest + React Testing Library
  - 80% coverage threshold
  - ESLint + Prettier + Husky
  - GitHub Actions CI/CD
  - Testing Trophy approach
  - Comprehensive documentation

- **Mobile Mode** (~60s setup):
  - Expo SDK 50+ with managed workflow
  - Expo Router for navigation
  - Jest + React Native Testing Library
  - 80% coverage threshold
  - ESLint + Prettier + Husky
  - Optional EAS Build & Submit setup
  - Comprehensive documentation

### Documentation
- Detailed SKILL.md with mode-based workflow
- Mode-specific guides (modes/ directory)
- Complete README with usage examples
- Configuration templates for each mode
- Troubleshooting guides

### Standards
- TypeScript strict mode (all flags enabled)
- No `console.log` in production code
- No `any` types allowed
- Semantic commit messages
- Branch naming conventions
- 80% test coverage minimum

### Tools Integration
- **Testing**: Vitest (enterprise), Jest (mobile)
- **Linting**: ESLint with strict rules
- **Formatting**: Prettier
- **Pre-commit**: Husky + lint-staged
- **CI/CD**: GitHub Actions (enterprise)
- **Build**: EAS (mobile, optional)

## [Unreleased]

### Planned
- Template customization options
- Additional project templates (e.g., component libraries)
- E2E testing setup options (Playwright, Cypress)
- Docker configuration templates
- Deployment guides for various platforms
- Monorepo support (Turborepo, Nx)
- State management templates (Zustand, Redux Toolkit)
- Styling options (Tailwind, Styled Components, CSS Modules)
- Database integration templates (Prisma, Drizzle)
- Authentication templates (NextAuth, Clerk)

---

For more information, see the [README](README.md) and [SKILL.md](SKILL.md).
