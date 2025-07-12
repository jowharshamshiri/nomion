---
layout: default
title: Getting Started
---

# Getting Started with Refac

This guide will help you get up and running with Refac quickly. Learn the core concepts and basic usage patterns.

## What is Refac?

Refac is a command-line tool that performs recursive string replacement in both file/directory names and file contents. It's designed for large-scale refactoring operations with safety and performance in mind.

## Installation

### From Source (Recommended)

```bash
# Clone and build
git clone https://github.com/jowharshamshiri/refac.git
cd refac
cargo build --release
cargo install --path .
```

### Verify Installation

```bash
refac --version
refac --help
```

## Basic Concepts

### Dual Operation Mode

Refac performs two types of replacements:

1. **Name Replacement**: Renames files and directories containing the target string
2. **Content Replacement**: Replaces strings inside text files (skips binary files automatically)

### Command Structure

```bash
refac <DIRECTORY> <OLD_STRING> <NEW_STRING> [OPTIONS]
```

## Your First Refactoring

Let's start with a simple example:

### Step 1: Create a Test Project

```bash
mkdir test-project
cd test-project
echo "function oldFunction() { return 'hello'; }" > oldFile.js
echo "oldFunction();" > main.js
```

### Step 2: Preview Changes

Always use `--dry-run` first to see what would change:

```bash
refac . "oldFunction" "newFunction" --dry-run
```

This shows you:
- Which files will be renamed
- Which files will have content changes
- A summary of total changes

### Step 3: Apply Changes

If the preview looks correct:

```bash
refac . "oldFunction" "newFunction"
```

Refac will:
1. Ask for confirmation (unless you use `--force`)
2. Apply the changes
3. Show a summary

### Step 4: Verify Results

```bash
ls -la  # Check renamed files
cat *.js  # Check content changes
```

## Operation Modes

Control what Refac processes with mode flags:

### Names Only
Only rename files/directories, don't change content:

```bash
refac . "oldProject" "newProject" --names-only
```

### Content Only
Only change file contents, don't rename files:

```bash
refac . "api.old.com" "api.new.com" --content-only
```

### Files Only
Process files but not directories:

```bash
refac . "oldname" "newname" --files-only
```

### Directories Only
Process directories but not files:

```bash
refac . "oldname" "newname" --dirs-only
```

## Filtering Files

### Include Specific File Types

```bash
# Only process Rust files
refac ./src "oldStruct" "newStruct" --include "*.rs"

# Multiple file types
refac . "oldname" "newname" --include "*.js" --include "*.ts"
```

### Exclude Unwanted Files

```bash
# Skip build directories
refac . "oldname" "newname" --exclude "target/*" --exclude "node_modules/*"

# Skip log files
refac . "oldname" "newname" --exclude "*.log"
```

## Safety Features

### Always Preview First

```bash
# See exactly what will change
refac . "oldname" "newname" --dry-run --verbose
```

### Create Backups

```bash
# Create .bak files before changes
refac . "oldname" "newname" --backup
```

### Use Version Control

```bash
# Commit before refactoring
git add .
git commit -m "Before refactoring"

# Apply changes
refac . "oldname" "newname"

# Review changes
git diff HEAD~1
```

## Common Scenarios

### Rename a Class

```bash
# Preview first
refac ./src "UserController" "AccountController" --dry-run

# Apply to specific file types
refac ./src "UserController" "AccountController" \
  --include "*.rs" \
  --include "*.toml"
```

### Update Configuration

```bash
# Change URLs in config files only
refac ./config "old.server.com" "new.server.com" \
  --content-only \
  --include "*.env" \
  --include "*.yaml"
```

### Project Rename

```bash
# Rename entire project
refac . "OldProjectName" "NewProjectName" \
  --exclude ".git/*" \
  --exclude "target/*"
```

## Performance Tips

### Use Multiple Threads

```bash
# Faster processing for large projects
refac . "oldname" "newname" --threads 8
```

### Limit Search Depth

```bash
# Avoid deep directory traversal
refac . "oldname" "newname" --max-depth 3
```

### Target Specific Areas

```bash
# Process only source directories
refac ./src "oldname" "newname"
refac ./tests "oldname" "newname"
```

## Advanced Features

### Regular Expressions

```bash
# Use regex patterns
refac . "version_\d+" "version_2" --regex

# Case-insensitive matching
refac . "oldname" "newname" --ignore-case
```

### Output Formats

```bash
# JSON output for scripting
refac . "oldname" "newname" --format json

# Plain text output
refac . "oldname" "newname" --format plain
```

## Best Practices

### 1. Start Small
Begin with a small directory or specific file types:

```bash
refac ./src/utils "oldUtil" "newUtil" --include "*.rs"
```

### 2. Always Test
- Use `--dry-run` before applying changes
- Run your test suite after refactoring
- Commit changes incrementally

### 3. Be Specific
Use include/exclude patterns to limit scope:

```bash
refac ./project "oldname" "newname" \
  --include "*.rs" \
  --exclude "*test*" \
  --exclude "target/*"
```

### 4. Handle Large Projects
- Use threading: `--threads 8`
- Limit depth: `--max-depth 3`
- Process in batches by directory

## Getting Help

### Command Help

```bash
# General help
refac --help

# See all options
refac --help | less
```

### Verbose Output

```bash
# See detailed operation info
refac . "oldname" "newname" --dry-run --verbose
```

### Common Issues

**No changes found:**
- Check if the string exists: `grep -r "oldname" .`
- Use `--verbose` to see what's being processed
- Verify include/exclude patterns

**Permission errors:**
- Check file permissions: `ls -la`
- Use `--verbose` to see which files are skipped

## Next Steps

Now that you understand the basics:

1. [Usage Guide]({{ '/usage/' | relative_url }}) - Comprehensive usage examples
2. [Command Reference]({{ '/api-reference/' | relative_url }}) - Complete option documentation  
3. [Examples]({{ '/examples/' | relative_url }}) - Real-world scenarios

## Quick Reference

```bash
# Basic usage
refac . "old" "new"

# Preview changes
refac . "old" "new" --dry-run

# Specific file types
refac . "old" "new" --include "*.rs"

# Names or content only
refac . "old" "new" --names-only
refac . "old" "new" --content-only

# With backups
refac . "old" "new" --backup

# Force without confirmation
refac . "old" "new" --force
```