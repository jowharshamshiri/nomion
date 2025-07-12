---
layout: default
title: Examples
---

# Real-World Examples

Learn how to use Refac through practical examples for common refactoring scenarios.

## Basic String Replacement

### Rename Variables Throughout Project

**Scenario**: You need to rename a variable across your entire codebase.

```bash
# Preview the changes first
refac ./src "oldVariableName" "newVariableName" --dry-run

# Apply the changes
refac ./src "oldVariableName" "newVariableName"
```

### Update API Endpoints

**Scenario**: Your API URL changed and you need to update all references.

```bash
# Update only file contents, don't rename files
refac . "api.old-service.com" "api.new-service.com" --content-only

# Include only relevant file types
refac . "api.old-service.com" "api.new-service.com" \
  --content-only \
  --include "*.js" \
  --include "*.py" \
  --include "*.json"
```

## File and Directory Organization

### Rename Project Files

**Scenario**: You're renaming your project from "MyApp" to "AwesomeApp".

```bash
# Rename both files and their contents
refac . "MyApp" "AwesomeApp" --dry-run

# Exclude certain directories
refac . "MyApp" "AwesomeApp" \
  --exclude "node_modules/*" \
  --exclude ".git/*" \
  --exclude "target/*"
```

### Reorganize File Naming Convention

**Scenario**: Change file naming from `camelCase` to `snake_case`.

```bash
# Rename files only, don't change content
refac ./src "camelCase" "snake_case" --names-only

# Or use regex for more complex patterns
refac ./src "([a-z])([A-Z])" "\$1_\$2" --names-only --regex
```

## Language-Specific Refactoring

### Rust Project Refactoring

**Scenario**: Rename a struct and update all references.

```bash
# Target only Rust files
refac ./src "OldStruct" "NewStruct" \
  --include "*.rs" \
  --include "*.toml"

# With backup for safety
refac ./src "OldStruct" "NewStruct" \
  --include "*.rs" \
  --backup
```

### JavaScript/TypeScript Project

**Scenario**: Update function names across JS/TS files.

```bash
# Target JS and TS files
refac ./src "oldFunction" "newFunction" \
  --include "*.js" \
  --include "*.ts" \
  --include "*.jsx" \
  --include "*.tsx"

# Exclude test files
refac ./src "oldFunction" "newFunction" \
  --include "*.js" \
  --include "*.ts" \
  --exclude "*test*" \
  --exclude "*spec*"
```

### Python Project

**Scenario**: Rename a class and update imports.

```bash
# Python files only
refac ./project "OldClass" "NewClass" \
  --include "*.py" \
  --exclude "__pycache__/*"

# Include requirements files too
refac ./project "old-package" "new-package" \
  --include "*.py" \
  --include "requirements*.txt" \
  --include "setup.py"
```

## Configuration and Deployment

### Update Environment Variables

**Scenario**: Change environment variable names in configuration files.

```bash
# Target configuration files
refac ./config "OLD_ENV_VAR" "NEW_ENV_VAR" \
  --include "*.env" \
  --include "*.yml" \
  --include "*.yaml" \
  --include "*.json"

# Content only (don't rename config files)
refac ./config "staging.server.com" "production.server.com" \
  --content-only \
  --include "*.env" \
  --include "*.config"
```

### Docker and Deployment Scripts

**Scenario**: Update service names in deployment configurations.

```bash
# Update container names
refac ./deployment "old-service" "new-service" \
  --include "*.yml" \
  --include "*.yaml" \
  --include "Dockerfile*" \
  --include "*.sh"

# Update image names
refac ./k8s "myregistry/old-app" "myregistry/new-app" \
  --include "*.yaml" \
  --content-only
```

## Database and Schema Changes

### Update Table Names

**Scenario**: Rename database tables in SQL files and application code.

```bash
# SQL files only
refac ./sql "old_table" "new_table" \
  --include "*.sql" \
  --include "*.migration"

# Application code
refac ./src "old_table" "new_table" \
  --include "*.py" \
  --include "*.js" \
  --include "*.rb"
```

