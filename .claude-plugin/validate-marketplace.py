#!/usr/bin/env python3
"""
Marketplace Validation Script for claudex

Validates the marketplace.json file and plugin integrity for Claude Code plugin marketplace.
Ensures all required fields are present, plugins are correctly structured, and references are valid.

Usage:
    python3 .claude-plugin/validate-marketplace.py

Exit Codes:
    0 - All validations passed
    1 - Validation errors found
"""

import json
import sys
from pathlib import Path
from typing import Dict, List, Tuple

# ANSI color codes for terminal output
class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    RESET = '\033[0m'
    BOLD = '\033[1m'

class MarketplaceValidator:
    def __init__(self, repo_root: Path):
        self.repo_root = repo_root
        self.marketplace_path = repo_root / ".claude-plugin" / "marketplace.json"
        self.errors: List[str] = []
        self.warnings: List[str] = []
        self.info: List[str] = []

    def validate(self) -> bool:
        """Run all validations and return True if successful."""
        print(f"{Colors.BOLD}🔍 Validating claudex marketplace...{Colors.RESET}\n")

        # Check marketplace.json exists
        if not self.marketplace_path.exists():
            self.errors.append(f"marketplace.json not found at {self.marketplace_path}")
            return False

        # Load and parse marketplace.json
        try:
            with open(self.marketplace_path, 'r') as f:
                self.marketplace = json.load(f)
        except json.JSONDecodeError as e:
            self.errors.append(f"Invalid JSON in marketplace.json: {e}")
            return False

        # Run validation checks
        self._validate_marketplace_structure()
        self._validate_marketplace_metadata()
        self._validate_plugins()
        self._validate_plugin_files()
        self._validate_skill_files()

        # Print results
        self._print_results()

        return len(self.errors) == 0

    def _validate_marketplace_structure(self):
        """Validate required top-level fields."""
        required_fields = ['name', 'owner', 'plugins']

        for field in required_fields:
            if field not in self.marketplace:
                self.errors.append(f"Missing required field: '{field}'")

        # Validate owner structure
        if 'owner' in self.marketplace:
            if not isinstance(self.marketplace['owner'], dict):
                self.errors.append("'owner' must be an object")
            elif 'name' not in self.marketplace['owner']:
                self.errors.append("'owner.name' is required")

    def _validate_marketplace_metadata(self):
        """Validate metadata fields."""
        if 'metadata' in self.marketplace:
            metadata = self.marketplace['metadata']

            if 'description' not in metadata:
                self.warnings.append("metadata.description is recommended")

            if 'version' not in metadata:
                self.warnings.append("metadata.version is recommended")
            else:
                # Validate semantic versioning format
                version = metadata['version']
                if not self._is_valid_semver(version):
                    self.warnings.append(f"Version '{version}' doesn't follow semantic versioning (e.g., 1.0.0-beta)")

    def _validate_plugins(self):
        """Validate plugin entries."""
        if 'plugins' not in self.marketplace:
            return

        plugins = self.marketplace['plugins']

        if not isinstance(plugins, list):
            self.errors.append("'plugins' must be an array")
            return

        if len(plugins) == 0:
            self.warnings.append("No plugins defined in marketplace")

        plugin_names = set()

        for idx, plugin in enumerate(plugins):
            self._validate_plugin_entry(plugin, idx, plugin_names)

    def _validate_plugin_entry(self, plugin: Dict, idx: int, plugin_names: set):
        """Validate a single plugin entry."""
        # Check required fields
        if 'name' not in plugin:
            self.errors.append(f"Plugin #{idx}: Missing required field 'name'")
            return

        name = plugin['name']

        # Check for duplicate names
        if name in plugin_names:
            self.errors.append(f"Plugin '{name}': Duplicate plugin name")
        plugin_names.add(name)

        # Check source field
        if 'source' not in plugin:
            self.errors.append(f"Plugin '{name}': Missing required field 'source'")
        else:
            source = plugin['source']
            if not isinstance(source, str):
                self.errors.append(f"Plugin '{name}': 'source' must be a string")
            elif not source.startswith('./'):
                self.warnings.append(f"Plugin '{name}': Source should be relative path starting with './'")

        # Check recommended fields
        recommended = ['description', 'version', 'author', 'license']
        for field in recommended:
            if field not in plugin:
                self.warnings.append(f"Plugin '{name}': Missing recommended field '{field}'")

        # Validate version format
        if 'version' in plugin and not self._is_valid_semver(plugin['version']):
            self.warnings.append(f"Plugin '{name}': Version '{plugin['version']}' doesn't follow semantic versioning")

        # Validate keywords (if present)
        if 'keywords' in plugin:
            if not isinstance(plugin['keywords'], list):
                self.errors.append(f"Plugin '{name}': 'keywords' must be an array")
            elif len(plugin['keywords']) == 0:
                self.warnings.append(f"Plugin '{name}': Empty keywords array")

    def _validate_plugin_files(self):
        """Validate that plugin directories and plugin.json files exist."""
        if 'plugins' not in self.marketplace:
            return

        for plugin in self.marketplace['plugins']:
            if 'name' not in plugin or 'source' not in plugin:
                continue

            name = plugin['name']
            source = plugin['source']

            # Resolve plugin directory path
            if source.startswith('./'):
                plugin_dir = self.repo_root / source.lstrip('./')
            else:
                plugin_dir = self.repo_root / source

            # Check directory exists
            if not plugin_dir.exists():
                self.errors.append(f"Plugin '{name}': Directory not found: {plugin_dir}")
                continue

            if not plugin_dir.is_dir():
                self.errors.append(f"Plugin '{name}': Source path is not a directory: {plugin_dir}")
                continue

            # Check plugin.json exists
            plugin_json_path = plugin_dir / "plugin.json"
            if not plugin_json_path.exists():
                self.errors.append(f"Plugin '{name}': Missing plugin.json at {plugin_json_path}")
                continue

            # Validate plugin.json
            try:
                with open(plugin_json_path, 'r') as f:
                    plugin_manifest = json.load(f)

                # Check name matches
                if 'name' in plugin_manifest and plugin_manifest['name'] != name:
                    self.warnings.append(
                        f"Plugin '{name}': Name mismatch between marketplace.json and plugin.json "
                        f"(marketplace: '{name}', manifest: '{plugin_manifest['name']}')"
                    )

                # Validate components structure
                if 'components' not in plugin_manifest:
                    self.warnings.append(f"Plugin '{name}': Missing 'components' field in plugin.json")
                elif 'agents' not in plugin_manifest['components']:
                    self.warnings.append(f"Plugin '{name}': Missing 'components.agents' field")

            except json.JSONDecodeError as e:
                self.errors.append(f"Plugin '{name}': Invalid JSON in plugin.json: {e}")

    def _validate_skill_files(self):
        """Validate that SKILL.md files exist and are referenced correctly."""
        if 'plugins' not in self.marketplace:
            return

        for plugin in self.marketplace['plugins']:
            if 'name' not in plugin or 'source' not in plugin:
                continue

            name = plugin['name']
            source = plugin['source']

            # Resolve plugin directory path
            if source.startswith('./'):
                plugin_dir = self.repo_root / source.lstrip('./')
            else:
                plugin_dir = self.repo_root / source

            if not plugin_dir.exists():
                continue

            # Check SKILL.md exists
            skill_md_path = plugin_dir / "SKILL.md"
            if not skill_md_path.exists():
                self.errors.append(f"Plugin '{name}': Missing SKILL.md at {skill_md_path}")
                continue

            # Validate SKILL.md has content
            try:
                with open(skill_md_path, 'r') as f:
                    content = f.read()
                    if len(content.strip()) == 0:
                        self.errors.append(f"Plugin '{name}': SKILL.md is empty")
                    elif len(content) < 100:
                        self.warnings.append(f"Plugin '{name}': SKILL.md seems very short ({len(content)} chars)")
            except Exception as e:
                self.errors.append(f"Plugin '{name}': Could not read SKILL.md: {e}")

    def _is_valid_semver(self, version: str) -> bool:
        """Check if version follows semantic versioning format."""
        import re
        # Basic semver pattern: X.Y.Z[-prerelease][+build]
        pattern = r'^\d+\.\d+\.\d+(-[a-zA-Z0-9.-]+)?(\+[a-zA-Z0-9.-]+)?$'
        return bool(re.match(pattern, version))

    def _print_results(self):
        """Print validation results with color coding."""
        print()

        if self.errors:
            print(f"{Colors.RED}{Colors.BOLD}❌ Errors ({len(self.errors)}):{Colors.RESET}")
            for error in self.errors:
                print(f"  {Colors.RED}• {error}{Colors.RESET}")
            print()

        if self.warnings:
            print(f"{Colors.YELLOW}{Colors.BOLD}⚠️  Warnings ({len(self.warnings)}):{Colors.RESET}")
            for warning in self.warnings:
                print(f"  {Colors.YELLOW}• {warning}{Colors.RESET}")
            print()

        if self.info:
            print(f"{Colors.BLUE}{Colors.BOLD}ℹ️  Info ({len(self.info)}):{Colors.RESET}")
            for info_msg in self.info:
                print(f"  {Colors.BLUE}• {info_msg}{Colors.RESET}")
            print()

        # Final summary
        if len(self.errors) == 0:
            plugin_count = len(self.marketplace.get('plugins', []))
            print(f"{Colors.GREEN}{Colors.BOLD}✅ Validation passed!{Colors.RESET}")
            print(f"   Marketplace: {self.marketplace.get('name', 'unknown')}")
            print(f"   Plugins: {plugin_count}")
            print(f"   Warnings: {len(self.warnings)}")
            print()
        else:
            print(f"{Colors.RED}{Colors.BOLD}❌ Validation failed with {len(self.errors)} error(s){Colors.RESET}")
            print()

def main():
    """Main entry point."""
    # Determine repository root (parent of .claude-plugin directory)
    script_path = Path(__file__).resolve()
    repo_root = script_path.parent.parent

    validator = MarketplaceValidator(repo_root)
    success = validator.validate()

    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
