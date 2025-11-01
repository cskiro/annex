---
name: otel-monitoring-setup
version: 0.1.0
description: Automated OpenTelemetry setup for Claude Code with local PoC mode (full Docker stack with Grafana dashboards) and enterprise mode (connect to centralized infrastructure). Configures telemetry collection, verifies data flow, handles dashboard imports with datasource UID detection, and supports team rollout scenarios. Use for any OpenTelemetry setup task - local development, enterprise deployment, or team aggregation.
author: Connor
---

# OpenTelemetry Monitoring Setup Skill

Automated workflow for setting up OpenTelemetry telemetry collection for Claude Code usage monitoring, cost tracking, and productivity analytics.

**Supported Modes:**
- **Mode 1: Local PoC Setup** - Full Docker stack (OTEL Collector, Prometheus, Loki, Grafana)
- **Mode 2: Enterprise Setup** - Connect to existing centralized infrastructure

**Changelog:** Track updates and fixes in this skill
**Modes Reference:** See `modes/` directory for detailed workflows

---

## Response Style

- **Be systematic** - Follow mode workflow exactly
- **Verify prerequisites** - Check Docker, permissions, existing setup
- **Fix issues proactively** - Handle OTEL Collector config issues, dashboard UID mismatches
- **Test thoroughly** - Verify data flow, Prometheus queries, Grafana connectivity
- **Provide clear output** - Show URLs, credentials, next steps

---

## Quick Decision Matrix

| User Request | Mode | Action |
|--------------|------|--------|
| "Set up telemetry locally" | Mode 1 | Full PoC stack setup |
| "I want to try OpenTelemetry" | Mode 1 | Full PoC stack setup |
| "Connect to company OTEL endpoint" | Mode 2 | Enterprise config only |
| "Set up for team rollout" | Mode 2 | Enterprise + docs |
| "Dashboard not working" | Troubleshoot | Fix datasource UID |

---

## Mode 1: Local PoC Setup (Full Stack)

**Goal:** Create complete local telemetry stack for individual developer

**When to use:**
- Developer wants to try telemetry locally
- PoC/evaluation phase
- No centralized infrastructure exists yet
- Want to see full Grafana dashboards immediately

**Prerequisites:**
- Docker Desktop installed and running
- Claude Code installed
- Write access to ~/.claude/settings.json

**High-Level Process:**
1. Verify Docker is running
2. Create telemetry directory structure
3. Generate configuration files (docker-compose, OTEL Collector, Prometheus)
4. Start Docker containers
5. Update Claude Code settings.json
6. Import Grafana dashboards (with UID detection)
7. Verify data flow
8. Provide quickstart guide

**Full Workflow:** See `modes/mode1-poc-setup.md`

**Estimated Time:** 5-7 minutes

**Output:**
- Running Docker containers (OTEL Collector, Prometheus, Loki, Grafana)
- Grafana dashboards at http://localhost:3000 (admin/admin)
- Claude Code sending telemetry data
- Verification tests passed

---

## Mode 2: Enterprise Setup (Connect to Existing)

**Goal:** Configure Claude Code to send telemetry to centralized company infrastructure

**When to use:**
- Company has centralized OTEL Collector endpoint
- Team rollout scenario
- Want aggregated team metrics
- Privacy/compliance requires centralized control

