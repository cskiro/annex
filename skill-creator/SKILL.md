---
name: skill-creator
version: 0.1.0
description: Automated skill generation tool that creates production-ready Claude Code skills following Claudex marketplace standards with intelligent templates, pattern detection, and quality validation
author: Connor
---

# Skill Creator

## Overview

This skill automates the creation of new Claude Code skills by guiding users through an interactive process, generating all required files from templates, and ensuring compliance with Claudex marketplace standards. It handles directory structure, template population, pattern selection, and quality validation to produce production-ready skills.

## When to Use This Skill

**Trigger Phrases:**
- "create a new skill for [purpose]"
- "generate a skill called [name]"
- "help me build a skill that [description]"
- "set up a new skill"
- "I need a skill to [purpose]"
- "scaffold a [type] skill"

**Use Cases:**
- Creating a new skill from scratch
- Setting up proper skill structure automatically
- Following Claudex marketplace standards
- Generating production-ready skill templates
- Learning skill structure through examples
- Rapid prototyping of skill ideas

## Response Style

- **Interactive**: Ask clarifying questions to gather requirements
- **Guided**: Provide clear options and recommendations
- **Educational**: Explain choices and patterns
- **Thorough**: Generate complete, production-ready output
- **Validating**: Check quality before finalizing

## Quick Decision Matrix

```
User Request                          → Mode          → Action
───────────────────────────────────────────────────────────────────
"create skill for [purpose]"          → Guided        → Interactive creation
"create [type] skill"                 → Quick Start   → Template-based
"skill like [existing]"               → Clone         → Copy pattern
"validate skill"                      → Validate      → Quality check
```

## Mode Detection Logic

```javascript
// Mode 1: Guided Creation (Default)
if (userMentions("create", "new skill", "generate", "build")) {
  return "guided-creation";
}

// Mode 2: Quick Start (Template-Based)
if (userSpecifiesType("minimal", "standard", "complex", "data-processing")) {
  return "quick-start";
}

// Mode 3: Clone & Modify
if (userMentions("similar to", "like", "based on", "clone")) {
  return "clone-and-modify";
}

// Mode 4: Validation Only
if (userMentions("validate", "check", "review") && !userMentions("create")) {
  return "validation-only";
}

// Default - ask user
return askForClarification();
```

## Core Responsibilities

### 1. Information Gathering
- ✓ Prompt user for essential skill information
- ✓ Suggest intelligent defaults based on skill purpose
- ✓ Validate inputs against naming conventions
- ✓ Detect skill complexity level automatically
- ✓ Recommend appropriate patterns and structure

### 2. Structure Generation
- ✓ Create directory structure based on complexity
- ✓ Generate all required files (SKILL.md, README.md, plugin.json, CHANGELOG.md)
- ✓ Set up optional directories (modes/, data/, examples/, templates/, scripts/)
- ✓ Apply appropriate pattern (mode-based, phase-based, validation, data-processing)

### 3. Template Population
- ✓ Fill templates with user-provided information using Jinja2
- ✓ Generate trigger phrases automatically from purpose
- ✓ Create example workflows and use cases
- ✓ Set proper version, dates, and metadata
- ✓ Mark sections needing customization with TODO comments

### 4. Quality Validation
- ✓ Run quality checklist from data/quality-checklist.md
- ✓ Validate YAML frontmatter and JSON syntax
- ✓ Check for placeholder content
- ✓ Verify naming conventions
- ✓ Ensure no security issues (secrets, sensitive data)

### 5. Installation & Guidance
- ✓ Install skill to ~/.claude/skills/[skill-name]/
- ✓ Provide testing instructions with sample triggers
- ✓ Generate TODO list for user customization
- ✓ Explain next steps and best practices

## Workflow

### Phase 1: Mode Selection & Initial Context

**Purpose**: Understand user intent and choose appropriate creation mode

**Steps:**
1. Detect which mode to use from user request
2. If ambiguous, ask: "Would you like to: (1) Create with guided questions, (2) Use quick template, (3) Clone existing skill pattern?"
3. Gather initial context about skill purpose
4. Set user expectations for the process

**Output**: Selected mode and initial skill context

**Transition**: Move to mode-specific workflow

---

### Mode 1: Guided Creation (Interactive)

Use when user wants full guidance and customization.

#### Step 1: Basic Information

Ask user:
1. **Skill Name** (provide formatting guidance: kebab-case)
   - Validate: lowercase, hyphens only, descriptive
   - Example: "code-formatter", "test-generator", "api-validator"

2. **Brief Description** (1-2 sentences for metadata)
   - Will be used in plugin.json and SKILL.md frontmatter
   - Should clearly state what skill does

3. **Author Name** (default: Connor)
   - Used in all metadata files

**Validation**: Check name doesn't conflict with existing skills

#### Step 2: Skill Purpose & Category

Ask user:
1. **Detailed Description** (what does this skill do in detail?)
   - This goes in SKILL.md Overview section
   - Should be 2-4 sentences explaining capabilities

