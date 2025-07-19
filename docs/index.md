---
layout: default
title: Refac Tools - Command-Line Tool Suite
toc: false
---

# Refac Tools

A suite of robust, cross-platform command-line tools for developers and system administrators. The suite includes **refac** for string replacement, **scrap** for smart file management, **unscrap** for file restoration, and **verbump** for automatic version management. Designed for safety, reliability, and performance, making them suitable for mission-critical operations and daily development workflows.

## Tools Overview

### 🔄 Refac - String Replacement Tool
- **Dual Operation**: Replace strings in both file/directory names AND file contents
- **Safety First**: Collision detection, dry-run mode, and binary file protection
- **High Performance**: Multi-threaded processing with progress tracking
- **Flexible Filtering**: Include/exclude patterns with glob and regex support

### 🗑️ Scrap - Local Trash Folder
- **Project Trash**: Move unwanted files to `.scrap` folder instead of deleting
- **Safe Deletion**: Keep old files you might need later without cluttering workspace
- **Metadata Tracking**: Remember original locations for easy restoration
- **Cleanup Operations**: List, search, clean old items, and archive capabilities

### ↩️ Unscrap - File Restoration
- **Smart Recovery**: Restore files to their original locations
- **Undo Operations**: Quickly undo the last scrap action
- **Custom Destinations**: Restore to any location
- **Conflict Handling**: Safe restoration with overwrite protection

### 🏷️ Verbump - Automatic Version Management
- **Git Integration**: Automatic version bumping via git hooks
- **Smart Versioning**: Calculate versions based on tags, commits, and changes
- **Configuration**: Customizable version files and patterns
- **Logging**: action logging for audit trails

## Key Features

- **Cross-Platform**: Works on Windows, macOS, and Linux
- **Safety First**: Collision detection, confirmation prompts, and atomic operations
- **Performance Optimized**: Multi-threaded processing and efficient file handling
- **User Friendly**: Clear error messages and help

## Quick Start

### Refac - String Replacement
```bash
# Basic string replacement
refac . "oldname" "newname"

# Preview changes first (recommended)
refac . "oldname" "newname" --dry-run

# Only rename files/directories (skip content)
refac . "oldname" "newname" --names-only
```

### Scrap - Local Trash
```bash
# Move unwanted files to .scrap instead of deleting
scrap old_file.txt deprecated_feature/

# List what's in your project trash
scrap

# Find specific items you scrapped
scrap find "*.log"

# Clean up old items (30+ days)
scrap clean

# Archive old items before purging
scrap archive --remove
```

### Unscrap - File Restoration
```bash
# Restore last scrapped item
unscrap

# Restore specific file
unscrap filename.txt

# Restore to custom location
unscrap filename.txt --to /new/location/
```

### Verbump - Version Management
```bash
# Install git hook for automatic versioning
verbump install

# Show current version information
verbump show

# Manually update version
verbump update

# Check verbump status and configuration
verbump status
```

## Installation

### From Source

```bash
git clone https://github.com/jowharshamshiri/refac
cd refac
cargo build --release

# Install all tools
cargo install --path .

# Or install individual tools
cargo install --path . --bin refac
cargo install --path . --bin scrap
cargo install --path . --bin unscrap
cargo install --path . --bin verbump
```

## How It Works

Refac performs two types of operations:

1. **Name Replacement**: Renames files and directories containing the target string
2. **Content Replacement**: Replaces strings inside text files (automatically skips binary files)

By default, both operations are performed. Use mode flags to limit the scope:

- `--names-only`: Only rename files/directories
- `--content-only`: Only replace file contents
- `--files-only`: Process files but not directories
- `--dirs-only`: Process directories but not files

## Safety Features

- **Collision Detection**: Prevents overwriting existing files
- **Binary File Detection**: Automatically skips binary files for content replacement
- **Dry Run Mode**: Preview all changes before applying them
- **Backup Support**: Create backups of modified files
- **Confirmation Prompts**: Interactive confirmation (unless `--force` is used)

## Performance

- **Multi-threaded**: Parallel content processing for large codebases
- **Streaming**: Efficient handling of large files
- **Progress Tracking**: Visual progress bars with detailed information
- **Smart Filtering**: Process only relevant files with include/exclude patterns

## Common Use Cases

### Project Refactoring

```bash
# Rename a class throughout a codebase
refac ./src "OldClassName" "NewClassName"

# Rename variables (case-sensitive)
refac ./project "old_variable" "new_variable"
```

### File Organization

```bash
# Rename files only, skip content
refac ./docs "draft" "final" --names-only

# Update file contents only, keep names
refac ./config "old.example.com" "new.example.com" --content-only
```

### Bulk Operations

```bash
# Process specific file types
refac ./src "oldname" "newname" --include "*.rs" --include "*.toml"

# Exclude certain directories
refac ./project "oldname" "newname" --exclude "target/*" --exclude "*.log"
```

## Best Practices

1. **Always test first**: Use `--dry-run` to preview changes
2. **Use version control**: Commit your code before running refac
3. **Create backups**: Use `--backup` for important changes
4. **Be specific**: Use include/exclude patterns to limit scope
5. **Test after changes**: Run your tests after refactoring

## Getting Help

- View tool options: `refac --help`, `scrap --help`, `unscrap --help`, `verbump --help`
- Check versions: `refac --version`, `scrap --version`, `unscrap --version`, `verbump --version`
- Report issues: [GitHub Issues](https://github.com/jowharshamshiri/refac/issues)

## Documentation

- [Installation Guide]({{ '/installation/' | relative_url }}) - Detailed installation instructions
- [Usage Guide]({{ '/usage/' | relative_url }}) - usage examples
- [Command Reference]({{ '/api-reference/' | relative_url }}) - command-line reference

## License

MIT License - see the [LICENSE](https://github.com/jowharshamshiri/refac/blob/main/LICENSE) file for details.
