---
name: sub-agent-creator
version: 0.1.0
description: Automates creation of Claude Code sub-agents following Anthropic's official patterns, with proper frontmatter, tool configuration, and system prompts.
author: Connor
category: tooling
---

# Sub-Agent Creator

## Overview

This skill automates the creation of Claude Code sub-agents by guiding users through an interactive process that follows Anthropic's official specifications. It generates properly formatted markdown files with YAML frontmatter, configures tool permissions, selects appropriate models, and structures system prompts for effective delegation. The skill ensures compliance with official patterns while incorporating best practices for proactive agent behavior.

## When to Use This Skill

**Trigger Phrases:**
- "create a sub-agent for [purpose]"
- "generate a new sub-agent"
- "set up a sub-agent to handle [task]"
- "build a specialized agent for [domain]"
- "help me create a sub-agent"
- "make a proactive agent that [behavior]"

**Use Cases:**
- Creating domain-specific sub-agents (code reviewer, debugger, data scientist)
- Setting up proactive agents that auto-trigger on task patterns
- Configuring tool permissions for security-sensitive agents
- Building team-shared project-level agents
- Rapid prototyping of specialized AI assistants
- Converting manual workflows into automated delegations

## Response Style

- **Interactive**: Guide users through configuration with clear questions
- **Secure by default**: Recommend minimal tool access, let users expand
- **Educational**: Explain impact of model and tool choices
- **Validating**: Check for common misconfigurations before writing files
- **Official-compliant**: Follow Anthropic's documented patterns exactly

## Workflow

### Phase 1: Information Gathering

**Objective**: Understand the sub-agent's purpose and technical requirements

**Steps:**

1. **Ask for Sub-Agent Purpose**
   - Prompt: "What task or domain should this sub-agent specialize in?"
   - Examples: "code review", "debugging test failures", "SQL query generation"
   - Store as: `purpose`

2. **Determine Sub-Agent Name**
   - Auto-generate from purpose using kebab-case
   - Example: "code review" → "code-reviewer"
   - Validate: lowercase, hyphens only, no spaces
   - Prompt user to confirm or customize
   - Store as: `agent_name`

3. **Craft Description (Critical for Proactive Behavior)**
   - Prompt: "When should Claude automatically use this sub-agent?"
   - Template: "Use PROACTIVELY to [action] when [condition]"
   - Example: "Use PROACTIVELY to review code quality after significant changes"
   - Explain: Including "PROACTIVELY" encourages automatic delegation
   - Store as: `description`

4. **Select Installation Location**
   - Ask: "Where should this sub-agent be installed?"
   - Options:
     - **Project-level** (`.claude/agents/`) - Team-shared, version-controlled
     - **User-level** (`~/.claude/agents/`) - Personal, all projects
   - Recommend project-level for team workflows, user-level for personal utilities
   - Store as: `install_location`

**Output**: Complete purpose definition with name and location

---

### Phase 2: Technical Configuration

**Objective**: Configure model, tools, and system prompt

**Steps:**

1. **Select Model Strategy**
   - Prompt: "Which model should this sub-agent use?"
   - Options (from data/models.yaml):
     - **inherit** - Use same model as main conversation (recommended)
     - **sonnet** - Balanced performance (Claude 3.5 Sonnet)
     - **opus** - Maximum capability (Claude 3 Opus)
     - **haiku** - Fast/economical (Claude 3 Haiku)
   - Explain trade-offs: consistency vs. specialization
   - Default: `inherit`
   - Store as: `model`

2. **Configure Tool Access (Security-Critical)**
   - Explain: "Tools grant capabilities. Limit to minimum necessary."
   - Ask: "What tools does this agent need?"
   - Present categories (from data/tools.yaml):
     - **All tools** - Full access (omit tools field) - Use cautiously
     - **Read-only** - Read, Grep, Glob - Safe for analysis
     - **Code operations** - Read, Edit, Write - For modifications
     - **Execution** - Bash - For running commands
     - **Custom selection** - User picks specific tools
   - Show available tools with descriptions
   - Validate: Warn if granting unnecessary powerful tools
   - Store as: `tools` (comma-separated list or null for all)

3. **Gather System Prompt Components**
   - Prompt: "Describe how this sub-agent should approach tasks"
   - Guidance questions:
     - What's the agent's primary responsibility?
     - What standards or patterns should it follow?
     - What should it prioritize (speed vs. thoroughness)?
     - Are there specific methodologies to apply?
     - What should it never do?
   - Provide examples from examples/ directory
   - Store as: `system_prompt_notes`

**Output**: Complete technical configuration

---

### Phase 3: File Generation

**Objective**: Create properly formatted sub-agent file

**Steps:**

1. **Build YAML Frontmatter**
   ```yaml
   ---
   name: {agent_name}
   description: {description}
   tools: {tools}  # Omit if all tools
   model: {model}  # Omit if inherit
   ---
   ```

2. **Structure System Prompt**
   - Use template from templates/agent-template.md
   - Sections:
     - **Role**: Define agent's expertise and focus
     - **Approach**: Methodology and standards
     - **Priorities**: What to optimize for
     - **Constraints**: What to avoid or never do
     - **Examples**: Show expected behavior patterns
   - Incorporate user's `system_prompt_notes`
   - Add TODO markers for customization

3. **Generate Complete File**
   - Combine frontmatter + system prompt
   - Validate YAML syntax
   - Check for placeholder content
   - Ensure description includes "PROACTIVELY" if appropriate