2. **Category Selection** (use data/categories.yaml for options)
   - Present 4 categories with descriptions:
     - analysis: Code analysis, auditing, quality checking
     - tooling: Development tools, configuration validators
     - productivity: Developer workflow, automation, insights
     - devops: Infrastructure, deployment, monitoring
   - Suggest category based on skill purpose
   - Allow user to confirm or change

3. **Trigger Phrases** (3-5 phrases users might say)
   - Ask: "What phrases would users say to activate this skill?"
   - Provide examples based on similar skills
   - Generate suggestions if user needs help

4. **Use Cases** (3-5 concrete use cases)
   - Ask: "What are the main scenarios where this skill helps?"
   - Should be specific, actionable situations

**Output**: Complete purpose definition with category and triggers

#### Step 3: Complexity Assessment

Analyze gathered information to determine skill type:

**Questions to determine type:**
1. "Does this skill have multiple distinct modes or workflows?"
   - Yes → Complex (mode-based)
   - No → Continue

2. "Does this skill process data from files or generate reports?"
   - Yes → Complex (data-processing)
   - No → Continue

3. "Does this skill need reference materials (standards, best practices)?"
   - Yes → Standard
   - No → Minimal

**Reference**: Use data/skill-types.yaml for type definitions

**Output**: Determined skill type (minimal, standard, complex-mode, complex-data)

#### Step 4: Structure Customization

Based on determined type, ask about optional directories:

**For Standard or Complex skills:**
- "Will you need reference data files?" → create data/
- "Will you need example outputs?" → create examples/
- "Will you need reusable templates?" → create templates/

**For Complex (mode-based) skills:**
- "How many modes does this skill have?" (2-5 typical)
- For each mode, ask:
  - Mode name
  - When to use (trigger phrases for this mode)
  - Primary action in this mode

**For Complex (data-processing) skills:**
- "What data sources will you process?"
- "What output formats do you need?"
- → Always create scripts/ directory

**Output**: Directory structure specification

#### Step 5: Pattern Selection

Based on skill type, select appropriate pattern from patterns/:
- Minimal → phase-based.md
- Standard → phase-based.md or validation.md (if auditing)
- Complex (mode-based) → mode-based.md
- Complex (data-processing) → data-processing.md

**Present pattern to user**: "I'll use the [pattern] pattern for your skill, which means..."

**Output**: Selected pattern with explanation

#### Step 6: Generation

Execute generation process:

1. **Create Directory Structure**
   ```bash
   mkdir -p ~/.claude/skills/[skill-name]/{required,optional-dirs}
   ```

2. **Generate Files from Templates**
   - Use templates/ directory with Jinja2
   - Populate SKILL.md from templates/SKILL.md.j2
   - Populate README.md from templates/README.md.j2
   - Populate plugin.json from templates/plugin.json.j2
   - Populate CHANGELOG.md from templates/CHANGELOG.md.j2

3. **Apply Pattern-Specific Content**
   - Include pattern guidance in appropriate sections
   - Add pattern-specific templates if needed
   - Create mode files if mode-based

4. **Mark Customization Points**
   - Add TODO comments where user needs to customize
   - Provide inline guidance for each section
   - Reference examples/ for inspiration

**Output**: Complete skill directory with all files

#### Step 7: Quality Validation

Run validation using data/quality-checklist.md:

1. **File Existence**: Verify all required files created
2. **Syntax Validation**: Check YAML frontmatter and JSON
3. **Content Completeness**: Ensure no empty required sections
4. **Security Check**: No secrets or sensitive data
5. **Naming Conventions**: Verify kebab-case, no spaces
6. **Quality Score**: Calculate A-F grade

**Generate Validation Report**:
```markdown
# Skill Quality Report: [skill-name]

## Status: [PASS/NEEDS WORK]

### Files Generated
✅ SKILL.md
✅ README.md
✅ plugin.json
✅ CHANGELOG.md

### Quality Score: [Grade]

### Items Needing Customization
- [ ] SKILL.md: Complete "Response Style" section
- [ ] SKILL.md: Fill in workflow details
- [ ] README.md: Add concrete usage examples
- [ ] [Additional items...]

### Validation Results
✅ No security issues
✅ Valid YAML frontmatter
✅ Valid JSON in plugin.json
✅ Proper naming conventions
```

**Output**: Validation report with action items

#### Step 8: Installation & Next Steps

1. **Verify Installation**
   ```bash
   ls -la ~/.claude/skills/[skill-name]/
   ```

2. **Test Skill Loading**
   - Provide command to check: Use skill listing in Claude

3. **Provide Testing Guidance**
   ```markdown
   ## Test Your Skill

   Try these trigger phrases in a new Claude session:
   1. "[trigger-phrase-1]"
   2. "[trigger-phrase-2]"
   3. "[trigger-phrase-3]"

   Expected behavior: [What should happen]
   ```

4. **Generate Customization TODO List**
   - List all sections marked with TODO
   - Prioritize by importance
   - Provide examples for each

