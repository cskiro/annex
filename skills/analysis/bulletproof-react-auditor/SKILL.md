---
name: bulletproof-react-auditor
description: Comprehensive audit tool that analyzes React/TypeScript codebases against Bulletproof React architecture principles, detects structural anti-patterns, component design issues, and generates prioritized migration plans for adopting production-ready React patterns. Use this skill when auditing React applications, planning architecture refactors, evaluating project structure, or migrating to Bulletproof React patterns.
---

# Bulletproof React Auditor

Perform comprehensive React/TypeScript codebase audits against Bulletproof React architecture principles, detecting structural issues, component anti-patterns, and state management problems while generating actionable migration plans.

## When to Use This Skill

Activate this skill when you need to:
- Audit a React codebase against Bulletproof React standards
- Evaluate project structure and architecture alignment
- Assess component design and organization patterns
- Plan migration from flat to feature-based architecture
- Generate step-by-step refactoring guidance
- Identify React-specific anti-patterns and tech debt
- Prepare architecture decision records (ADRs)

## Audit Scope

### Phase 1: React Project Discovery

Start with lightweight scan to understand the React application:

1. **Project Detection**
   - Identify React version and framework (CRA, Vite, Next.js)
   - Detect TypeScript vs JavaScript
   - Identify state management tools (Context, Redux, Zustand, Jotai, MobX)
   - Detect data fetching libraries (React Query, SWR, Apollo, RTK Query)
   - Identify styling approach (Tailwind, CSS Modules, Styled Components, Emotion)
   - Detect component libraries (Chakra, MUI, Ant Design, Radix UI)
   - Map testing framework (Vitest, Jest, Testing Library, Playwright)

2. **Structure Analysis**
   - Current folder organization pattern
   - Feature-based vs flat structure detection
   - Component organization strategy
   - Shared vs feature-specific code boundaries

### Phase 2: Deep Bulletproof Analysis

Based on Phase 1, perform targeted analysis against Bulletproof React principles:

#### 2.1 Project Structure Compliance

**Bulletproof Folder Pattern:**
```
src/
├── app/           # Application layer (routes, app.tsx, provider.tsx)
├── assets/        # Static files
├── components/    # Shared components ONLY
├── config/        # Global configurations
├── features/      # Feature modules (most code here)
│   └── feature-name/
│       ├── api/
│       ├── components/
│       ├── hooks/
│       ├── stores/
│       ├── types/
│       └── utils/
├── hooks/         # Shared hooks
├── lib/           # Third-party library configs
├── stores/        # Global state stores
├── testing/       # Test utilities
├── types/         # Shared TypeScript types
└── utils/         # Shared utility functions
```

**Architectural Violations:**
- Cross-feature imports (features importing from other features)
- Shared components that should be feature-specific
- Missing feature boundaries
- Circular dependencies
- God components in shared/
- Business logic in components/ instead of features/

#### 2.2 Component Architecture Analysis

**Component Design Principles:**
- **Colocation**: Components near where they're used
- **Composition**: Limited props (< 7-10), uses composition patterns
- **Size**: No large components (< 300 LOC), no nested render functions
- **Consistency**: Consistent naming and organization
- **Abstraction**: No premature abstractions, identify repetition first

**Anti-Patterns to Detect:**
- Large components with multiple responsibilities
- Nested render functions instead of extracted components
- Components with excessive props (> 10)
- Shared components used in only one place
- Missing component library wrappers
- Inconsistent file naming (not kebab-case)

#### 2.3 State Management Audit

**State Categories:**
1. **Component State**: Local useState/useReducer
2. **Application State**: Context, Redux, Zustand, Jotai, MobX
3. **Server Cache State**: React Query, SWR, Apollo Client
4. **Form State**: React Hook Form, Formik
5. **URL State**: React Router, Next.js router

**State Management Issues:**
- State too high in component tree (should be localized)
- Everything in single global state (causes unnecessary re-renders)
- Mixing server cache with client state
- No data fetching library for API calls
- Forms without proper state management

#### 2.4 API Layer Architecture

**Bulletproof API Pattern:**
- Single configured API client instance
- Type-safe request declarations
- Colocated in feature folders
- Custom hooks for each endpoint
- Validation schemas with types
- Proper error handling

**API Layer Violations:**
- Scattered fetch calls throughout components
- No centralized API client
- Missing TypeScript types for requests/responses
- API calls without error handling
- No data fetching library (React Query/SWR)
- Missing request validation

#### 2.5 Testing Strategy Compliance

**Testing Trophy Distribution (Target):**
- Integration tests: 70%
- Unit tests: 20%
- E2E tests: 10%

**Test Quality Criteria:**
- Tests named "should X when Y"
- Use semantic queries (getByRole, getByLabelText)
- Test user behavior, not implementation
- No brittle tests (testing emoji, element counts, ordering)
- Tests isolated and independent
- No flaky tests

**Testing Violations:**
- Wrong pyramid (more unit than integration)
- Testing implementation details
- Using getByTestId instead of semantic queries
- Testing exact DOM structure
- Missing edge case coverage
- Low coverage (< 80%) on critical paths

#### 2.6 Styling Patterns Analysis

**Recommended Approaches:**
- Component libraries: Chakra UI, Radix UI, Headless UI, MUI
- Utility CSS: Tailwind, Panda CSS
- CSS-in-JS: Emotion, Vanilla Extract
- CSS Modules for custom styling

**Styling Issues:**
- Inconsistent styling approach (mixed patterns)
- Large style files not colocated
- No design system or component library
- Inline styles overused
- Missing CSS reset/normalize

#### 2.7 Error Handling Audit

