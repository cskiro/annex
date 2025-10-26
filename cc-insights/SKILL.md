---
name: cc-insights
description: Automatically processes Claude Code conversations from the project's history, enables RAG-powered semantic search, generates insight reports with pattern detection, and provides an optional dashboard for visualization. Transforms conversation data into actionable knowledge without manual intervention.
---

# Claude Code Insights Skill

Unlock the hidden value in your Claude Code conversation history through automatic processing, semantic search, and intelligent insight generation.

## Overview

This skill automatically analyzes your project's Claude Code conversations (stored in `~/.claude/projects/[project]/*.jsonl`) to provide:

- 🔍 **RAG-Powered Semantic Search**: Find conversations by meaning, not just keywords
- 📊 **Automatic Insight Reports**: Pattern detection, file hotspots, tool usage analytics
- 📈 **Activity Trends**: Understand your development patterns over time
- 💡 **Knowledge Extraction**: Surface recurring topics, solutions, and best practices
- 🎯 **Zero Manual Effort**: Fully automatic processing of existing conversations

## When to Use This Skill

Activate this skill when you need to:

- Search past conversations: "Find conversations about authentication bugs"
- Generate insights: "Create a weekly activity report"
- Understand patterns: "What files do I modify most often?"
- Extract knowledge: "What solutions have I used for React performance?"
- Visualize activity: "Show my conversation timeline"
- Start dashboard: "Launch the insights dashboard"

## Key Features

### 1. Automatic Conversation Processing

The skill automatically processes conversations from `~/.claude/projects/[current-project]/`:

- **JSONL Parsing**: Decodes base64-encoded conversation content
- **Metadata Extraction**: Timestamps, message counts, file interactions, tool usage
- **Topic Detection**: Keyword extraction and pattern recognition
- **Incremental Updates**: Only processes new or modified conversations
- **SQLite Index**: Fast metadata queries without reprocessing

### 2. RAG-Powered Semantic Search

Beyond keyword matching, find conversations by meaning:

- **Vector Embeddings**: Uses sentence-transformers for semantic understanding
- **ChromaDB Storage**: Efficient vector similarity search
- **Context Preservation**: Maintains conversation structure and metadata
- **Ranked Results**: Most relevant conversations first with similarity scores
- **Snippet Preview**: See matching content in context

**Example Searches**:
```
"debugging memory leaks in React components"
"implementing JWT authentication with refresh tokens"
"fixing TypeScript strict mode errors"
"optimizing build performance with Vite"
```

### 3. Intelligent Insight Generation

Automatically detect patterns and generate reports:

**Pattern Detection**:
- File hotspots (frequently modified files)
- Tool usage patterns (most used Claude Code tools)
- Activity trends (conversations over time)
- Topic clusters (recurring themes)
- Collaboration patterns (file co-modification)

**Report Types**:
- **Weekly Activity Summary**: Overview of recent work with metrics
- **Project Knowledge Extraction**: Key learnings and solutions
- **File Interaction Heatmap**: Which files are most active
- **Tool Usage Analytics**: How you use Claude Code tools
- **Custom Reports**: Flexible template system

### 4. Optional Interactive Dashboard

Launch a local web dashboard for rich visualization:

- **Conversation Timeline**: Visual history with filters
- **Interactive Search**: Real-time semantic + keyword search
- **Insights Panel**: Auto-generated reports with charts
- **File Explorer**: See all conversations touching each file
- **Activity Analytics**: Visualize patterns and trends

**Tech Stack**: Next.js 15, React Server Components, Tailwind CSS, Recharts

## Interaction Modes

### Mode 1: Search Conversations

**When to use**: Find specific past conversations

**Process**:
1. Ask: "Search conversations about [topic]"
2. Skill performs RAG semantic search
3. Returns ranked results with context snippets
4. Optionally show full conversation details