**Prerequisites:**
- OTEL Collector endpoint URL (e.g., https://otel.company.com:4317)
- Authentication credentials (API key or mTLS certificates)
- Optional: Team/department identifiers

**High-Level Process:**
1. Collect endpoint information from user
2. Update Claude Code settings.json with OTEL endpoint
3. Add authentication headers if required
4. Add custom resource attributes (team, environment)
5. Test connectivity
6. Provide team rollout documentation

**Full Workflow:** See `modes/mode2-enterprise.md`

**Estimated Time:** 2-3 minutes

**Output:**
- Claude Code configured to send to central endpoint
- Connectivity verified
- Team rollout documentation provided

---

## Mode Detection Logic

**Automatic detection based on user request:**

```
IF user says "locally" OR "on my machine" OR "PoC" OR "try it out"
  → Mode 1 (Local PoC Setup)

ELSE IF user mentions "company endpoint" OR "centralized" OR "team" OR "enterprise"
  → Mode 2 (Enterprise Setup)

ELSE IF unsure
  → Ask: "Do you want to set up locally (Mode 1) or connect to existing infrastructure (Mode 2)?"
```

**Priority:**
1. Explicit user specification (highest)
2. Keyword detection
3. Ask user if ambiguous

---

## Core Responsibilities

### 1. **Docker Environment Verification**
- Check Docker installation and running status
- Verify Docker Compose availability
- Ensure sufficient disk space
- Handle Docker Desktop not running error

### 2. **Configuration File Generation**
- Create docker-compose.yml with correct services
- Generate OTEL Collector config with **debug** exporter (not deprecated logging)
- Set up Prometheus scrape configuration
- Configure Grafana datasources
- Create start/stop scripts

### 3. **Claude Code Settings Management**
- Read existing ~/.claude/settings.json
- Merge telemetry environment variables
- Handle different configuration scenarios (local vs enterprise)
- Preserve existing settings

### 4. **Container Management**
- Start Docker containers in correct order
- Wait for services to become healthy
- Handle port conflicts
- Monitor container status

### 5. **Grafana Dashboard Import**
- Detect Grafana Prometheus datasource UID
- Fix dashboard JSON with correct UID
- Handle metric name variations (double prefix issue)
- Import dashboards via API or provide instructions

### 6. **Data Flow Verification**
- Test OTEL Collector connectivity
- Query Prometheus for claude_code metrics
- Verify Grafana datasource configuration
- Run sample queries

### 7. **Troubleshooting & Error Handling**
- Fix deprecated OTEL Collector exporters
- Handle datasource UID mismatches
- Resolve metric naming issues
- Guide through common errors

---

## Known Issues & Fixes

### Issue 1: OTEL Collector Deprecated Exporter
**Problem:** OTEL Collector fails with "logging exporter has been deprecated"

**Fix:** Use `debug` exporter instead:
```yaml
exporters:
  debug:
    verbosity: normal
```

### Issue 2: Dashboard Datasource Not Found
**Problem:** Grafana dashboard shows "datasource prometheus not found"

**Fix:**
1. Detect actual Prometheus datasource UID
2. Replace all `"uid": "prometheus"` with detected UID
3. Re-import dashboard

### Issue 3: Metric Names Double Prefix
**Problem:** Queries fail because metrics have format `claude_code_claude_code_*`

**Fix:** Update all dashboard queries to use correct naming:
- `claude_code_claude_code_lines_of_code_count_total`
- `claude_code_claude_code_cost_usage_USD_total`
- `claude_code_claude_code_token_usage_tokens_total`
- `claude_code_claude_code_active_time_seconds_total`
- `claude_code_claude_code_commit_count_total`

### Issue 4: No Data in Prometheus
**Solutions:**
- Verify OTEL Collector is running and healthy
- Check Claude Code was restarted after settings.json update
- Confirm OTEL_EXPORTER_OTLP_ENDPOINT is correct
- Check OTEL Collector logs for incoming data

---

## Safety Protocols

### Pre-Setup Checks
- ✅ Backup ~/.claude/settings.json before modification
- ✅ Check for existing telemetry setup (avoid conflicts)
- ✅ Verify Docker is running before starting containers
- ✅ Check ports 3000, 4317, 4318, 8889, 9090 are available

### During Setup
- ✅ Create files with proper permissions
- ✅ Use docker compose (not deprecated docker-compose)
- ✅ Wait for container health checks
- ✅ Validate configuration files before use

### Post-Setup
- ✅ Test data flow before declaring success
- ✅ Provide cleanup instructions
- ✅ Document URLs and credentials
- ✅ Offer to create quickstart guide

---

## Example Interactions

### Example 1: Local PoC Setup Request

**User:** "I want to set up telemetry locally to see my Claude Code usage"

**Assistant:** "I'll set up a complete local telemetry stack for you using Mode 1. This will create:
- OpenTelemetry Collector (receives data from Claude Code)
- Prometheus (stores metrics)
- Loki (stores logs)
- Grafana (visualization dashboards)

Let me verify prerequisites first..."

*[Checks Docker status, disk space]*

**Assistant:** "✅ Docker is running. Creating telemetry stack in ~/.claude/telemetry/..."

*[Creates directory structure, generates config files, starts containers]*

**Assistant:** "✅ All containers running! Now updating your Claude Code settings..."

*[Updates settings.json with telemetry config]*

**Assistant:** "✅ Settings updated. Now let me import Grafana dashboards..."

*[Detects datasource UID, fixes dashboard JSON, imports]*

**Assistant:** "✅ Dashboard imported! Let me verify data is flowing..."

*[Runs test queries]*

**Assistant:** "✅ Setup complete!

**Access Grafana:** http://localhost:3000 (admin/admin)

**What's being collected:**
- Session counts and active time
- Token usage (input/output/cached)
- API costs by model
- Lines of code modified
- Commits and PRs created

**Next:** Use Claude Code normally - data will appear in ~60 seconds. Check your dashboard!

**Management:**
- Start: ~/.claude/telemetry/start-telemetry.sh
- Stop: ~/.claude/telemetry/stop-telemetry.sh"

---

### Example 2: Enterprise Setup Request

**User:** "I need to connect to our company's OTEL endpoint at otel.company.com:4317"

**Assistant:** "I'll configure Claude Code to send telemetry to your centralized infrastructure using Mode 2. I need a few details:

1. **Endpoint:** otel.company.com:4317 ✓
2. **Protocol:** HTTPS or HTTP?
3. **Authentication:** Do you have an API key or certificate?
4. **Team identifier:** What team/department should metrics be tagged with?"

**User:** "HTTPS, we have an API key, tag it with team=platform"

**Assistant:** "Perfect! Let me configure your settings..."

*[Updates settings.json with enterprise config]*

**Assistant:** "✅ Configuration updated:

```json
"env": {
  "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
  "OTEL_EXPORTER_OTLP_ENDPOINT": "https://otel.company.com:4317",
  "OTEL_EXPORTER_OTLP_HEADERS": "Authorization=Bearer [your-key]",
  "OTEL_RESOURCE_ATTRIBUTES": "team=platform,environment=production"
}
```

**Important:** You need to restart Claude Code for this to take effect.

**To verify:** After restart, check with your platform team that they see metrics tagged with `team=platform`."

---

### Example 3: Dashboard Not Working

**User:** "My Grafana dashboard shows 'datasource prometheus not found'"

**Assistant:** "This is a common issue - the dashboard has a hardcoded datasource UID that doesn't match yours. Let me fix it:

1. First, I'll detect your actual Prometheus datasource UID..."

*[Queries Grafana API or asks user to check]*

**Assistant:** "Found it: Your datasource UID is `PBFA97CFB590B2093`

2. Now I'll update the dashboard JSON with the correct UID..."

*[Reads dashboard JSON, replaces all UID references, saves new version]*

**Assistant:** "✅ Fixed dashboard saved to: ~/.claude/telemetry/dashboards/claude-code-overview-corrected.json

**To import:**
1. Go to Grafana: http://localhost:3000
2. Dashboards → New → Import
3. Upload: claude-code-overview-corrected.json
4. Click Import

This should work now!"

---

### Example 4: No Metrics Showing

**User:** "Dashboard imported but shows 'No data'"

**Assistant:** "Let me troubleshoot data flow:

**Check 1:** Are containers running?"

*[Runs docker ps check]*

**Assistant:** "✅ All containers running

**Check 2:** Is OTEL Collector receiving data?"

*[Checks OTEL Collector logs]*

**Assistant:** "✅ OTEL Collector is receiving telemetry

**Check 3:** Let me query Prometheus directly..."

*[Runs curl to Prometheus API]*

**Assistant:** "Found the issue! Your metrics use a double prefix: `claude_code_claude_code_*` instead of `claude_code_*`

The dashboard queries need to be updated. Let me fix that..."

*[Creates corrected dashboard with proper metric names]*

**Assistant:** "✅ Fixed! Import this new dashboard: claude-code-overview-fixed-v2.json

It uses the correct metric names:
- `claude_code_claude_code_lines_of_code_count_total`
- `claude_code_claude_code_cost_usage_USD_total`
- etc.

Data should appear immediately after import!"

---

## Integration Points

### With skill-creator
- This skill can be invoked during development to set up telemetry for skill testing
- Useful for monitoring skill execution costs

### With Other Skills
- Can monitor execution time and cost of other skills
- Helps identify expensive operations
- Provides productivity metrics for skill effectiveness

### With MCP Servers
- Can integrate with monitoring MCP servers if available
- Complements existing observability tools

---

## Success Metrics

### Mode 1 (Local PoC) Success Criteria:
- ✅ All 4 containers running (OTEL, Prometheus, Loki, Grafana)
- ✅ Grafana accessible at localhost:3000
- ✅ Dashboard imported successfully
- ✅ At least one Claude Code metric visible in Prometheus
- ✅ Dashboard shows data (even if just current session)
- ✅ User can access quickstart documentation

### Mode 2 (Enterprise) Success Criteria:
- ✅ settings.json updated with correct endpoint
- ✅ Authentication configured
- ✅ Resource attributes set (team, environment)
- ✅ Connectivity test passed (if possible)
- ✅ Team rollout documentation provided

---

## Important Reminders

- **Always backup settings.json** before modifications - Data loss prevention
- **Always use debug exporter** not logging exporter - OTEL Collector compatibility
- **Always detect datasource UID** before importing dashboards - Prevents "datasource not found" errors
- **Always verify metric names** - Handle double prefix issue (`claude_code_claude_code_*`)
- **Always restart Claude Code** after settings changes - Telemetry only loads at startup
- **Always test data flow** before declaring success - Ensure metrics are actually flowing
- **Never skip Docker verification** - Prevents confusing errors downstream
- **Never guess metric names** - Query Prometheus API to verify actual naming
- **Never leave broken dashboards** - Always provide working dashboard version
- **Always provide management scripts** - Users need start/stop capabilities

---

## Resources

- **Mode 1 Workflow:** `modes/mode1-poc-setup.md` - Detailed local setup process
- **Mode 2 Workflow:** `modes/mode2-enterprise.md` - Enterprise configuration steps
- **Templates:** `templates/` directory - All configuration file templates
- **Dashboards:** `dashboards/` directory - Grafana dashboard templates
- **Metrics Reference:** `data/metrics-reference.md` - Official Claude Code metrics documentation
- **Troubleshooting:** `data/troubleshooting.md` - Common issues and solutions
- **Enterprise Guide:** `data/enterprise-config-guide.md` - Team rollout and aggregation
- **PromQL Queries:** `data/prometheus-queries.md` - Useful monitoring queries

---

**Ready to set up OpenTelemetry for Claude Code! 🚀**
