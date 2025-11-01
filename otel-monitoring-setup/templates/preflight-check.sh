#!/bin/bash
# Pre-flight check script for Claude Code OpenTelemetry setup
# Run this before starting the telemetry stack to catch configuration issues early

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

echo -e "${BOLD}🔍 Claude Code OpenTelemetry Pre-flight Check${NC}\n"

ERRORS=0
WARNINGS=0

# Function to print status
print_check() {
    local status=$1
    local message=$2
    if [ "$status" == "OK" ]; then
        echo -e "${GREEN}✓${NC} $message"
    elif [ "$status" == "WARN" ]; then
        echo -e "${YELLOW}⚠${NC} $message"
        ((WARNINGS++))
    else
        echo -e "${RED}✗${NC} $message"
        ((ERRORS++))
    fi
}

echo -e "${BOLD}1. Docker Prerequisites${NC}"

# Check if Docker is installed
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version | cut -d ' ' -f3 | cut -d ',' -f1)
    print_check "OK" "Docker installed (version $DOCKER_VERSION)"
else
    print_check "ERROR" "Docker not installed. Install from: https://docs.docker.com/get-docker/"
fi

# Check if Docker daemon is running
if docker info &> /dev/null; then
    print_check "OK" "Docker daemon is running"
else
    print_check "ERROR" "Docker daemon not running. Start Docker Desktop."
fi

# Check Docker Compose
if docker compose version &> /dev/null; then
    COMPOSE_VERSION=$(docker compose version --short)
    print_check "OK" "Docker Compose available (version $COMPOSE_VERSION)"
else
    print_check "ERROR" "Docker Compose not available. Update Docker to latest version."
fi

echo ""
echo -e "${BOLD}2. Port Availability${NC}"

# Check required ports
REQUIRED_PORTS=(3000 4317 4318 8889 9090)
PORT_NAMES=("Grafana" "OTEL-gRPC" "OTEL-HTTP" "OTEL-Prom" "Prometheus")

for i in "${!REQUIRED_PORTS[@]}"; do
    PORT=${REQUIRED_PORTS[$i]}
    NAME=${PORT_NAMES[$i]}
    if lsof -Pi :$PORT -sTCP:LISTEN -t &> /dev/null; then
        print_check "WARN" "Port $PORT ($NAME) is in use"
    else
        print_check "OK" "Port $PORT ($NAME) available"
    fi
done

echo ""
echo -e "${BOLD}3. Disk Space${NC}"

# Check available disk space
AVAILABLE_GB=$(df -h ~ | awk 'NR==2 {print $4}' | sed 's/G.*//')
if [ -z "$AVAILABLE_GB" ]; then
    # macOS uses different format
    AVAILABLE_GB=$(df -h ~ | awk 'NR==2 {print $4}' | sed 's/Gi.*//')
fi

if [ "$AVAILABLE_GB" -gt 5 ] 2>/dev/null; then
    print_check "OK" "Sufficient disk space (${AVAILABLE_GB}GB available)"
elif [ "$AVAILABLE_GB" -gt 2 ] 2>/dev/null; then
    print_check "WARN" "Low disk space (${AVAILABLE_GB}GB available, recommend 5GB+)"
else
    print_check "ERROR" "Insufficient disk space (${AVAILABLE_GB}GB available, need 5GB+)"
fi

echo ""
echo -e "${BOLD}4. Claude Code Settings${NC}"

