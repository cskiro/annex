---
name: react-project-scaffolder
description: Automated React project scaffolding with three modes - simple sandbox for testing, enterprise-grade with modern tooling, and mobile React with production best practices
version: 0.1.0
author: Connor
tags:
  - react
  - scaffolding
  - project-setup
  - automation
  - tooling
  - vite
  - nextjs
  - expo
  - typescript
category: productivity
location: user
---

# React Project Scaffolder

## Overview

This skill automates the creation of React projects with three distinct modes tailored to different use cases. Each mode provides a complete, production-ready project structure with modern tooling and best practices. The skill uses a hybrid approach combining automated setup with smart configuration prompts to balance speed with customization.

**Three Modes:**
1. **Sandbox Mode** - Lightning-fast Vite + React + TypeScript setup for quick experiments
2. **Enterprise Mode** - Production-ready Next.js with comprehensive tooling (testing, linting, CI/CD)
3. **Mobile Mode** - Cross-platform React Native with Expo and enterprise standards

All modes follow Connor's development standards: TypeScript strict mode, Testing Trophy approach, 80% coverage targets, and conventional commits.

## When to Use This Skill

**Trigger Phrases:**
- "create a React project"
- "scaffold a new React app"
- "set up a React sandbox"
- "create an enterprise React project"
- "build a mobile React app"
- "initialize a React Native project"
- "quick React setup for testing"
- "start a production React project"

**Use Cases:**
- Spinning up quick React experiments without framework overhead
- Starting new enterprise web applications with industry-standard tooling
- Creating cross-platform mobile apps with React Native
- Prototyping features in isolated sandbox environments
- Establishing consistent project structure across teams
- Learning React with minimal configuration overhead

## Response Style

- **Efficient**: Minimize questions, maximize automation
- **Guided**: Provide clear mode selection with pros/cons
- **Standards-driven**: Apply Connor's development standards automatically
- **Transparent**: Explain what's being set up and why
- **Educational**: Brief explanations of tooling choices

## Quick Decision Matrix

```
User Request                          → Mode          → Framework    → Setup Time
─────────────────────────────────────────────────────────────────────────────────
"quick React test"                    → Sandbox       → Vite         → ~15s
"React sandbox"                       → Sandbox       → Vite         → ~15s
"experiment with React"               → Sandbox       → Vite         → ~15s

"production React app"                → Enterprise    → Next.js      → ~60s
"enterprise React project"            → Enterprise    → Next.js      → ~60s
"React app with testing"              → Enterprise    → Next.js      → ~60s

"mobile app"                          → Mobile        → Expo         → ~60s
"React Native project"                → Mobile        → Expo         → ~60s
"cross-platform app"                  → Mobile        → Expo         → ~60s
```

## Mode Detection Logic

```javascript
// Mode 1: Sandbox (Vite + React + TypeScript)
if (userMentions("sandbox", "quick", "test", "experiment", "prototype")) {
  return "sandbox-mode";
}

// Mode 2: Enterprise (Next.js + Full Tooling)
if (userMentions("enterprise", "production", "full", "complete", "testing")) {
  return "enterprise-mode";
}

// Mode 3: Mobile (Expo + React Native)
if (userMentions("mobile", "native", "ios", "android", "expo")) {
  return "mobile-mode";
}

// Ambiguous - ask user
return askForModeSelection();
```

## Core Responsibilities

### 1. Mode Selection & Validation
- ✓ Detect user intent from natural language
- ✓ Present clear mode options with trade-offs
- ✓ Validate prerequisites (Node.js version, npm/yarn)
- ✓ Check for naming conflicts in target directory

### 2. Project Scaffolding
- ✓ Create complete directory structure
- ✓ Generate configuration files from templates
- ✓ Set up TypeScript with strict mode
- ✓ Configure linting and formatting tools
- ✓ Initialize git repository with proper .gitignore

### 3. Dependency Management
- ✓ Install appropriate dependencies for each mode
- ✓ Use latest stable versions
- ✓ Configure package.json scripts
- ✓ Set up pre-commit hooks (enterprise/mobile)

### 4. Testing Infrastructure
- ✓ Configure Vitest + React Testing Library (enterprise)
- ✓ Configure Jest + RN Testing Library (mobile)
- ✓ Set up Testing Trophy architecture
- ✓ Create example test files
- ✓ Configure coverage thresholds (80%)

### 5. CI/CD Setup
- ✓ Generate GitHub Actions workflows (enterprise/mobile)
- ✓ Configure automated testing on PR
- ✓ Set up build validation
- ✓ Configure deployment pipelines (optional)

### 6. Documentation & Next Steps
- ✓ Generate project README with commands
- ✓ Provide development workflow guide
- ✓ Explain project structure
- ✓ List next steps for customization

## Workflow

### Phase 1: Mode Selection & Prerequisites

