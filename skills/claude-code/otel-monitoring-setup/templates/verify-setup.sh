#!/bin/bash
# Setup verification script for Claude Code OpenTelemetry
# Run this after setup to verify the telemetry stack is working correctly

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
BOLD='\033[1m'

echo -e "${BOLD}🔬 Claude Code OpenTelemetry Setup Verification${NC}\n"

ERRORS=0
WARNINGS=0
INFO_COUNT=0

# Function to print status
print_status() {
    local status=$1
    local message=$2
    if [ "$status" == "OK" ]; then
        echo -e "${GREEN}✓${NC} $message"
    elif [ "$status" == "WARN" ]; then
        echo -e "${YELLOW}⚠${NC} $message"
        ((WARNINGS++))
    elif [ "$status" == "INFO" ]; then
        echo -e "${BLUE}ℹ${NC} $message"
        ((INFO_COUNT++))
    else
        echo -e "${RED}✗${NC} $message"
        ((ERRORS++))
    fi
}

echo -e "${BOLD}1. Container Status${NC}"

# Check if containers are running
CONTAINERS=("claude-otel-collector" "claude-prometheus" "claude-grafana")
CONTAINER_PORTS=("4317" "9090" "3000")
CONTAINER_NAMES=("OTEL Collector" "Prometheus" "Grafana")

for i in "${!CONTAINERS[@]}"; do
    CONTAINER=${CONTAINERS[$i]}
    PORT=${CONTAINER_PORTS[$i]}
    NAME=${CONTAINER_NAMES[$i]}

    if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
        STATUS=$(docker ps --filter "name=${CONTAINER}" --format '{{.Status}}')
        if [[ $STATUS == *"Up"* ]]; then
            print_status "OK" "$NAME is running ($STATUS)"
        else
            print_status "ERROR" "$NAME container exists but is not running: $STATUS"
        fi
    else
        print_status "ERROR" "$NAME container not found"
    fi
done

echo ""
echo -e "${BOLD}2. Service Health Checks${NC}"

# Check OTEL Collector
if docker logs claude-otel-collector --tail 10 2>&1 | grep -qi "error"; then
    ERROR_MSG=$(docker logs claude-otel-collector --tail 20 2>&1 | grep -i "error" | head -3)
    print_status "ERROR" "OTEL Collector has errors in logs:"
    echo -e "         ${RED}${ERROR_MSG}${NC}"
else
    print_status "OK" "OTEL Collector logs show no errors"
fi

# Check OTEL Collector is receiving on expected ports
if nc -z localhost 4317 2>/dev/null; then
    print_status "OK" "OTEL Collector gRPC port (4317) is accessible"
else
    print_status "ERROR" "OTEL Collector gRPC port (4317) is not accessible"
fi

if nc -z localhost 4318 2>/dev/null; then
    print_status "OK" "OTEL Collector HTTP port (4318) is accessible"
else
    print_status "ERROR" "OTEL Collector HTTP port (4318) is not accessible"
fi

# Check Prometheus health
if curl -sf http://localhost:9090/-/healthy > /dev/null 2>&1; then
    print_status "OK" "Prometheus is healthy"
else
    print_status "ERROR" "Prometheus health check failed"
fi

# Check Grafana health
if curl -sf http://localhost:3000/api/health > /dev/null 2>&1; then
    print_status "OK" "Grafana is healthy"
else
    print_status "ERROR" "Grafana health check failed"
fi

echo ""
echo -e "${BOLD}3. Data Flow Verification${NC}"

