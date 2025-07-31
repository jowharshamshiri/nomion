---
layout: default
title: St8 Guide - Automatic Version Management
---

# St8 Guide

St8 is an automatic version management tool that integrates with Git to provide semantic versioning based on your repository's commit history. It calculates version numbers using git tags, commit counts, and change statistics, making it perfect for continuous integration workflows.

## How It Works

St8 uses a three-part versioning scheme based on your Git repository:

- **Major Version**: Extracted from the most recent Git tag (e.g., `v1.0` → `1.0`)
- **Minor Version**: Number of commits since the last tag
- **Patch Version**: Total number of changes (line additions + deletions) across all commits

**Final Version Format**: `{major}.{minor}.{patch}`

### Example Version Calculation

```bash
# Repository state:
# - Latest tag: v2.1
# - Commits since tag: 5
# - Total changes: 247

# Result: 2.1.5.247
```

## Installation and Setup

### 1. Install St8

First, ensure st8 is installed as part of the Workspace tool suite:

```bash
# Install all tools including st8
./install.sh

# Or install just st8
cargo install --path . --bin st8
```

### 2. Install Git Hook

Navigate to your Git repository and install the pre-commit hook:

```bash
cd your-git-repo
st8 install
```

This creates a pre-commit hook that automatically updates your version file before each commit.

### 3. Configure (Optional)

Create a `.st8.json` configuration file in your repository root:

```json
{
  "version": 1,
  "enabled": true,
  "version_file": "version.txt"
}
```

**Configuration Options:**
- `enabled`: Enable/disable automatic version updates
- `version_file`: Path to the file where version should be written (default: `version.txt`)
- `auto_detect_project_files`: Automatically detect and update common project files (default: `true`)
- `project_files`: Array of additional project files to update (relative to repository root)

## Basic Usage

### Install Hook
```bash
# Install pre-commit hook
st8 install

# Force reinstall (if already installed)
st8 install --force
```

### Show Version Information
```bash
# Display current version breakdown
st8 show
```

Output example:
```
Current Version Information:
  Major (tag): v1.2
  Minor (commits since tag): 3
  Patch (total changes): 156
  Full Version: 1.2.3.156
```

### Manual Version Update
```bash
# Update version file manually
st8 update

# Update even outside git repo
st8 update --no-git

# Update and automatically stage changed files
ws update --git-add
```

### Check Status
```bash
# Show st8 status and configuration
st8 status
```

Output example:
```
St8 Status:
  Git Repository: ✓
  Hook Installed: ✓
  Enabled: ✓
  Version File: version.txt
  Current Version: 1.2.3.156
  Version File Exists: ✓
  Auto-detect Project Files: ✓
  Detected Project Files: 
    • /path/to/repo/Cargo.toml (Cargo.toml)
    • /path/to/repo/package.json (package.json)
```

### Uninstall Hook
```bash
# Remove st8 from pre-commit hooks
st8 uninstall
```

## Workflow Integration

### Automatic Mode (Recommended)

1. Install the git hook once: `st8 install`
2. Work normally - commit as usual
3. Version files are automatically updated before each commit:
   - `version.txt` (or custom version file)
   - All detected project files (Cargo.toml, package.json, etc.)
4. All version file changes are automatically staged

### Manual Mode

If you prefer manual control:

1. Configure: Set `"enabled": false` in `.st8.json`
2. Update manually: Run `st8 update` when needed
3. Optionally use `ws update --git-add` to automatically stage updated files
4. Commit the version file changes manually

### CI/CD Integration

Include version information in your build scripts:

```bash
#!/bin/bash
# Get current version
VERSION=$(cat version.txt)
echo "Building version: $VERSION"

# Use in build process
docker build -t myapp:$VERSION .
```

## Features

### Project File Auto-Detection

St8 automatically detects and updates version fields in common project configuration files:

**Supported File Types:**
- **Cargo.toml** (Rust): `version = "x.y.z"` in `[package]` section
- **package.json** (Node.js): `"version": "x.y.z"`
- **pyproject.toml** (Python): `version = "x.y.z"` in `[tool.poetry]` and `[project]` sections
- **setup.py** (Python): `version="x.y.z"` parameter
- **composer.json** (PHP): `"version": "x.y.z"`
- **pubspec.yaml** (Dart/Flutter): `version: x.y.z`
- **pom.xml** (Maven/Java): `<version>x.y.z</version>`
- **build.gradle** (Gradle): `version = 'x.y.z'`
- **CMakeLists.txt** (C/C++): `VERSION x.y.z` in `project()` declaration

**Configuration Example:**
```json
{
  "version": 1,
  "enabled": true,
  "version_file": "version.txt",
  "auto_detect_project_files": true,
  "project_files": ["custom-config.json", "VERSION"]
}
```