### Update Column References

**Scenario**: Rename a database column across your application.

```bash
# Preview changes across multiple file types
refac ./project "old_column_name" "new_column_name" \
  --dry-run \
  --include "*.sql" \
  --include "*.py" \
  --include "*.js"

# Apply with verbose output
refac ./project "old_column_name" "new_column_name" \
  --verbose \
  --include "*.sql" \
  --include "*.py" \
  --include "*.js"
```

## Advanced Patterns

### Using Regular Expressions

**Scenario**: Update version strings with regex patterns.

```bash
# Match version patterns like "v1.2.3"
refac ./docs "v1\\.\\d+\\.\\d+" "v2.0.0" \
  --regex \
  --include "*.md" \
  --include "*.txt"

# Case-insensitive function name updates
refac ./src "oldfunction" "newFunction" \
  --regex \
  --ignore-case \
  --include "*.js"
```

### Batch Operations with Scripts

**Scenario**: Multiple related replacements in sequence.

```bash
#!/bin/bash
# bulk-refactor.sh

# Array of old:new pairs
REPLACEMENTS=(
  "OldClass1:NewClass1"
  "OldClass2:NewClass2"
  "old_function:new_function"
  "OLD_CONSTANT:NEW_CONSTANT"
)

# Process each replacement
for replacement in "${REPLACEMENTS[@]}"; do
  IFS=':' read -r old new <<< "$replacement"
  echo "Replacing '$old' with '$new'..."
  
  refac ./src "$old" "$new" \
    --include "*.rs" \
    --include "*.toml" \
    --force
    
  if [ $? -ne 0 ]; then
    echo "Error processing $old -> $new"
    exit 1
  fi
done

echo "All replacements completed successfully!"
```

### Conditional Replacements

**Scenario**: Different replacements for different environments.

```bash
#!/bin/bash
# environment-update.sh

ENVIRONMENT=${1:-staging}

case $ENVIRONMENT in
  "staging")
    refac ./config "production.db.com" "staging.db.com" \
      --content-only \
      --include "*.env"
    ;;
  "production")
    refac ./config "staging.db.com" "production.db.com" \
      --content-only \
      --include "*.env"
    ;;
  *)
    echo "Usage: $0 [staging|production]"
    exit 1
    ;;
esac
```

## Safety and Testing

### Safe Refactoring Workflow

**Scenario**: A safe, step-by-step refactoring process.

```bash
#!/bin/bash
# safe-refactor.sh

OLD_NAME="$1"
NEW_NAME="$2"
PROJECT_DIR="$3"

if [ $# -ne 3 ]; then
  echo "Usage: $0 <old_name> <new_name> <project_dir>"
  exit 1
fi

# Step 1: Backup
echo "Creating backup..."
cp -r "$PROJECT_DIR" "${PROJECT_DIR}.backup"

# Step 2: Dry run
echo "Previewing changes..."
refac "$PROJECT_DIR" "$OLD_NAME" "$NEW_NAME" --dry-run --verbose

read -p "Continue with these changes? (y/N): " confirm
if [ "$confirm" != "y" ]; then
  echo "Aborted"
  exit 0
fi

# Step 3: Apply changes with backup
echo "Applying changes..."
refac "$PROJECT_DIR" "$OLD_NAME" "$NEW_NAME" --backup

# Step 4: Run tests (if available)
if [ -f "$PROJECT_DIR/Cargo.toml" ]; then
  echo "Running Rust tests..."
  cd "$PROJECT_DIR" && cargo test
elif [ -f "$PROJECT_DIR/package.json" ]; then
  echo "Running Node.js tests..."
  cd "$PROJECT_DIR" && npm test
elif [ -f "$PROJECT_DIR/setup.py" ]; then
  echo "Running Python tests..."
  cd "$PROJECT_DIR" && python -m pytest
else
  echo "No test framework detected. Please run tests manually."
fi

echo "Refactoring completed!"
```

### Testing Changes