**Example Triggers**:
- "Find conversations about React performance optimization"
- "Search for times I fixed authentication bugs"
- "Show me conversations that modified Auth.tsx"
- "What conversations mention TypeScript strict mode?"

**Output Format**:
```
Found 5 conversations about "React performance optimization":

1. [Similarity: 0.89] "Optimize UserProfile re-renders" (Oct 25, 2025)
   Files: src/components/UserProfile.tsx, src/hooks/useUser.ts
   Snippet: "...implemented useMemo to prevent unnecessary re-renders..."

2. [Similarity: 0.82] "Fix dashboard performance issues" (Oct 20, 2025)
   Files: src/pages/Dashboard.tsx
   Snippet: "...React.memo wrapper reduced render count by 60%..."

[View full conversations? Type the number]
```

### Mode 2: Generate Insights

**When to use**: Understand patterns and trends

**Process**:
1. Ask: "Generate insights for [timeframe]"
2. Skill analyzes metadata and patterns
3. Creates markdown report with visualizations
4. Offers to save report to file

**Example Triggers**:
- "Generate weekly insights report"
- "Show me my most active files this month"
- "What patterns do you see in my conversations?"
- "Create a project summary report"

**Report Sections**:
- Executive Summary (key metrics)
- Activity Timeline (conversations over time)
- File Hotspots (most modified files)
- Tool Usage Breakdown (which tools you use most)
- Topic Clusters (recurring themes)
- Knowledge Highlights (key solutions and learnings)

### Mode 3: Interactive Dashboard

**When to use**: Rich visual exploration and ongoing monitoring

**Process**:
1. Ask: "Start the insights dashboard"
2. Skill launches Next.js dev server
3. Opens browser to http://localhost:3000
4. Provides real-time data from SQLite + ChromaDB

**Dashboard Pages**:
- **Home**: Timeline, activity stats, quick metrics
- **Search**: Interactive semantic + keyword search interface
- **Insights**: Auto-generated reports with interactive charts
- **Files**: File-centric view of all conversations
- **Analytics**: Deep-dive into patterns and trends

**Example Triggers**:
- "Launch the insights dashboard"
- "Start the visualization server"
- "Show me the interactive insights"

### Mode 4: Export and Integration

**When to use**: Share insights or integrate with other tools

**Process**:
1. Ask: "Export [report type] as [format]"
2. Skill generates formatted output
3. Saves to specified location

**Export Formats**:
- Markdown: Human-readable reports
- JSON: Machine-readable data for integration
- CSV: Activity data for spreadsheets
- HTML: Standalone report with styling

**Example Triggers**:
- "Export weekly insights as markdown"
- "Save conversation metadata as JSON"
- "Generate HTML report for sharing"

## Using the Skill

### Initial Setup

**First time usage**:
1. Install dependencies: `pip install -r requirements.txt`
2. Run initial processing: Skill will automatically process existing conversations
3. Build embeddings: Creates semantic search index (one-time, ~1-2 min)
4. Ready to search and analyze!

**What happens automatically**:
- Scans `~/.claude/projects/[current-project]/*.jsonl`
- Extracts and indexes conversation metadata
- Builds vector embeddings for semantic search
- Creates SQLite database for fast queries
- Sets up ChromaDB for similarity search

### Search Examples

**Semantic search (by meaning)**:
```
User: "Find conversations about fixing bugs related to user authentication"

Skill: [Performs RAG search]
Found 3 conversations:
1. "Debug JWT token expiration" (Oct 24)
2. "Fix OAuth redirect loop" (Oct 20)
3. "Implement session timeout handling" (Oct 18)
```

**Metadata search (by files/tools)**:
```
User: "Show conversations that modified src/auth/token.ts"

Skill: [Queries SQLite metadata]
Found 5 conversations touching src/auth/token.ts:
1. "Implement token refresh logic" (Oct 25)
2. "Add token validation" (Oct 22)
...
```

