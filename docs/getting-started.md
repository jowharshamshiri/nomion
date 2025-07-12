---
layout: default
title: Getting Started with Refac
---

# Getting Started with Refac

This guide will help you get up and running with Refac in just a few minutes. By the end of this tutorial, you'll understand the core concepts and be ready to start refactoring your codebase.

## Prerequisites

Before installing Refac, ensure you have:

- Node.js 14.0 or higher
- npm or yarn package manager
- Git (recommended for version control integration)

## Installation

Install Refac globally using npm:

```bash
npm install -g refac
```

Or using yarn:

```bash
yarn global add refac
```

Verify the installation:

```bash
refac --version
```

## Core Concepts

### Refactoring Operations

Refac supports various refactoring operations:

- **Rename**: Change names of variables, functions, classes, and more
- **Extract**: Pull out code into functions, methods, or modules
- **Inline**: Replace function calls with their implementation
- **Move**: Relocate code between files or modules
- **Transform**: Apply custom transformations using patterns

### Pattern Matching

Refac uses powerful pattern matching to identify code structures:

```javascript
// Match any function named 'calculate*'
refac rename-function 'calculate*' 'compute$1' --path ./src

// Match specific patterns
refac extract-method --pattern 'if (user.role === "admin")' --path ./auth
```

### Safe Mode

Always preview changes before applying them:

```bash
# Preview mode shows what will change
refac rename-variable oldVar newVar --preview

# Dry run creates a diff without modifying files
refac extract-function --dry-run --output changes.diff
```

## Your First Refactoring

Let's walk through a simple example. Suppose you have this JavaScript code:

```javascript
// utils.js
function calculateTotal(items) {
  let total = 0;
  for (let item of items) {
    total += item.price * item.quantity;
  }
  return total;
}
```

### Step 1: Rename the Function

```bash
refac rename-function calculateTotal computeTotal --path utils.js
```

### Step 2: Extract Tax Calculation

If you want to extract tax calculation logic:

```bash
refac extract-method \
  --pattern 'total += item.price * item.quantity' \
  --name calculateItemSubtotal \
  --path utils.js
```

### Step 3: Review Changes

Always review the changes:

```bash
git diff utils.js
```

## Configuration

Create a `.refacrc` file in your project root for project-specific settings:

```json
{
  "language": "javascript",
  "exclude": ["node_modules", "dist", "build"],
  "rules": {
    "naming": {
      "functions": "camelCase",
      "classes": "PascalCase",
      "constants": "UPPER_SNAKE_CASE"
    }
  },
  "safeMode": true
}
```

## Best Practices

### 1. Start Small
Begin with simple refactorings on a small codebase to get familiar with the tool.

### 2. Use Version Control
Always commit your code before running refactoring operations:

```bash
git add .
git commit -m "Before refactoring"
refac rename-function oldFunc newFunc --path ./src
```

### 3. Test After Refactoring
Run your test suite after each refactoring operation:

```bash
refac extract-method --pattern 'complex logic' --path ./src
npm test
```

### 4. Batch Operations
Group related refactorings together:

```bash
# Create a refactoring script
cat > refactor-auth.sh << EOF
#!/bin/bash
refac rename-function authenticate authenticateUser --path ./auth
refac rename-variable token authToken --path ./auth
refac extract-method --pattern 'validate token' --name validateAuthToken
EOF

chmod +x refactor-auth.sh
./refactor-auth.sh
```

## Common Use Cases

### Modernizing Legacy Code

```bash
# Convert var to const/let
refac transform-var-declarations --path ./legacy

# Update function syntax
refac modernize-functions --arrow-functions --path ./src
```

### Consistent Naming

```bash
# Enforce naming conventions
refac enforce-naming --config .refacrc --path ./src

# Fix inconsistent casing
refac fix-casing --style camelCase --type functions --path ./
```

### Code Organization

```bash
# Move utilities to separate module
refac move-functions --pattern 'util*' --to ./utils/index.js

# Extract constants
refac extract-constants --to ./constants.js --path ./src
```

## Next Steps

Now that you understand the basics:

1. Explore the [Usage Guide]({{ '/usage/' | relative_url }}) for advanced features
2. Check out [Examples]({{ '/examples/' | relative_url }}) for real-world scenarios
3. Read the [API Reference]({{ '/api-reference/' | relative_url }}) for all available commands

## Getting Help

- Run `refac help` for command documentation
- Use `refac <command> --help` for specific command help
- Visit our [GitHub Issues](https://github.com/jowharshamshiri/refac/issues) for support

Happy refactoring!