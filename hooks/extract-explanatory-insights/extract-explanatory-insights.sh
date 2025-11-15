#!/bin/bash
# extract-explanatory-insights.sh
# Extracts ★ Insight blocks from Claude Code responses and saves them to docs/lessons-learned
# Hook Type: PostToolUse (command-based)
# Trigger: After any Claude response
# Exit Codes: 0 (success), 1 (no insights found - silent), 2 (error - blocks execution)

set -euo pipefail

# Read hook input from stdin
INPUT=$(cat)

# Extract key variables from JSON input
PROJECT_DIR=$(echo "$INPUT" | jq -r '.cwd // empty')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')

# Validate required inputs
if [[ -z "$PROJECT_DIR" || -z "$TRANSCRIPT_PATH" ]]; then
    # Silent exit - no error for missing context
    exit 0
fi

# Skip if not in a project directory (e.g., global ~/.claude)
if [[ "$PROJECT_DIR" == "$HOME/.claude" ]]; then
    exit 0
fi

# Create lessons-learned directory structure
LESSONS_DIR="$PROJECT_DIR/docs/lessons-learned"
mkdir -p "$LESSONS_DIR"

# Read the last 200 lines from transcript (most recent content)
# This is simpler and more reliable than trying to extract assistant tags
LAST_RESPONSE=$(tail -n 200 "$TRANSCRIPT_PATH")

# Check if there's an insight block in the last response
if ! echo "$LAST_RESPONSE" | grep -q "★ Insight"; then
    # No insights found - silent exit
    exit 0
fi

# Extract all insight blocks from the last response
INSIGHTS=$(echo "$LAST_RESPONSE" | awk '
    /★ Insight ─+/ {
        in_insight = 1
        insight = ""
        next
    }
    /─+/ && in_insight {
        in_insight = 0
        if (insight != "") {
            print insight
            print "---INSIGHT_SEPARATOR---"
        }
        next
    }
    in_insight {
        insight = insight $0 "\n"
    }
')

# Exit if no insights extracted
if [[ -z "$INSIGHTS" ]]; then
    exit 0
fi

# Get current timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
DATE_SLUG=$(date '+%Y-%m-%d')

# Determine category from insight content (simple heuristic)
# This can be enhanced with more sophisticated categorization
categorize_insight() {
    local insight="$1"

    # Check for common patterns to auto-categorize
    if echo "$insight" | grep -iq "test\|testing\|coverage\|tdd\|vitest\|jest"; then
        echo "testing"
    elif echo "$insight" | grep -iq "config\|settings\|inheritance\|precedence"; then
        echo "configuration"
    elif echo "$insight" | grep -iq "hook\|lifecycle\|event\|trigger"; then
        echo "hooks-and-events"
    elif echo "$insight" | grep -iq "security\|vulnerability\|auth\|permission"; then
        echo "security"
    elif echo "$insight" | grep -iq "performance\|optimize\|cache\|memory"; then
        echo "performance"
    elif echo "$insight" | grep -iq "architecture\|design\|pattern\|structure"; then
        echo "architecture"
    elif echo "$insight" | grep -iq "git\|commit\|branch\|merge\|pr\|pull request"; then
        echo "version-control"
    elif echo "$insight" | grep -iq "react\|component\|tsx\|jsx\|hooks"; then
        echo "react"
    elif echo "$insight" | grep -iq "typescript\|type\|interface\|generic"; then
        echo "typescript"
    else
        echo "general"
    fi
}

# Process each insight
echo "$INSIGHTS" | while IFS= read -r line; do
    if [[ "$line" == "---INSIGHT_SEPARATOR---" ]]; then
        if [[ -n "${CURRENT_INSIGHT:-}" ]]; then
            # Categorize the insight
            CATEGORY=$(categorize_insight "$CURRENT_INSIGHT")
            CATEGORY_DIR="$LESSONS_DIR/$CATEGORY"
            mkdir -p "$CATEGORY_DIR"

            # Determine the output file (one file per category, continuously appended)
            OUTPUT_FILE="$CATEGORY_DIR/insights.md"

            # Extract the title (first line of insight)
            TITLE=$(echo "$CURRENT_INSIGHT" | head -n 1 | sed 's/^[*_[:space:]]*//' | sed 's/[*_[:space:]]*$//')

            # Create or append to the insights file
            if [[ ! -f "$OUTPUT_FILE" ]]; then
                # Create new file with header
                # Uppercase first letter (bash 3.2 compatible)
                CATEGORY_TITLE="$(echo "$CATEGORY" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')"
                cat > "$OUTPUT_FILE" <<EOF
# $CATEGORY_TITLE Insights

Auto-generated lessons learned from Claude Code Explanatory insights.

---

EOF
            fi

            # Append the new insight
            cat >> "$OUTPUT_FILE" <<EOF
## $TITLE

**Captured**: $TIMESTAMP
**Session**: $SESSION_ID

$CURRENT_INSIGHT

---

EOF
            # Clear for next insight
            CURRENT_INSIGHT=""
        fi
    else
        CURRENT_INSIGHT="${CURRENT_INSIGHT:-}${line}"$'\n'
    fi
done

# Create/update the index file
INDEX_FILE="$LESSONS_DIR/README.md"
cat > "$INDEX_FILE" <<'EOF'
# Lessons Learned Index

This directory contains auto-extracted insights from Claude Code sessions using the Explanatory output style.

## Directory Structure

```
docs/lessons-learned/
├── README.md (this file)
├── architecture/
│   └── insights.md
├── configuration/
│   └── insights.md
├── hooks-and-events/
│   └── insights.md
├── performance/
│   └── insights.md
├── react/
│   └── insights.md
├── security/
│   └── insights.md
├── testing/
│   └── insights.md
├── typescript/
│   └── insights.md
├── version-control/
│   └── insights.md
└── general/
    └── insights.md
```

## Categories

EOF

# List all categories with insight counts
for category_dir in "$LESSONS_DIR"/*/; do
    if [[ -d "$category_dir" && "$category_dir" != "$LESSONS_DIR/" ]]; then
        category=$(basename "$category_dir")
        insights_file="$category_dir/insights.md"

        if [[ -f "$insights_file" ]]; then
            # Count insights (each ## header is an insight)
            count=$(grep -c "^## " "$insights_file" || echo "0")
            last_updated=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$insights_file" 2>/dev/null || stat -c "%y" "$insights_file" 2>/dev/null | cut -d' ' -f1-2 || echo "Unknown")

            # Uppercase first letter (bash 3.2 compatible)
            category_title="$(echo "$category" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')"
            cat >> "$INDEX_FILE" <<EOF
### $category_title
- **Insights**: $count
- **Last Updated**: $last_updated
- **Path**: [\`$category/insights.md\`](./$category/insights.md)

EOF
        fi
    fi
done

cat >> "$INDEX_FILE" <<'EOF'

## Usage

Each category contains an `insights.md` file with chronologically ordered insights. Insights are automatically categorized based on content analysis.

### Manual Categorization

If you need to recategorize an insight:
1. Cut the insight from the current file
2. Paste it into the appropriate category file
3. The index will auto-update on the next extraction

### Searching

Use grep to search across all insights:
```bash
grep -r "your search term" docs/lessons-learned/
```

Or use ripgrep for faster searches:
```bash
rg "your search term" docs/lessons-learned/
```

---

*Auto-generated by extract-explanatory-insights.sh hook*
EOF

# Silent success - insights extracted
exit 0