**Time-based search**:
```
User: "What did I work on last week?"

Skill: [Queries by date range]
Last week (Oct 19-25) you had 12 conversations:
- 5 about authentication features
- 3 about bug fixes
- 2 about testing
- 2 about refactoring
```

### Insight Generation Examples

**Weekly summary**:
```
User: "Generate insights for the past week"

Skill: [Analyzes patterns, creates report]

# Weekly Insights (Oct 19-25, 2025)

## Overview
- 12 conversations
- 8 active days
- 23 files modified
- 45 tool uses

## Top Files
1. src/auth/token.ts (5 modifications)
2. src/components/Login.tsx (3 modifications)
3. src/api/auth.ts (3 modifications)

## Activity Pattern
Mon: ████████ 4 conversations
Tue: ██████ 3 conversations
Wed: ██████ 3 conversations
Thu: ████ 2 conversations
Fri: ████ 2 conversations

## Key Topics
- Authentication (6 conversations)
- Testing (3 conversations)
- Bug fixes (2 conversations)

## Knowledge Highlights
- Implemented JWT refresh token pattern
- Added React Testing Library for auth components
- Fixed OAuth redirect edge case

[Save report to file? Y/n]
```

**File-centric analysis**:
```
User: "Which files do I modify most often?"

Skill: [Aggregates file interaction data]

# File Hotspots (All Time)

🔥🔥🔥 src/auth/token.ts (15 conversations)
🔥🔥 src/components/Login.tsx (9 conversations)
🔥🔥 src/api/auth.ts (8 conversations)
🔥 src/hooks/useAuth.ts (6 conversations)
🔥 tests/auth/token.test.ts (5 conversations)

Insight: Authentication module is your most active area.
Consider: Review token.ts for refactoring opportunities.
```

### Dashboard Usage

**Starting the dashboard**:
```
User: "Start the insights dashboard"

Skill: [Launches Next.js server]
✓ Dependencies installed
✓ Database connected
✓ Server starting...
✓ Dashboard ready at http://localhost:3000

Opening browser...

[Dashboard features]:
- Timeline view with 47 conversations
- Search with semantic + keyword modes
- 3 pre-generated insight reports
- File explorer with 89 files tracked
```

**Dashboard Capabilities**:
- Real-time search as you type
- Filter by date range, files, or topics
- Click conversations to see full details
- Export any view as markdown/JSON
- Interactive charts (activity, files, tools)
- Responsive design (works on mobile)

## Architecture

### Data Flow

```
Claude Code → JSONL files → Processor → SQLite + ChromaDB
                                            ↓
                                     Search/Insights
                                            ↓
                                    CLI / Dashboard
```

### Storage Structure

```
.claude/skills/cc-insights/
└── .processed/
    ├── conversations.db          # SQLite metadata
    ├── embeddings/               # ChromaDB vector store
    │   ├── chroma.sqlite3
    │   └── [embeddings data]
    └── cache/                    # Processed conversation cache
```

### Performance Characteristics

- **Initial indexing**: ~1-2 minutes for 100 conversations
- **Incremental updates**: <5 seconds for new conversations
- **Search latency**: <1 second for semantic search
- **Insight generation**: <10 seconds for weekly report
- **Dashboard startup**: <5 seconds
- **Memory usage**: ~200MB for 1000 conversations

## Scripts Reference

### conversation-processor.py
**Purpose**: Parse JSONL files and extract metadata

**Usage**:
```bash
python scripts/conversation-processor.py [options]

Options:
  --project-path PATH    Project directory (default: detect from CWD)
  --reindex             Reprocess all conversations (default: incremental)
  --verbose             Show detailed processing logs
```

**What it does**:
- Scans `~/.claude/projects/[project]/*.jsonl`
- Decodes base64 content
- Extracts messages, timestamps, file interactions, tool usage
- Stores in SQLite for fast queries
- Tracks processing state for incremental updates

### rag-indexer.py
**Purpose**: Build vector embeddings for semantic search