**How It Works:**
1. When `auto_detect_project_files` is `true` (default), st8 scans the repository root for supported project files
2. Each detected file is automatically updated with the new version
3. Files specified in `project_files` are also updated (if they exist and st8 can detect their type)
4. All updated files are automatically staged in git

**Disable Auto-Detection:**
```json
{
  "auto_detect_project_files": false
}
```

### Custom Version Files

Configure different version file paths:

```json
{
  "version_file": "src/version.rs"
}
```

### Version File Formats

St8 writes just the version number to the file:

```
1.2.3.156
```

You can incorporate this into different file formats using scripts:

**Rust example:**
```bash
# Update Rust version constant
echo "pub const VERSION: &str = \"$(cat version.txt)\";" > src/version.rs
```

**JavaScript example:**
```bash
# Update package.json version
jq --arg version "$(cat version.txt)" '.version = $version' package.json > package.json.tmp
mv package.json.tmp package.json
```

### Multiple Repositories

Each repository can have its own st8 configuration:

```bash
# Project A
cd project-a
st8 install
echo '{"version_file": "VERSION"}' > .st8.json

# Project B  
cd project-b
st8 install
echo '{"version_file": "src/version.txt"}' > .st8.json
```

## Troubleshooting

### Hook Not Running

If the version isn't updating automatically:

1. Check if hook is installed: `st8 status`
2. Verify hook file exists: `ls -la .git/hooks/pre-commit`
3. Ensure hook is executable: `chmod +x .git/hooks/pre-commit`
4. Check if st8 is in PATH: `which st8`

### Version Not Updating

If version calculations seem wrong:

1. Check git repository status: `git status`
2. Verify tags exist: `git tag -l`
3. Check commit history: `git log --oneline`
4. Test manually: `st8 show`

### Configuration Issues

If configuration isn't working:

1. Validate JSON syntax: `cat .st8.json | jq .`
2. Check file permissions: `ls -la .st8.json`
3. Verify configuration is in repository root

### Removing St8

To completely remove st8 from a repository:

```bash
# Remove git hook
st8 uninstall

# Remove configuration (optional)
rm .st8.json

# Remove version file (optional)
rm version.txt
```

## Logging

St8 logs all actions to `.ws/st8/logs/st8.log` in your repository:

```bash
# View recent actions
tail -f .ws/st8/logs/st8.log

# Monitor in real-time
tail -f .ws/st8/logs/st8.log
```

Log format:
```
[2024-07-19 14:30:15] Created new pre-commit hook: /path/to/repo/.git/hooks/pre-commit
[2024-07-19 14:30:45] Updated version to: 1.2.3.156 (file: version.txt)
[2024-07-19 14:31:02] Rendered template: src/version.h
```

The log file is automatically created when st8 performs operations and is stored in the centralized `.ws` state directory along with templates and other tool configurations.

## Best Practices

1. **Install Early**: Set up st8 when creating a new repository
2. **Tag Releases**: Create git tags for major releases (`git tag v1.0`)
3. **Consistent Workflow**: Let the hook handle versioning automatically
4. **CI Integration**: Use version.txt in your build and deployment scripts
5. **Backup Hooks**: Document st8 usage for team members

## Integration Examples

### Multi-Language Project

For projects using multiple technologies:

```bash
# Project structure:
# ├── Cargo.toml          (Rust backend)
# ├── package.json        (Node.js frontend)
# ├── pyproject.toml      (Python scripts)
# └── .st8.json

# St8 automatically updates all three files:
git commit -m "Add new feature"
# → Cargo.toml version updated to 1.2.5.234
# → package.json version updated to 1.2.5.234  
# → pyproject.toml version updated to 1.2.5.234
```

### Monorepo with Custom Files

```json
{
  "version": 1,
  "enabled": true,
  "version_file": "VERSION",
  "auto_detect_project_files": true,
  "project_files": [
    "apps/web/package.json",
    "services/api/Cargo.toml",
    "docs/conf.py"
  ]
}
```

### Docker Build
```dockerfile
# Copy version file
COPY version.txt /app/version.txt

# Use in build args
ARG VERSION
RUN echo "Building version: $VERSION"
```

### GitHub Actions
```yaml
- name: Get Version
  id: version
  run: echo "version=$(cat version.txt)" >> $GITHUB_OUTPUT

- name: Create Release
  uses: actions/create-release@v1
  with:
    tag_name: v${{ steps.version.outputs.version }}
    release_name: Release ${{ steps.version.outputs.version }}
```

### Makefile Integration
```makefile
VERSION := $(shell cat version.txt)

build:
	@echo "Building version $(VERSION)"
	cargo build --release

release: build
	git tag v$(VERSION)
	git push origin v$(VERSION)
```

## See Also

- [Installation Guide]({{ '/installation/' | relative_url }}) - Installing the tool suite
- [Getting Started]({{ '/getting-started/' | relative_url }}) - Quick start with all tools
- [API Reference]({{ '/api-reference/' | relative_url }}) - command reference