**Purpose**: Understand user needs and validate environment

**Steps:**
1. Detect mode from user request using Mode Detection Logic
2. If ambiguous, ask: "Which type of React project?"
   - Sandbox: Quick experiments, minimal setup
   - Enterprise: Production web apps, full tooling
   - Mobile: Cross-platform iOS/Android apps
3. Validate prerequisites:
   ```bash
   node --version  # Require >= 18.x
   npm --version   # Require >= 9.x
   ```
4. Ask for project name and validate:
   - Valid directory name (no spaces, lowercase recommended)
   - Check if directory already exists
   - Suggest alternatives if conflict

**Output**: Selected mode, validated environment, project name

**Transition**: Move to mode-specific workflow

---

### Mode 1: Sandbox (Vite + React + TypeScript)

**Purpose**: Lightning-fast React setup for experiments and learning

**Tech Stack:**
- Vite 5+ (fastest dev server, HMR in <50ms)
- React 18+
- TypeScript (strict mode)
- ESLint + Prettier (minimal config)

**Configuration Strategy**: Fully automated, zero questions

#### Workflow Steps:

1. **Scaffold with Vite**
   ```bash
   npm create vite@latest {project-name} -- --template react-ts
   cd {project-name}
   ```

2. **Configure TypeScript Strict Mode**
   - Update tsconfig.json with Connor's strict settings
   - Enable all strict flags
   - Configure path aliases

3. **Set Up Linting**
   - Install ESLint + Prettier
   - Apply minimal config (no overkill for sandbox)
   - Add format script to package.json

4. **Initialize Git**
   ```bash
   git init
   git add .
   git commit -m "feat: initial Vite + React + TypeScript setup"
   ```

5. **Provide Next Steps**
   ```markdown
   ## Your Sandbox is Ready!

   Start development:
     cd {project-name}
     npm install
     npm run dev

   Project structure:
     src/
       ├── App.tsx          # Main component
       ├── main.tsx         # Entry point
       └── vite-env.d.ts    # Vite types

   Available commands:
     npm run dev          # Start dev server (http://localhost:5173)
     npm run build        # Build for production
     npm run preview      # Preview production build
     npm run lint         # Check code quality
   ```

**Time to First Render**: ~15 seconds after `npm install`

---

### Mode 2: Enterprise (Next.js + Full Tooling)

**Purpose**: Production-ready web applications with industry-standard tooling

**Tech Stack:**
- Next.js 14+ (App Router)
- React 18+
- TypeScript (strict mode)
- Vitest + React Testing Library
- ESLint + Prettier + Husky
- GitHub Actions CI/CD
- Conventional Commits

**Configuration Strategy**: 2-3 key questions, smart defaults

#### Workflow Steps:

1. **Ask Configuration Questions**
   - "Include testing setup?" (default: yes)
   - "Include CI/CD workflows?" (default: yes)
   - "Use src/ directory?" (default: yes)

2. **Scaffold with Next.js**
   ```bash
   npx create-next-app@latest {project-name} \
     --typescript \
     --eslint \
     --app \
     --src-dir \
     --import-alias "@/*"
   cd {project-name}
   ```

3. **Apply Connor's TypeScript Standards**
   - Update tsconfig.json with strict mode
   - Configure path aliases
   - Enable all type checking flags

4. **Set Up Testing (if selected)**
   - Install Vitest, React Testing Library, jsdom
   - Create vitest.config.ts with coverage settings (80% threshold)
   - Add example test: `__tests__/page.test.tsx`
   - Configure Testing Trophy approach
   - Add test scripts to package.json:
     ```json
     "test": "vitest --run",
     "test:watch": "vitest",
     "test:coverage": "vitest --coverage",
     "test:low": "vitest --maxWorkers=2"
     ```

5. **Configure Linting & Formatting**
   - Extend ESLint config with strict rules
   - Add Prettier with Connor's preferences
   - Install and configure Husky + lint-staged
   - Set up pre-commit hook for:
     - Linting
     - Format checking
     - Type checking
     - Test running (on relevant files)

6. **Set Up CI/CD (if selected)**
   - Create `.github/workflows/ci.yml`
   - Configure on PR triggers
   - Steps: install → lint → type-check → test → build
   - Add status badge to README

7. **Initialize Git with Standards**
   ```bash
   git init
   git add .
   git commit -m "feat: initial Next.js enterprise setup with testing and CI/CD"
   ```

8. **Generate Documentation**
   - Update README with:
     - Project overview
     - Development commands
     - Testing approach (Testing Trophy)
     - Project structure
     - Deployment guide
   - Create CONTRIBUTING.md with standards