**Usage**:
```bash
python scripts/rag-indexer.py [options]

Options:
  --model MODEL         Embedding model (default: all-MiniLM-L6-v2)
  --rebuild             Rebuild entire index
  --batch-size N        Processing batch size (default: 32)
```

**What it does**:
- Reads conversations from SQLite
- Generates embeddings using sentence-transformers
- Stores vectors in ChromaDB
- Supports incremental indexing

### search-conversations.py
**Purpose**: CLI search interface

**Usage**:
```bash
python scripts/search-conversations.py "query" [options]

Options:
  --semantic            Use RAG semantic search (default)
  --keyword             Use keyword-only search
  --files PATTERN       Filter by file pattern
  --date-from DATE      Start date (ISO format)
  --date-to DATE        End date (ISO format)
  --limit N             Max results (default: 10)
  --format FORMAT       Output format: text|json|markdown
```

**Examples**:
```bash
# Semantic search
python scripts/search-conversations.py "authentication bugs"

# Filter by file
python scripts/search-conversations.py "React optimization" --files "src/components/*.tsx"

# Date range
python scripts/search-conversations.py "refactoring" --date-from 2025-10-01 --date-to 2025-10-25

# JSON output for integration
python scripts/search-conversations.py "testing" --format json
```

### insight-generator.py
**Purpose**: Generate pattern-based reports

**Usage**:
```bash
python scripts/insight-generator.py [report-type] [options]

Report Types:
  weekly              Weekly activity summary
  project-summary     Overall project insights
  file-heatmap        File modification analysis
  tool-usage          Tool usage analytics
  custom              Custom report from template

Options:
  --date-from DATE      Start date
  --date-to DATE        End date
  --output FILE         Save to file (default: stdout)
  --format FORMAT       Output format: markdown|json|html
  --template FILE       Custom template path
```

**Examples**:
```bash
# Weekly report
python scripts/insight-generator.py weekly --date-from 2025-10-19

# File heatmap
python scripts/insight-generator.py file-heatmap --output heatmap.md

# Custom report
python scripts/insight-generator.py custom --template templates/custom-report.md
```

## Report Templates

Templates use Jinja2 syntax and have access to conversation metadata:

### Available Variables:
- `conversations`: List of conversation objects
- `date_range`: Start and end dates
- `file_stats`: File interaction statistics
- `tool_stats`: Tool usage statistics
- `topics`: Extracted topic clusters
- `patterns`: Detected patterns

### Template Structure:
```markdown
# {{ report_title }}
Generated: {{ generation_date }}

## Overview
- Total conversations: {{ conversations|length }}
- Date range: {{ date_range.start }} to {{ date_range.end }}

## Top Files
{% for file, count in file_stats[:10] %}
- {{ file }}: {{ count }} modifications
{% endfor %}

## Activity Timeline
{{ activity_chart }}

## Key Insights
{{ insights }}
```

## Best Practices

### For Search:
1. **Start broad, refine narrow**: Initial semantic search, then add filters
2. **Use semantic for "what" questions**: "What conversations fixed performance issues?"
3. **Use metadata for "when/where" questions**: "What files did I modify last week?"
4. **Combine both**: "Find React bugs in src/components/ last month"

### For Insights:
1. **Generate regularly**: Weekly reports help track progress
2. **Focus on patterns**: Let the skill surface trends you might miss
3. **File hotspots**: Regular review prevents tech debt accumulation
4. **Tool usage**: Understand your workflow, optimize accordingly

### For Performance:
1. **Incremental processing**: Let automatic updates handle new conversations
2. **Rebuild embeddings**: Only when changing models or fixing issues
3. **Archive old conversations**: Move to separate directory if needed
4. **Index size**: ~100MB per 1000 conversations is normal

## Troubleshooting

### "No conversations found"
**Cause**: Project conversations not yet processed or wrong project directory
**Solution**:
```bash
python scripts/conversation-processor.py --verbose --reindex
```