**Scenario**: Verify refactoring didn't break anything.

```bash
# Before refactoring
git add .
git commit -m "Before refactoring: rename oldname to newname"

# Apply refactoring
refac . "oldname" "newname" --backup --verbose

# Check what changed
git diff --name-only
git diff --stat

# Run your tests
cargo test  # Rust
npm test    # Node.js
pytest      # Python
make test   # Make-based projects

# If tests pass, commit
git add .
git commit -m "Refactor: rename oldname to newname"

# If tests fail, you can restore
git checkout .
# Or restore from backup files (*.bak)
```

## Performance Optimization

### Large Codebase Handling

**Scenario**: Refactoring a very large project efficiently.

```bash
# Use multiple threads for better performance
refac ./large-project "oldname" "newname" \
  --threads 8 \
  --progress always

# Limit scope to reduce processing time
refac ./large-project "oldname" "newname" \
  --max-depth 3 \
  --include "src/**" \
  --exclude "node_modules/**" \
  --exclude "target/**"

# Process in batches for very large projects
refac ./src "oldname" "newname" --threads 8
refac ./tests "oldname" "newname" --threads 8
refac ./docs "oldname" "newname" --threads 8
```

### Memory-Conscious Processing

**Scenario**: Handle large files without running out of memory.

```bash
# Process with limited depth
refac ./project "oldname" "newname" --max-depth 2

# Target specific file types to reduce scope
refac ./project "oldname" "newname" \
  --include "*.rs" \
  --exclude "*.log" \
  --exclude "*.tmp"
```

## Integration Examples

### CI/CD Pipeline Integration

**Scenario**: Automated refactoring checks in your pipeline.

```yaml
# .github/workflows/refactor-check.yml
name: Check for deprecated patterns

on: [push, pull_request]

jobs:
  check-deprecated:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install Refac
        run: cargo install --git https://github.com/jowharshamshiri/refac
        
      - name: Check for deprecated patterns
        run: |
          # Check for deprecated function names
          if refac . "deprecated_function" "new_function" --dry-run --format json | jq -e '.summary.total_changes > 0'; then
            echo "Found deprecated patterns!"
            exit 1
          fi
```

### Git Hooks Integration

**Scenario**: Prevent commits with certain patterns.

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Check for debug statements
if refac . "console.log" "" --dry-run --format json | jq -e '.summary.total_changes > 0' >/dev/null; then
  echo "Error: Found console.log statements in code"
  refac . "console.log" "" --dry-run --include "*.js" --include "*.ts"
  echo "Please remove debug statements before committing"
  exit 1
fi

# Check for TODO comments (warning only)
if refac . "TODO" "" --dry-run --format json | jq -e '.summary.total_changes > 0' >/dev/null; then
  echo "Warning: Found TODO comments in code"
  refac . "TODO" "" --dry-run --include "*.rs" --include "*.js" --include "*.py"
fi

exit 0
```

## Troubleshooting Examples

### Debugging No Changes Found

**Scenario**: Refac reports no changes but you expect some.

```bash
# Use verbose mode to see what's happening
refac . "search_term" "replacement" --dry-run --verbose

# Check if the term exists
grep -r "search_term" . --include="*.rs"

# Verify include/exclude patterns
refac . "search_term" "replacement" \
  --dry-run \
  --verbose \
  --include "*" \
  --exclude "target/*"

# Test with broader patterns
refac . "search_term" "replacement" \
  --dry-run \
  --ignore-case \
  --include "*.rs"
```

### Handling Permission Issues

**Scenario**: Some files can't be modified due to permissions.

```bash
# Check file permissions
ls -la problematic_file

# Fix permissions if needed
chmod 644 *.rs

# Or run with appropriate permissions
sudo refac . "oldname" "newname" --backup

# Skip problematic files
refac . "oldname" "newname" \
  --exclude "readonly_files/*" \
  --verbose
```

These examples demonstrate the versatility and power of Refac for various refactoring scenarios. Remember to always use `--dry-run` first and maintain backups of important files.