4. **Write to Correct Location**
   ```bash
   # Project-level
   mkdir -p .claude/agents/
   write .claude/agents/{agent_name}.md

   # OR User-level
   mkdir -p ~/.claude/agents/
   write ~/.claude/agents/{agent_name}.md
   ```

**Output**: Sub-agent file written to correct location

---

### Phase 4: Validation & Testing

**Objective**: Verify sub-agent is properly configured and loadable

**Steps:**

1. **Run Validation Checks**
   - ✅ YAML frontmatter is valid
   - ✅ Required fields present (name, description)
   - ✅ Tools list is valid (if specified)
   - ✅ Model value is valid (if specified)
   - ✅ No security issues (exposed secrets, overly broad permissions)
   - ✅ Description clarity (specific enough for auto-delegation)

2. **Generate Validation Report**
   ```markdown
   # Sub-Agent Validation: {agent_name}

   ## Status: [PASS/NEEDS REVIEW]

   ### Configuration
   ✅ Name: {agent_name}
   ✅ Location: {install_location}
   ✅ Model: {model}
   ✅ Tools: {tools or "All (use cautiously)"}

   ### Security Review
   {security_warnings}

   ### Quality Score: {grade}
   ```

3. **Provide Testing Guidance**
   ```markdown
   ## Test Your Sub-Agent

   ### Manual Invocation
   In a Claude Code session, try:
   "Use the {agent_name} sub-agent to {example_task}"

   ### Proactive Trigger
   {If description includes PROACTIVELY}
   Perform action that matches description:
   {specific_action_to_trigger}

   ### Expected Behavior
   {what_should_happen}

   ### Debugging
   If agent doesn't load:
   1. Check YAML syntax: `cat {path} | head -10`
   2. Verify location: `ls {install_location}`
   3. Review main session for error messages
   ```

4. **List Customization Points**
   - Sections marked with TODO
   - Suggested improvements
   - Optional enhancements (examples, more detailed constraints)

**Output**: Validation report with testing instructions

---

### Phase 5: Next Steps & Best Practices

**Objective**: Guide user on iteration and improvement

**Steps:**

1. **Provide Refinement Roadmap**
   ```markdown
   ## Next Steps

   1. **Test basic functionality**
      - Try manual invocation first
      - Verify tools work as expected
      - Check model performance

   2. **Refine system prompt**
      - Add specific examples of good/bad outputs
      - Include edge cases to handle
      - Reference standards or methodologies

   3. **Tune proactive behavior**
      - Adjust description if too aggressive/passive
      - Add specific trigger conditions
      - Test with realistic workflows

   4. **Optimize tool access**
      - Remove unused tools
      - Add necessary tools discovered during testing
      - Review security implications

   5. **Document for team (if project-level)**
      - Add examples/ directory with usage scenarios
      - Create README explaining when to use
      - Version control the agent with project
   ```

2. **Share Best Practices**
   - Reference Anthropic's official documentation
   - Link to successful example agents
   - Explain common pitfalls and solutions

3. **Offer Advanced Options**
   - Create multiple specialized variants
   - Set up agent composition patterns
   - Integrate with MCP servers

**Output**: Complete guidance for successful deployment

---

## Error Handling

### Common Issues

**Invalid agent name format**
- Validate: lowercase, hyphens only
- Auto-fix: convert to kebab-case
- Prompt for confirmation

**Overly broad tool access**
- Warning: "Granting all tools includes Write, Edit, Bash - is this necessary?"
- Recommend: Start minimal, add tools as needed
- Require explicit confirmation for "all tools"

**Vague description (won't trigger proactively)**
- Detect: Missing specific conditions or actions
- Suggest: "Add 'when [specific situation]' to description"
- Show examples of effective descriptions

**Tools list includes invalid tool**
- Validate against data/tools.yaml
- Show available tools
- Prompt to correct

**Permission issues on write**
- Check directory permissions
- Suggest alternative location
- Provide manual installation instructions

**Agent name conflicts with existing**
- Detect existing file
- Options: Overwrite, rename, cancel
- Show existing agent's purpose for comparison

## Success Criteria

- [ ] Valid YAML frontmatter (name + description required)
- [ ] Agent file written to correct location
- [ ] Tools list is valid (if specified)
- [ ] Model is valid (if specified)
- [ ] Description is specific and actionable
- [ ] System prompt includes role, approach, and constraints
- [ ] No security issues (appropriate tool restrictions)
- [ ] File is loadable by Claude Code (no syntax errors)
- [ ] User has clear testing instructions
- [ ] User understands next steps for refinement

## Reference Materials

See supporting files:

- `data/models.yaml` - Available model options with descriptions
- `data/tools.yaml` - Available tools with capabilities and security notes
- `templates/agent-template.md` - System prompt structure template
- `examples/code-reviewer.md` - Example: Code review agent
- `examples/debugger.md` - Example: Debugging specialist agent
- `examples/data-scientist.md` - Example: Data analysis agent

## Important Reminders

1. **Security first** - Default to minimal tool access
2. **Proactive descriptions** - Include "PROACTIVELY" for auto-delegation
3. **Clear system prompts** - Specific instructions with examples
4. **Test before deploy** - Verify agent loads and behaves correctly
5. **Iterate based on usage** - Refine after observing real-world behavior
6. **Document for teams** - Project-level agents need usage guidance
7. **Follow official patterns** - Stay compliant with Anthropic specs

---

**Official Documentation**: https://docs.claude.com/en/docs/claude-code/sub-agents
