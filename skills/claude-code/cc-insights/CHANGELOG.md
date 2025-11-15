# Changelog - cc-insights

All notable changes to the cc-insights skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0-beta] - 2025-10-26

### Added
- Initial beta release of RAG-powered conversation analysis system
- **Automatic Processing**: Scans `~/.claude/conversations/` and indexes all `.jsonl` conversation files
- **RAG-Powered Semantic Search**: Uses sentence-transformers for embedding generation and ChromaDB for vector storage
- **Keyword Search**: Fast SQLite-based metadata search for exact matches
- **Hybrid Search**: Combines semantic similarity with keyword filtering for precise results
- **Insight Report Generation**: Jinja2-templated reports with customizable formats
- **Activity Timeline**: Chronological view of development patterns
- **File Hotspot Analysis**: Identifies frequently modified files and patterns
- **Tool Usage Analytics**: Tracks which Claude Code tools are used most
- **Pattern Detection**: Discovers recurring development workflows
- **Zero Manual Effort**: Fully automatic processing of existing conversations
- **Incremental Updates**: Only processes new/modified conversations on subsequent runs
- **Rich Search Results**: Returns ranked matches with context snippets

### Features
- SQLite for fast metadata queries and conversation storage
- ChromaDB for vector similarity search
- sentence-transformers for state-of-the-art embeddings (all-MiniLM-L6-v2 model)
- Jinja2 templating for flexible report generation
- Click-based CLI for user-friendly commands
- Python 3.8+ compatibility
- ~500MB disk space for 1,000 conversations
- ~2GB RAM for embedding generation

### Commands
- `conversation-processor.py`: Parse and store conversation metadata
- `rag_indexer.py`: Generate embeddings and build vector index
- `search-conversations.py`: Perform semantic/keyword/hybrid searches
- `insight-generator.py`: Create weekly summary reports

### Known Limitations
- Tested on 1-2 projects only (proof of concept phase)
- Processing time scales with conversation count (~1-2 min per 1,000 conversations)
- Embedding generation requires 2GB RAM (can be reduced with smaller models)
- Search quality depends on conversation content richness
- Report templates are basic (limited customization)
- No incremental embedding updates (full reindex required for now)

### Documentation
- Comprehensive SKILL.md with usage instructions
- README with detailed feature descriptions
- Requirements file with Python dependencies
- Template examples for custom reports
- CLI help for all commands

### Requirements
- Python 3.8 or higher
- sentence-transformers (~1.5GB model download on first run)
- chromadb
- jinja2
- click
- python-dateutil
- ~500MB disk space for typical usage
- ~2GB RAM for embedding generation

## [Unreleased]

### Planned Features
- **Dashboard UI**: Interactive web interface for browsing conversations and insights
- **Real-time Indexing**: Watch mode for automatic indexing of new conversations
- **Advanced Analytics**: Success rate tracking, error pattern analysis, tool effectiveness metrics
- **Custom Embeddings**: Support for different embedding models (OpenAI, Cohere, etc.)
- **Export Formats**: CSV, JSON, PDF report generation
- **Team Analytics**: Aggregate insights across team members
- **Time-based Filters**: Search within date ranges
- **Conversation Replay**: Step-through visualization of past conversations
- **Recommendation Engine**: Suggest relevant past solutions for current problems

### Under Consideration
- Integration with external knowledge bases (Confluence, Notion)
- Multi-project correlation analysis
- LLM-powered insight generation (GPT-4 summaries)
- Conversation quality scoring
- Predictive analytics (suggest next steps)
- Version control integration (link conversations to commits)
- Privacy mode (exclude sensitive conversations)
- Cloud sync for team collaboration