9. **Provide Next Steps**
   ```markdown
   ## Your Enterprise React Project is Ready!

   Start development:
     cd {project-name}
     npm install
     npm run dev

   Project structure:
     src/
       ├── app/              # Next.js App Router
       │   ├── page.tsx      # Home page
       │   └── layout.tsx    # Root layout
       ├── components/       # React components
       ├── lib/              # Utility functions
       └── __tests__/        # Test files

   Available commands:
     npm run dev              # Start dev server (http://localhost:3000)
     npm run build            # Production build
     npm run start            # Start production server
     npm run lint             # Lint code
     npm run test             # Run tests (low CPU)
     npm run test:coverage    # Run tests with coverage

   Configured features:
     ✓ TypeScript strict mode
     ✓ Testing Trophy approach (Vitest + RTL)
     ✓ ESLint + Prettier + Husky
     ✓ GitHub Actions CI/CD
     ✓ 80% coverage threshold
     ✓ Pre-commit hooks

   Next steps:
     1. Review tsconfig.json for TypeScript settings
     2. Check .github/workflows/ci.yml for CI configuration
     3. Read __tests__/page.test.tsx for testing examples
     4. Start building in src/app/
   ```

**Time to First Render**: ~60 seconds after `npm install`

---

### Mode 3: Mobile (Expo + React Native)

**Purpose**: Cross-platform mobile apps with production-ready tooling

**Tech Stack:**
- Expo SDK 50+ (managed workflow)
- React Native (latest stable)
- TypeScript (strict mode)
- Jest + React Native Testing Library
- ESLint + Prettier + Husky
- EAS Build & Submit (optional)

**Configuration Strategy**: 2-3 key questions, smart defaults

#### Workflow Steps:

1. **Ask Configuration Questions**
   - "Include Expo Router?" (default: yes - for navigation)
   - "Include testing setup?" (default: yes)
   - "Set up EAS for cloud builds?" (default: no - can add later)

2. **Scaffold with Expo**
   ```bash
   npx create-expo-app@latest {project-name} --template
   # Select "Blank (TypeScript)" template
   cd {project-name}
   ```

3. **Configure TypeScript Strict Mode**
   - Update tsconfig.json with Connor's strict settings
   - Configure path aliases
   - Enable all type checking

4. **Install Expo Router (if selected)**
   ```bash
   npx expo install expo-router react-native-safe-area-context react-native-screens
   ```
   - Configure app.json for Expo Router
   - Set up app/ directory structure
   - Create example routes

5. **Set Up Testing (if selected)**
   - Install Jest, React Native Testing Library
   - Configure jest.config.js for React Native
   - Add example test: `__tests__/App.test.tsx`
   - Set 80% coverage threshold
   - Add test scripts to package.json

6. **Configure Linting & Formatting**
   - Extend ESLint with React Native rules
   - Add Prettier with mobile-friendly config
   - Install and configure Husky + lint-staged
   - Set up pre-commit hooks

7. **Optional: EAS Configuration (if selected)**
   ```bash
   npm install -g eas-cli
   eas build:configure
   ```
   - Set up eas.json for iOS/Android builds
   - Configure build profiles (development, preview, production)

8. **Initialize Git**
   ```bash
   git init
   git add .
   git commit -m "feat: initial Expo + React Native setup with testing"
   ```

9. **Generate Documentation**
   - Update README with:
     - Project overview
     - Development commands
     - Testing approach
     - Build & deployment guide (with/without EAS)
   - Document Expo Router setup (if used)

10. **Provide Next Steps**
    ```markdown
    ## Your Mobile React Project is Ready!

    Start development:
      cd {project-name}
      npm install
      npm start

    Project structure:
      app/                   # Expo Router (if enabled)
        ├── (tabs)/          # Tab navigation
        └── _layout.tsx      # Root layout
      components/            # React components
      __tests__/             # Test files
      assets/                # Images, fonts

    Available commands:
      npm start              # Start Expo dev server
      npm run android        # Run on Android emulator
      npm run ios            # Run on iOS simulator
      npm run test           # Run tests
      npm run lint           # Lint code

    Configured features:
      ✓ TypeScript strict mode
      ✓ Expo Router navigation (if selected)
      ✓ Jest + React Native Testing Library
      ✓ ESLint + Prettier + Husky
      ✓ 80% coverage threshold
      ✓ Pre-commit hooks

    Next steps:
      1. Install Expo Go app on your phone
      2. Scan QR code to preview on device
      3. Read __tests__/App.test.tsx for testing examples
      4. Start building in app/ (or App.tsx if no router)
      5. Review Expo docs: https://docs.expo.dev

    Build for production (if EAS configured):
      eas build --platform all
      eas submit --platform all
    ```

**Time to First Render**: ~60 seconds after `npm install`

---

## Error Handling

### Common Issues & Solutions

**Node.js version too old**
```
Error: Node.js 18+ required, found 16.x
Solution: Update Node.js to LTS version (18+)
Command: Use nvm: nvm install 18 && nvm use 18
```