5. **Provide Next Steps**
   ```markdown
   ## Next Steps

   1. Review generated files in ~/.claude/skills/[skill-name]/
   2. Customize sections marked with TODO
   3. Add reference materials to data/ (if applicable)
   4. Create example outputs in examples/ (if applicable)
   5. Test trigger phrases in new Claude session
   6. Iterate on description and workflow
   7. Run validation again: "[command]"
   8. Ready to use or submit to marketplace!
   ```

**Output**: Complete installation with testing guide

---

### Mode 2: Quick Start (Template-Based)

Use when user specifies skill type directly.

#### Process:
1. Confirm skill type: minimal, standard, complex-mode, or complex-data
2. Gather minimal required info:
   - Skill name
   - Brief description
   - Author (default: Connor)
3. Use appropriate example from examples/ as base
4. Generate with standardized defaults
5. Flag ALL customization points
6. Provide condensed customization guide

**Advantages**: Fast, minimal questions
**Trade-off**: More TODO sections to customize

---

### Mode 3: Clone & Modify

Use when user wants to base skill on existing one.

#### Process:
1. Ask which existing skill to use as template
2. Read that skill's structure and patterns
3. Extract organizational pattern (not content)
4. Ask for new skill's basic info
5. Generate with same structure
6. Clear all example-specific content
7. Preserve structural best practices
8. Mark all content sections for customization

**Advantages**: Proven structure, familiar patterns
**Trade-off**: May inherit unnecessary complexity

---

### Mode 4: Validation Only

Use when user wants to check existing skill.

#### Process:
1. Ask for skill path or detect from context
2. Read existing skill files
3. Run quality checklist (data/quality-checklist.md)
4. Generate validation report
5. Provide specific remediation steps
6. Offer to fix issues automatically (if possible)

**Advantages**: Quality assurance, catch issues early
**Use Case**: Before submission, after modifications

---

## Error Handling

### Common Issues:

**Skill name already exists**
- Check ~/.claude/skills/ directory
- Suggest alternatives or confirmation to overwrite

**Invalid skill name format**
- Explain kebab-case requirement
- Provide corrected suggestion
- Re-prompt for valid name

**Missing required information**
- Don't proceed without essential fields
- Provide clear explanation of why needed
- Offer examples or defaults

**Template rendering fails**
- Check Jinja2 template syntax
- Provide clear error message
- Fallback to manual file creation with guidance

**Permission issues**
- Check write permissions on ~/.claude/skills/
- Provide troubleshooting steps
- Suggest alternative installation location

## Success Criteria

- [ ] All required files generated (SKILL.md, README.md, plugin.json, CHANGELOG.md)
- [ ] Valid YAML frontmatter in SKILL.md
- [ ] Valid JSON in plugin.json
- [ ] Proper markdown structure throughout
- [ ] No security issues (secrets, credentials)
- [ ] Skill name follows kebab-case convention
- [ ] Version is 0.1.0 for new skills
- [ ] At least 3 trigger phrases defined
- [ ] Appropriate category selected
- [ ] Current date in CHANGELOG
- [ ] Quality validation passes (C grade or better)
- [ ] Skill can be loaded without errors
- [ ] User has clear next steps for customization

## Reference Materials

See supporting files for detailed guidance:

### Templates
- `templates/SKILL.md.j2` - Main skill manifest template
- `templates/README.md.j2` - User documentation template
- `templates/plugin.json.j2` - Marketplace metadata template
- `templates/CHANGELOG.md.j2` - Version history template

### Patterns
- `patterns/mode-based.md` - Multi-mode skill pattern
- `patterns/phase-based.md` - Sequential workflow pattern
- `patterns/validation.md` - Audit/validation skill pattern
- `patterns/data-processing.md` - Data analysis skill pattern

### Reference Data
- `data/categories.yaml` - Valid categories with descriptions
- `data/skill-types.yaml` - Skill type definitions and guidance
- `data/quality-checklist.md` - Complete quality validation criteria

### Examples
- `examples/minimal-skill/` - Minimal structure example
- `examples/standard-skill/` - Standard structure example
- `examples/complex-skill/` - Complex structure example

---

## Important Reminders

1. **Always validate inputs** - Check name format, required fields before generating
2. **Use intelligent defaults** - Minimize questions while allowing customization
3. **Explain choices** - Help user understand pattern and structure decisions
4. **Quality first** - Run validation before declaring success
5. **Clear next steps** - User should know exactly what to customize
6. **Examples help** - Reference existing skills for guidance
7. **Incremental is fine** - User can start minimal and grow structure later
8. **Test loading** - Verify skill can be loaded by Claude Code

## Quick Reference Commands

**Check existing skills:**
```bash
ls ~/.claude/skills/
```

**View skill structure:**
```bash
tree ~/.claude/skills/[skill-name]/
```

**Validate skill files:**
```bash
cat ~/.claude/skills/[skill-name]/SKILL.md | head -20  # Check frontmatter
python -m json.tool ~/.claude/skills/[skill-name]/plugin.json  # Validate JSON
```

**Test skill in new session:**
Open new Claude Code session and try trigger phrases.

---

**Remember**: This skill automates the tedious parts of skill creation while preserving the creative and domain-specific work for the user. Generate clean, production-ready templates with clear customization points!