# Check if OTEL Collector is scraping metrics
METRICS_RESPONSE=$(curl -s http://localhost:8889/metrics)
if [ -n "$METRICS_RESPONSE" ]; then
    print_status "OK" "OTEL Collector metrics endpoint responding"
else
    print_status "ERROR" "OTEL Collector metrics endpoint not responding"
fi

# Check if Prometheus is scraping OTEL Collector
PROM_TARGETS=$(curl -s http://localhost:9090/api/v1/targets 2>/dev/null)
if echo "$PROM_TARGETS" | grep -q "otel-collector"; then
    if echo "$PROM_TARGETS" | grep -q '"health":"up"'; then
        print_status "OK" "Prometheus is scraping OTEL Collector successfully"
    else
        print_status "WARN" "Prometheus has OTEL Collector target but it's not healthy"
    fi
else
    print_status "ERROR" "Prometheus is not configured to scrape OTEL Collector"
fi

# Check for Claude Code metrics in Prometheus
CLAUDE_METRICS=$(curl -s "http://localhost:9090/api/v1/label/__name__/values" 2>/dev/null | jq -r '.data[]' 2>/dev/null | grep claude_code || true)
if [ -n "$CLAUDE_METRICS" ]; then
    METRIC_COUNT=$(echo "$CLAUDE_METRICS" | wc -l | tr -d ' ')
    print_status "OK" "Claude Code metrics detected in Prometheus ($METRIC_COUNT metrics)"
    echo -e "         ${GREEN}Sample metrics:${NC}"
    echo "$CLAUDE_METRICS" | head -3 | while read line; do
        echo "         • $line"
    done
else
    print_status "INFO" "No Claude Code metrics yet (this is normal if you haven't restarted Claude Code)"
    echo -e "         ${BLUE}Claude Code must be restarted for telemetry to start sending data${NC}"
fi

echo ""
echo -e "${BOLD}4. Grafana Configuration${NC}"

# Check Grafana datasources
GRAFANA_DS=$(curl -s http://admin:admin@localhost:3000/api/datasources 2>/dev/null)
if echo "$GRAFANA_DS" | grep -q "prometheus"; then
    DS_UID=$(echo "$GRAFANA_DS" | jq -r '.[] | select(.type=="prometheus") | .uid' 2>/dev/null)
    print_status "OK" "Prometheus datasource configured (UID: $DS_UID)"
else
    print_status "ERROR" "Prometheus datasource not configured in Grafana"
fi

# Check if Grafana can query Prometheus
GRAFANA_QUERY=$(curl -s "http://admin:admin@localhost:3000/api/datasources/proxy/1/api/v1/query?query=up" 2>/dev/null)
if echo "$GRAFANA_QUERY" | grep -q '"status":"success"'; then
    print_status "OK" "Grafana can query Prometheus successfully"
else
    print_status "WARN" "Grafana cannot query Prometheus (datasource may need configuration)"
fi

echo ""
echo -e "${BOLD}5. Claude Code Configuration${NC}"

# Check settings.json
if [ -f ~/.claude/settings.json ]; then
    # Check telemetry enabled
    if jq -e '.env.CLAUDE_CODE_ENABLE_TELEMETRY == "1"' ~/.claude/settings.json &>/dev/null; then
        print_status "OK" "Claude Code telemetry is enabled"
    else
        print_status "ERROR" "Claude Code telemetry is not enabled in settings.json"
    fi

    # Check critical OTEL exporters
    if jq -e '.env.OTEL_METRICS_EXPORTER == "otlp"' ~/.claude/settings.json &>/dev/null; then
        print_status "OK" "OTEL_METRICS_EXPORTER configured correctly"
    else
        print_status "ERROR" "OTEL_METRICS_EXPORTER missing or incorrect (must be 'otlp')"
    fi

    if jq -e '.env.OTEL_LOGS_EXPORTER == "otlp"' ~/.claude/settings.json &>/dev/null; then
        print_status "OK" "OTEL_LOGS_EXPORTER configured correctly"
    else
        print_status "ERROR" "OTEL_LOGS_EXPORTER missing or incorrect (must be 'otlp')"
    fi

    # Check endpoint
    ENDPOINT=$(jq -r '.env.OTEL_EXPORTER_OTLP_ENDPOINT' ~/.claude/settings.json 2>/dev/null)
    if [ "$ENDPOINT" == "http://localhost:4317" ]; then
        print_status "OK" "OTEL endpoint points to local collector"
    elif [ -n "$ENDPOINT" ]; then
        print_status "INFO" "OTEL endpoint configured: $ENDPOINT"
    else
        print_status "ERROR" "OTEL_EXPORTER_OTLP_ENDPOINT not configured"
    fi
else
    print_status "ERROR" "settings.json not found at ~/.claude/settings.json"
fi

echo ""
echo -e "${BOLD}═══════════════════════════════════════════════${NC}"

# Summary
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed! Telemetry stack is working correctly.${NC}\n"

    if [ $INFO_COUNT -gt 0 ]; then
        echo -e "${BLUE}ℹ Note: No Claude Code metrics detected yet.${NC}"
        echo -e "${BLUE}This is normal if you haven't restarted Claude Code after setup.${NC}\n"
        echo -e "${BOLD}Next Steps:${NC}"
        echo "1. Restart Claude Code (required for telemetry to activate)"
        echo "2. Use Claude Code normally for 1-2 minutes"
        echo "3. Wait 60 seconds for metrics to be exported"
        echo "4. Run this script again to verify metrics are flowing"
        echo "5. Access Grafana dashboard: http://localhost:3000 (admin/admin)"
    else
        echo -e "${BOLD}Access Your Dashboards:${NC}"
        echo "• Grafana: http://localhost:3000 (admin/admin)"
        echo "• Prometheus: http://localhost:9090"
        echo "• OTEL Metrics: http://localhost:8889/metrics"
    fi

    exit 0

elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ Setup mostly working, but $WARNINGS warning(s) found.${NC}"
    echo -e "Review warnings above and check documentation.\n"
    exit 0

else
    echo -e "${RED}✗ Setup verification failed with $ERRORS error(s).${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠ Also found $WARNINGS warning(s).${NC}"
    fi

    echo ""
    echo -e "${BOLD}Troubleshooting Steps:${NC}"
    echo "1. Check container logs: docker logs claude-otel-collector"
    echo "2. Verify all containers are running: docker ps"
    echo "3. Review settings.json has all required OTEL variables"
    echo "4. Check ~/.claude/telemetry/otel-collector-config.yml for errors"
    echo "5. See troubleshooting guide: data/troubleshooting.md"
    echo ""
    echo "To restart the stack:"
    echo "  cd ~/.claude/telemetry && docker compose restart"

    exit 1
fi