**Directory already exists**
```
Error: Directory "{project-name}" already exists
Solution: Choose a different name or delete existing directory
Offer: "Would you like me to suggest alternatives?"
```

**npm install fails**
```
Error: npm install failed with code 1
Solution: Check network connection, try clearing npm cache
Command: npm cache clean --force && npm install
```

**Husky pre-commit hook fails**
```
Error: Pre-commit hook failed (lint errors)
Solution: Fix linting errors before committing
Command: npm run lint -- --fix
```

**Port already in use (dev server)**
```
Error: Port 3000 already in use
Solution: Kill process on port or use different port
Command: lsof -ti:3000 | xargs kill (or set PORT env var)
```

**TypeScript errors in strict mode**
```
Error: Type errors in generated code
Solution: This shouldn't happen - report as bug
Workaround: Temporarily disable strict flags in tsconfig.json
```

### Recovery Strategies

1. **Partial failure**: If setup partially completes, offer to:
   - Resume from failed step
   - Start over with cleanup
   - Manual fix guidance

2. **Permission errors**: Check write permissions and suggest:
   - Running without sudo (security)
   - Changing target directory

3. **Network timeouts**: Retry with exponential backoff, suggest:
   - Check network connection
   - Use different npm registry
   - Use yarn instead of npm

## Success Criteria

**For All Modes:**
- [ ] Project directory created successfully
- [ ] All configuration files generated
- [ ] TypeScript strict mode enabled
- [ ] ESLint + Prettier configured
- [ ] Git initialized with proper .gitignore
- [ ] package.json has all required scripts
- [ ] README generated with commands
- [ ] `npm install` completes successfully
- [ ] Dev server starts without errors

**For Enterprise Mode:**
- [ ] Next.js project scaffolded with App Router
- [ ] Vitest + RTL configured
- [ ] Example test passes
- [ ] Coverage threshold set to 80%
- [ ] Husky pre-commit hooks working
- [ ] GitHub Actions workflow created
- [ ] Testing Trophy approach documented

**For Mobile Mode:**
- [ ] Expo project scaffolded
- [ ] Expo Router configured (if selected)
- [ ] Jest + RN Testing Library configured
- [ ] Example test passes
- [ ] Expo dev server starts
- [ ] QR code displayed for device testing
- [ ] EAS configured (if selected)

## Reference Materials

### Mode Definitions
- `modes/sandbox-mode.md` - Vite + React sandbox setup
- `modes/enterprise-mode.md` - Next.js enterprise setup
- `modes/mobile-mode.md` - Expo mobile setup

### Templates
- `templates/sandbox/` - Vite configuration templates
- `templates/enterprise/` - Next.js configuration templates
- `templates/mobile/` - Expo configuration templates

### Scripts
- `scripts/scaffold-sandbox.sh` - Automated sandbox setup
- `scripts/scaffold-enterprise.sh` - Automated enterprise setup
- `scripts/scaffold-mobile.sh` - Automated mobile setup
- `scripts/validate-environment.sh` - Prerequisites validation

### Data
- `data/dependencies.yaml` - Package versions and dependencies
- `data/templates.yaml` - Configuration file templates

### Examples
- `examples/sandbox-output/` - Sample sandbox project
- `examples/enterprise-output/` - Sample enterprise project
- `examples/mobile-output/` - Sample mobile project

---

## Important Reminders

1. **Always validate environment first** - Check Node.js, npm versions before scaffolding
2. **Explain choices clearly** - User should understand why each tool is included
3. **Follow Connor's standards** - TypeScript strict, Testing Trophy, 80% coverage
4. **Use latest stable versions** - But document which versions are used
5. **Test the scaffolded project** - Verify dev server starts and tests pass
6. **Provide clear next steps** - User should know exactly what to do next
7. **Keep it fast** - Sandbox should be <15s, others <60s after npm install
8. **No console.log in generated code** - Follow Connor's no-console rule
9. **Git from the start** - Initialize repo with proper commit message
10. **Document everything** - README should be comprehensive

## Quick Reference Commands

**Check environment:**
```bash
node --version && npm --version
```

**Create sandbox (manual):**
```bash
npm create vite@latest my-app -- --template react-ts
```

**Create enterprise (manual):**
```bash
npx create-next-app@latest my-app --typescript --eslint --app --src-dir
```

**Create mobile (manual):**
```bash
npx create-expo-app@latest my-app --template blank-typescript
```

**Verify generated project:**
```bash
cd {project-name}
npm install
npm run dev  # or npm start for Expo
npm run test # verify tests pass
```

---

**Remember**: This skill prioritizes speed and standards. Sandbox mode is instant (no questions), while enterprise and mobile modes ask only essential questions. All modes produce production-ready projects that follow Connor's development philosophy: strong opinions, loosely held, with testing and quality built in from day one.
