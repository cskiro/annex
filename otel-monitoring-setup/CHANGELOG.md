# Changelog - otel-monitoring-setup

All notable changes to the otel-monitoring-setup skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2025-11-02

### Added
- **Cleanup Script** (`templates/cleanup-telemetry.sh`) - Full cleanup utility that removes all containers, volumes, and data with confirmation prompt
- **Disk Space Documentation** - Added minimum 2GB free disk space requirement to prerequisites

### Changed
- **Loki Service** - Enabled Loki log storage by default (was previously commented out)
- **Docker Image Versions** - Pinned specific versions for stability:
  - OTEL Collector: `0.115.1`
  - Prometheus: `v2.55.1`
  - Grafana: `11.3.0`
  - Loki: `3.0.0`

### Fixed
- **Docker Compose** - Removed outdated comment about Loki exporter limitations now that Loki is fully integrated

## [1.0.1] - 2025-11-01

### Fixed
- **CRITICAL: OTEL Collector Loki Exporter** - Removed `otlphttp/loki` exporter which is not available in the standard OTEL Collector image and caused container crashes on startup
- **CRITICAL: Missing OTEL Exporters** - Added `OTEL_METRICS_EXPORTER` and `OTEL_LOGS_EXPORTER` to settings.json templates. These are REQUIRED for telemetry to work, and their absence caused silent failures where telemetry appeared enabled but no data was sent
- **CRITICAL: Deprecated Address Field** - Removed deprecated `address` field from `service.telemetry.metrics` section in OTEL Collector configuration that caused crashes in newer collector versions
- **Docker Compose Configuration** - Made Loki service optional (commented out by default) with clear documentation on how to enable log collection if needed
- **Grafana Datasources** - Removed Loki datasource from default configuration to prevent errors when Loki is not running

### Added
- **Pre-flight Check Script** (`templates/preflight-check.sh`) - Automated validation of all prerequisites before setup, including:
  - Docker installation and daemon status verification
  - Port availability checks (3000, 4317, 4318, 8889, 9090)
  - Disk space verification (5GB+ recommended)
  - settings.json validation and syntax checking
  - REQUIRED environment variable detection (OTEL_METRICS_EXPORTER, OTEL_LOGS_EXPORTER)
  - Configuration file validation (deprecated exporters, invalid fields)
- **Setup Verification Script** (`templates/verify-setup.sh`) - Post-installation validation that checks:
  - All container health and running status
  - Service connectivity (OTEL Collector ports, Prometheus, Grafana)
  - Data flow verification (OTEL → Prometheus → Grafana)
  - Claude Code metrics detection in Prometheus
  - settings.json configuration validation
  - Provides actionable troubleshooting steps for any failures

### Changed
- **OTEL Collector Configuration** - Updated template to use only `prometheus` and `debug` exporters for stable operation
- **Documentation** - Enhanced with critical configuration requirements and common pitfalls sections
- **mode1-poc-setup.md** - Added automated script references at key validation points
- **troubleshooting.md** - Added new sections for Loki exporter issues, missing OTEL exporters, and deprecated field errors
- **README.md** - Added "Common Pitfalls & Fixes" section with the three most critical issues users encountered

### Documentation Improvements
- Highlighted REQUIRED environment variables with clear warnings about silent failures
- Added step-by-step troubleshooting for the three most common setup issues
- Clarified that Loki log collection requires additional setup beyond the standard configuration
- Documented that Claude Code must be completely restarted (not just refreshed) for telemetry settings to take effect

### Root Cause Analysis
Based on user testing, the following issues were identified and resolved:
1. **Loki Exporter Not Available** - The `otlphttp/loki` exporter requires the Loki receiver to be compiled into the collector, which is not included in `otel/opentelemetry-collector-contrib:latest`
2. **Silent Telemetry Failure** - Claude Code respects `CLAUDE_CODE_ENABLE_TELEMETRY=1` but silently fails to send data if `OTEL_METRICS_EXPORTER` and `OTEL_LOGS_EXPORTER` are not explicitly set to `"otlp"`
3. **Deprecated Configuration Fields** - Newer OTEL Collector versions (v0.138.0+) deprecated several configuration fields that were present in earlier documentation

## [1.0.0] - 2025-11-01

### Added
- Initial release of OpenTelemetry monitoring setup skill
- **Mode 1: Local PoC Setup** - Full Docker stack with OTEL Collector, Prometheus, Loki, and Grafana
- **Mode 2: Enterprise Setup** - Connect to existing centralized infrastructure
- **Automated Configuration**: Environment variable setup for Claude Code telemetry
- **Dashboard Management**: Automatic Grafana dashboard import with datasource UID detection
- **Data Flow Verification**: Test queries and connectivity checks
- **Team Rollout Support**: Documentation and configuration templates
- **Docker Compose Templates**: Pre-configured stacks for quick deployment
- **Grafana Dashboard Templates**: Pre-built dashboards for Claude Code metrics
- **Troubleshooting Guides**: Common issues and solutions

### Features
- Docker-based deployment for easy setup and teardown
- OTEL Collector configuration for Claude Code metrics
- Prometheus for metrics storage and querying
- Loki for log aggregation
- Grafana for visualization with pre-built dashboards
- Automatic datasource UID detection and replacement
- Environment variable validation
- Health checks and verification scripts
- Support for both local development and enterprise deployments
- ~500MB disk space for Docker images and volumes
- ~1GB RAM for full stack operation

### Modes
- **Local PoC**: Complete observability stack for individual developers
- **Enterprise**: Connect to existing centralized infrastructure
- Quick decision matrix for mode selection
- Step-by-step workflows for each mode

### Documentation
- Comprehensive SKILL.md with setup instructions
- README with feature overview
- Mode-specific workflow documentation
- Template files for custom configurations
- Troubleshooting guides

### Requirements
- Docker 20.10.0 or higher
- Docker Compose 2.0.0 or higher
- ~500MB disk space for images and volumes
- ~1GB RAM for full stack operation

### Known Limitations
- Tested on 1-2 projects locally
- Dashboard customization requires Grafana knowledge
- OTEL Collector configuration requires understanding of telemetry concepts
- Enterprise mode requires existing infrastructure

## [Unreleased]

### Planned Features
- **Advanced Dashboards**: Additional metrics and visualizations
- **Cost Analysis**: Detailed cost tracking and attribution
- **Team Analytics**: Aggregate metrics across team members
- **Alert Rules**: Pre-configured alerting for common issues
- **Performance Profiling**: Deep-dive into Claude Code performance
- **Custom Metrics**: Support for user-defined metrics
- **Multi-Environment Support**: Dev, staging, production configurations
- **Cloud Provider Integration**: AWS, GCP, Azure deployment templates

### Under Consideration
- Integration with CI/CD pipelines
- Automated anomaly detection
- Historical trend analysis
- Capacity planning tools
- SLA monitoring and reporting
- Integration with incident management systems
- Kubernetes deployment templates
- Helm charts for easier deployment