# Check if settings.json exists
if [ -f ~/.claude/settings.json ]; then
    print_check "OK" "settings.json exists"

    # Validate JSON syntax
    if jq empty ~/.claude/settings.json 2>/dev/null; then
        print_check "OK" "settings.json is valid JSON"
    else
        print_check "ERROR" "settings.json has invalid JSON syntax"
    fi

    # Check for required telemetry variables
    if jq -e '.env.CLAUDE_CODE_ENABLE_TELEMETRY' ~/.claude/settings.json &>/dev/null; then
        VALUE=$(jq -r '.env.CLAUDE_CODE_ENABLE_TELEMETRY' ~/.claude/settings.json)
        if [ "$VALUE" == "1" ]; then
            print_check "OK" "CLAUDE_CODE_ENABLE_TELEMETRY is enabled"
        else
            print_check "WARN" "CLAUDE_CODE_ENABLE_TELEMETRY is set to '$VALUE' (should be '1')"
        fi
    else
        print_check "ERROR" "Missing CLAUDE_CODE_ENABLE_TELEMETRY in settings.json"
    fi

    # Check OTEL_METRICS_EXPORTER (CRITICAL)
    if jq -e '.env.OTEL_METRICS_EXPORTER' ~/.claude/settings.json &>/dev/null; then
        VALUE=$(jq -r '.env.OTEL_METRICS_EXPORTER' ~/.claude/settings.json)
        if [ "$VALUE" == "otlp" ]; then
            print_check "OK" "OTEL_METRICS_EXPORTER is set correctly"
        else
            print_check "ERROR" "OTEL_METRICS_EXPORTER is '$VALUE' (must be 'otlp')"
        fi
    else
        print_check "ERROR" "Missing OTEL_METRICS_EXPORTER (REQUIRED for metrics)"
    fi

    # Check OTEL_LOGS_EXPORTER (CRITICAL)
    if jq -e '.env.OTEL_LOGS_EXPORTER' ~/.claude/settings.json &>/dev/null; then
        VALUE=$(jq -r '.env.OTEL_LOGS_EXPORTER' ~/.claude/settings.json)
        if [ "$VALUE" == "otlp" ]; then
            print_check "OK" "OTEL_LOGS_EXPORTER is set correctly"
        else
            print_check "WARN" "OTEL_LOGS_EXPORTER is '$VALUE' (should be 'otlp')"
        fi
    else
        print_check "ERROR" "Missing OTEL_LOGS_EXPORTER (REQUIRED for logs)"
    fi

    # Check OTEL endpoint
    if jq -e '.env.OTEL_EXPORTER_OTLP_ENDPOINT' ~/.claude/settings.json &>/dev/null; then
        ENDPOINT=$(jq -r '.env.OTEL_EXPORTER_OTLP_ENDPOINT' ~/.claude/settings.json)
        print_check "OK" "OTEL endpoint configured: $ENDPOINT"
    else
        print_check "ERROR" "Missing OTEL_EXPORTER_OTLP_ENDPOINT in settings.json"
    fi

else
    print_check "ERROR" "settings.json not found at ~/.claude/settings.json"
fi

echo ""
echo -e "${BOLD}5. Configuration Files${NC}"

# Check if we're in the telemetry directory or need to check templates
if [ -f "docker-compose.yml" ]; then
    print_check "OK" "docker-compose.yml found"
else
    print_check "WARN" "docker-compose.yml not found (will be created during setup)"
fi

if [ -f "otel-collector-config.yml" ]; then
    print_check "OK" "otel-collector-config.yml found"

    # Check for deprecated Loki exporter
    if grep -q "otlphttp/loki" otel-collector-config.yml; then
        print_check "ERROR" "otel-collector-config.yml contains deprecated 'otlphttp/loki' exporter"
        echo -e "         ${YELLOW}This will cause the OTEL Collector to crash.${NC}"
        echo -e "         ${YELLOW}Remove the Loki exporter or use Promtail/Alloy instead.${NC}"
    fi

    # Check for deprecated logging exporter
    if grep -q "logging:" otel-collector-config.yml; then
        print_check "WARN" "otel-collector-config.yml uses deprecated 'logging' exporter (use 'debug' instead)"
    fi

    # Check for deprecated address field
    if grep -q "address:" otel-collector-config.yml | grep -q "telemetry:"; then
        print_check "ERROR" "otel-collector-config.yml contains deprecated 'address' field in telemetry section"
        echo -e "         ${YELLOW}Remove the 'address' field from service.telemetry.metrics${NC}"
    fi
else
    print_check "WARN" "otel-collector-config.yml not found (will be created during setup)"
fi

echo ""
echo -e "${BOLD}═══════════════════════════════════════════════${NC}"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed! Ready to start setup.${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ $WARNINGS warning(s) found. Setup may proceed but review warnings.${NC}"
    exit 0
else
    echo -e "${RED}✗ $ERRORS error(s) found. Fix these before proceeding.${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠ $WARNINGS warning(s) also found.${NC}"
    fi
    echo ""
    echo -e "${BOLD}Common Fixes:${NC}"
    echo "• Install Docker: https://docs.docker.com/get-docker/"
    echo "• Start Docker Desktop and wait for it to fully initialize"
    echo "• Add required OTEL variables to ~/.claude/settings.json"
    echo "• Free up disk space (need 5GB+)"
    echo "• Stop services using required ports"
    exit 1
fi