**Bulletproof Error Handling:**
- API error interceptors with notifications
- Multiple error boundaries at strategic locations
- Error tracking service (Sentry, LogRocket)
- User-friendly error messages
- Proper error logging

**Error Handling Gaps:**
- No error boundaries
- Single top-level error boundary (too coarse)
- Missing API error interceptors
- No error tracking service
- console.log instead of proper logging

#### 2.8 Performance Patterns

**React Performance Best Practices:**
- Code splitting at route level
- Lazy loading for large components
- State localized to prevent unnecessary re-renders
- Memoization (React.memo, useMemo, useCallback) used appropriately
- Children prop optimization
- Image optimization (lazy load, modern formats, srcset)
- Bundle size monitoring

**Performance Issues:**
- No code splitting
- Large bundles without analysis
- State too high causing excessive re-renders
- Missing React.memo on expensive components
- Images not optimized
- No lazy loading

#### 2.9 Security Best Practices

**React Security Checklist:**
- JWT authentication with HttpOnly cookies (not localStorage)
- RBAC or PBAC authorization
- Input sanitization before display
- XSS prevention patterns
- CSRF protection
- Secure session management

**Security Violations:**
- Tokens in localStorage
- No input sanitization
- Missing authorization checks
- Hardcoded credentials
- XSS vulnerabilities

#### 2.10 Project Standards Compliance

**Bulletproof Standards:**
- ESLint configured with best practices
- Prettier with format on save
- TypeScript strict mode enabled
- Husky for pre-commit hooks
- Absolute imports with @/ prefix
- Kebab-case file/folder naming

**Standards Violations:**
- No ESLint or misconfigured
- No Prettier
- TypeScript non-strict mode
- No git hooks
- Relative imports everywhere
- Inconsistent naming conventions

### Phase 3: Report Generation

Generate comprehensive audit report with:

#### Executive Summary
- Overall Bulletproof compliance score (0-100)
- Architecture alignment grade (A-F)
- Critical violations count
- Estimated migration effort (person-days)
- Top 5 architectural priorities

#### Structure Comparison
- ASCII diagram of current structure
- ASCII diagram of target Bulletproof structure
- Gap analysis with specific violations
- Feature extraction recommendations

#### Detailed Findings
For each violation:
- **Severity**: Critical, High, Medium, Low
- **Category**: Structure, Components, State, API, Testing, etc.
- **Current State**: What exists now
- **Target State**: Bulletproof recommendation
- **Migration Steps**: How to refactor
- **Effort**: Estimated time
- **Dependencies**: What must happen first

#### Metrics Dashboard
- Structure compliance score
- Component design score
- State management score
- API layer score
- Testing strategy score
- Performance score
- Security score
- Standards compliance score

### Phase 4: Migration Planning

Generate prioritized migration roadmap:

#### Priority 0: Critical Fixes (Do Immediately)
- Security vulnerabilities
- Breaking architectural violations
- Production-impacting issues

#### Priority 1: High-Impact Changes (This Sprint)
- Feature folder creation
- Component reorganization
- Critical refactoring

#### Priority 2: Architecture Alignment (Next Quarter)
- State management refactoring
- API layer restructuring
- Testing improvements
- Performance optimizations

#### Priority 3: Polish and Optimization (Backlog)
- Styling consistency
- Documentation
- Minor refactoring
- Nice-to-have improvements

## Usage Instructions

### Basic Audit
```
Audit this React codebase using the bulletproof-react-auditor skill.
```

### Structure-Focused Audit
```
Run a structure audit on this React app against Bulletproof React patterns.
```

### Generate Migration Plan
```
Audit this React app and generate a migration plan to Bulletproof React architecture.
```

### Custom Scope
```
Audit this React codebase focusing on:
- Project structure and feature organization
- Component architecture patterns
- State management approach
- Testing strategy
```

## Output Formats

1. **Markdown Report** (Default)
   - Human-readable with code examples
   - ASCII structure diagrams
   - Step-by-step migration guidance

2. **JSON Report**
   - Machine-readable for CI/CD
   - Structured findings and metrics
   - Parseable for tooling integration

3. **Migration Plan** (Markdown)
   - Prioritized roadmap
   - Effort estimates per task
   - Dependency tracking
   - Before/after code examples

## Best Practices

1. **Start with structure** - Fix folder organization before refactoring components
2. **Feature extraction first** - Move code to features/ before other changes
3. **Test along the way** - Maintain test coverage during refactoring
4. **Incremental migration** - Don't refactor everything at once
5. **Document decisions** - Create ADRs for major architectural changes
6. **Team alignment** - Ensure team understands Bulletproof principles

## Integration with Existing Standards

This skill enforces Connor's development standards:
- TypeScript strict mode (no `any`)
- 80%+ test coverage minimum
- Testing trophy distribution (70% integration, 20% unit, 10% E2E)
- No console.log in production code
- Conventional commit format
- Semantic test queries (getByRole preferred)

## References

See the `reference/` directory for:
- Complete Bulletproof React principles guide
- Detailed audit criteria checklist
- Severity matrix and scoring rubric
- Common migration patterns and examples
- Architecture decision record templates

## Limitations

- Analysis based on static code analysis (no runtime profiling)
- Requires React 16.8+ (hooks-based)
- Best suited for SPA/SSG apps (Next.js patterns differ slightly)
- Large codebases may require scoped analysis
- Does not execute tests (analyzes test files only)

## Bulletproof React Resources

- Official Guide: https://github.com/alan2207/bulletproof-react
- Project Structure: https://github.com/alan2207/bulletproof-react/blob/master/docs/project-structure.md
- Standards: https://github.com/alan2207/bulletproof-react/blob/master/docs/project-standards.md
- Sample App: https://github.com/alan2207/bulletproof-react/tree/master/apps/react-vite
