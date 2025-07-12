---
layout: default
title: API Reference
---

# API Reference

This comprehensive reference covers all Refac commands, options, and configuration settings.

## Global Options

These options are available for all commands:

| Option | Alias | Description | Default |
|--------|-------|-------------|---------|
| `--path` | `-p` | Target path (file or directory) | Current directory |
| `--preview` | | Show changes without applying | `false` |
| `--dry-run` | | Generate diff without modifying files | `false` |
| `--config` | `-c` | Configuration file path | `.refacrc` |
| `--verbose` | `-v` | Enable verbose output | `false` |
| `--quiet` | `-q` | Suppress non-error output | `false` |
| `--no-color` | | Disable colored output | `false` |
| `--help` | `-h` | Show help | |
| `--version` | | Show version | |

## Commands

### rename-function

Rename functions across your codebase.

```bash
refac rename-function <old-name> <new-name> [options]
```

**Arguments:**
- `old-name`: Current function name (supports wildcards)
- `new-name`: New function name (supports placeholders)

**Options:**
- `--scope`: Limit to specific scope (global, class, module)
- `--language`: Override detected language
- `--update-references`: Update all references (default: true)

**Examples:**
```bash
# Simple rename
refac rename-function getUserData fetchUserData

# With wildcards
refac rename-function 'get*' 'fetch$1' --path ./src

# Class methods only
refac rename-function render renderComponent --scope class
```

### rename-variable

Rename variables with scope awareness.

```bash
refac rename-variable <old-name> <new-name> [options]
```

**Options:**
- `--scope`: Variable scope (local, global, parameter)
- `--type`: Variable type (const, let, var)
- `--update-references`: Update all references (default: true)

**Examples:**
```bash
# Rename local variable
refac rename-variable count totalCount --path ./utils.js

# Rename only const variables
refac rename-variable API_KEY API_SECRET --type const
```

### extract-method

Extract code into a new method or function.

```bash
refac extract-method [options]
```

**Options:**
- `--pattern`: Code pattern to extract
- `--name`: Name for the extracted method
- `--start-line`: Starting line number
- `--end-line`: Ending line number
- `--parameters`: Comma-separated parameter names

**Examples:**
```bash
# Extract by pattern
refac extract-method \
  --pattern 'for (let i = 0; i < items.length; i++)' \
  --name processItems

# Extract by line range
refac extract-method \
  --start-line 10 \
  --end-line 25 \
  --name calculateResult \
  --path ./calc.js
```

### inline-function

Replace function calls with their implementation.

```bash
refac inline-function <function-name> [options]
```

**Options:**
- `--preserve-comments`: Keep function comments
- `--single-use-only`: Only inline single-use functions

**Examples:**
```bash
# Inline all calls
refac inline-function simpleHelper --path ./src

# Inline only single-use functions
refac inline-function helperFunction --single-use-only
```

### move-function

Move functions between files.

```bash
refac move-function <function-name> --to <target-file> [options]
```

**Options:**
- `--update-imports`: Update import statements (default: true)
- `--export-style`: Export style (named, default, none)

**Examples:**
```bash
# Move to another file
refac move-function validateEmail --to ./validators/email.js

# Move with specific export style
refac move-function processData --to ./processors.js --export-style default
```

### transform

Apply custom transformations using patterns.

```bash
refac transform --pattern <search> --replacement <replace> [options]
```

**Options:**
- `--pattern`: Search pattern (regex or AST pattern)
- `--replacement`: Replacement pattern
- `--language`: Target language
- `--ast`: Use AST-based matching

**Examples:**
```bash
# Simple text replacement
refac transform \
  --pattern 'console.log' \
  --replacement 'logger.debug'

# AST-based transformation
refac transform \
  --pattern 'if ($cond) return true; else return false;' \
  --replacement 'return $cond;' \
  --ast
```

### enforce-naming

Enforce naming conventions across your codebase.

```bash
refac enforce-naming [options]
```

**Options:**
- `--style`: Naming style (camelCase, PascalCase, snake_case, UPPER_SNAKE_CASE)
- `--type`: Target type (functions, variables, classes, constants)
- `--fix`: Automatically fix violations

**Examples:**
```bash
# Check naming violations
refac enforce-naming --style camelCase --type functions

# Fix violations automatically
refac enforce-naming --style PascalCase --type classes --fix
```