### "Slow search performance"
**Cause**: Large index or missing optimizations
**Solution**:
```bash
# Rebuild with optimizations
python scripts/rag-indexer.py --rebuild --batch-size 64
```

### "Dashboard won't start"
**Cause**: Missing dependencies or port conflict
**Solution**:
```bash
cd dashboard
npm install
PORT=3001 npm run dev  # Use different port
```

### "Out of memory during indexing"
**Cause**: Processing too many conversations at once
**Solution**:
```bash
python scripts/rag-indexer.py --batch-size 16  # Smaller batches
```

## Privacy & Security

- **Local-only**: All data stays on your machine
- **No external APIs**: Embeddings generated locally
- **Project-scoped**: Only accesses current project's conversations
- **Gitignore-ready**: `.processed/` is excluded from version control
- **Sensitive data**: Conversations may contain secrets—review before sharing reports

## Dependencies

### Python (Required):
```
sentence-transformers>=2.2.0
chromadb>=0.4.0
jinja2>=3.1.0
click>=8.1.0
python-dateutil>=2.8.0
```

### Node.js (Optional - Dashboard only):
```
next@15
react@19
@tanstack/react-query
recharts
tailwindcss
```

## Extending the Skill

### Custom Report Templates:
1. Create template in `templates/my-report.md`
2. Use Jinja2 syntax with available variables
3. Generate: `python scripts/insight-generator.py custom --template templates/my-report.md`

### Custom Metrics:
Edit `scripts/insight-generator.py` and add to `PatternDetector` class:
```python
def detect_my_pattern(self, conversations):
    # Your pattern detection logic
    return pattern_data
```

### Integration with Other Tools:
Use JSON export for piping to other tools:
```bash
python scripts/search-conversations.py "topic" --format json | jq '.results[].id'
```

## Limitations

- **Static analysis only**: Analyzes saved conversations, not real-time
- **Local embeddings**: Semantic quality depends on model (good, not GPT-4 level)
- **Single project**: Designed for per-project insights (not cross-project analytics)
- **No conversation editing**: Read-only access to conversation history
- **Dashboard is dev-only**: Not production-ready (local development tool)

## Success Criteria

You're successfully using this skill when:

- ✅ You can find any past conversation in <10 seconds
- ✅ Weekly insights reveal patterns you didn't notice manually
- ✅ File hotspots help you identify refactoring candidates
- ✅ Knowledge extraction surfaces reusable solutions
- ✅ Zero manual effort required (fully automatic)
- ✅ Search results are semantically relevant, not just keyword matches

## Future Enhancements

Potential additions (not currently implemented):

- **Cross-project analytics**: Aggregate insights across multiple projects
- **AI-powered summarization**: Use LLM to summarize conversation groups
- **Slack integration**: Post weekly insights to team channel
- **Git integration**: Correlate conversations with commits
- **Notion/Confluence export**: Publish reports to team wiki
- **VS Code extension**: Access insights without leaving editor

## Getting Started Checklist

- [ ] Install Python dependencies: `pip install -r requirements.txt`
- [ ] Run initial processing: Invoke skill with "Process my conversations"
- [ ] Test search: Ask "Find conversations about [topic]"
- [ ] Generate report: Ask "Generate weekly insights"
- [ ] (Optional) Install dashboard: `cd dashboard && npm install`
- [ ] (Optional) Launch dashboard: Ask "Start the insights dashboard"
- [ ] Set up regular reports: Schedule weekly insight generation

## Support

For issues, questions, or feature requests:
- Check `README.md` for detailed setup instructions
- Review script help: `python scripts/[script].py --help`
- Examine logs in `.processed/logs/`
- Verify project path is correct: Should match `~/.claude/projects/[encoded-path]/`

---

**Remember**: This skill is fully automatic. Just ask questions and generate insights—no manual data entry required!