## Configuration

### Configuration File

Create a `.refacrc` or `refac.config.js` file:

```json
{
  "language": "javascript",
  "parser": {
    "ecmaVersion": 2022,
    "sourceType": "module"
  },
  "exclude": [
    "node_modules/**",
    "dist/**",
    "*.min.js"
  ],
  "include": [
    "src/**/*.js",
    "lib/**/*.js"
  ],
  "rules": {
    "naming": {
      "functions": "camelCase",
      "classes": "PascalCase",
      "constants": "UPPER_SNAKE_CASE",
      "variables": "camelCase"
    },
    "complexity": {
      "maxFunctionLength": 50,
      "maxFileLength": 300,
      "maxParameters": 5
    }
  },
  "transformations": {
    "modernize": true,
    "removeDeadCode": true,
    "optimizeImports": true
  },
  "safeMode": true,
  "backup": {
    "enabled": true,
    "directory": ".refac-backup"
  }
}
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `REFAC_CONFIG` | Configuration file path | `.refacrc` |
| `REFAC_LANG` | Default language | Auto-detect |
| `REFAC_SAFE_MODE` | Enable safe mode | `true` |
| `REFAC_COLOR` | Enable colored output | `true` |
| `REFAC_LOG_LEVEL` | Log level (error, warn, info, debug) | `info` |

## Language Support

### JavaScript/TypeScript

Full support for ES2022+ features:
- Classes and decorators
- Async/await
- Modules (ESM and CommonJS)
- JSX/TSX
- Type annotations

### Python

Support for Python 3.6+:
- Classes and decorators
- Async functions
- Type hints
- f-strings

### Java

Support for Java 8+:
- Classes and interfaces
- Lambdas
- Generics
- Annotations

### Other Languages

Basic support for:
- C/C++
- Go
- Ruby
- PHP
- Rust

## Exit Codes

| Code | Description |
|------|-------------|
| 0 | Success |
| 1 | General error |
| 2 | Invalid arguments |
| 3 | File not found |
| 4 | Parse error |
| 5 | Configuration error |
| 6 | No changes needed |
| 7 | User cancelled |

## Programmatic API

Use Refac in your Node.js applications:

```javascript
const refac = require('refac');

// Rename function
await refac.renameFunction({
  oldName: 'getUserData',
  newName: 'fetchUserData',
  path: './src',
  preview: false
});

// Extract method
const result = await refac.extractMethod({
  pattern: 'complex calculation',
  name: 'calculateResult',
  path: './utils.js'
});

// Custom transformation
await refac.transform({
  pattern: /console\.log/g,
  replacement: 'logger.debug',
  path: './src'
});
```

## Advanced Patterns

### AST Pattern Matching

Use AST patterns for precise matching:

```bash
# Match specific function calls
refac transform \
  --pattern 'fetch($url).then($handler)' \
  --replacement 'await fetch($url)' \
  --ast

# Match conditional returns
refac transform \
  --pattern 'if ($cond) { return $val1; } else { return $val2; }' \
  --replacement 'return $cond ? $val1 : $val2;' \
  --ast
```

### Batch Operations

Create complex refactoring scripts:

```bash
#!/bin/bash
# refactor-legacy.sh

# Step 1: Update variable declarations
refac transform --pattern 'var' --replacement 'const' --path ./legacy

# Step 2: Convert functions to arrow functions
refac modernize-functions --arrow --path ./legacy

# Step 3: Extract constants
refac extract-constants --to ./constants.js --path ./legacy

# Step 4: Enforce naming conventions
refac enforce-naming --fix --config .refacrc --path ./legacy
```

## Troubleshooting

### Common Issues

**Parse Errors:**
```bash
# Increase parser tolerance
refac rename-function oldName newName --parser-strict false

# Specify language explicitly
refac rename-function oldName newName --language javascript
```

**Performance:**
```bash
# Limit scope for large codebases
refac rename-variable foo bar --include "src/components/**"

# Use parallel processing
refac transform --pattern "old" --replacement "new" --parallel 4
```

**Memory Issues:**
```bash
# Process in batches
refac rename-function oldFunc newFunc --batch-size 100

# Increase memory limit
NODE_OPTIONS="--max-old-space-size=4096" refac transform --pattern "pattern"
```