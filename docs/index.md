---
layout: default
title: Refac - Modern Code Refactoring Tool
toc: false
---

# Welcome to Refac

Refac is a powerful command-line tool designed to automate code refactoring tasks across multiple programming languages. Built with modern development practices in mind, Refac helps you maintain clean, consistent, and maintainable codebases at scale.

## Key Features

- **Multi-Language Support**: Refactor code in Python, JavaScript, TypeScript, Java, C++, and more
- **Pattern-Based Transformations**: Use sophisticated pattern matching to identify and transform code structures
- **Safe Refactoring**: Preview changes before applying them to ensure accuracy
- **Batch Processing**: Apply refactoring rules across entire codebases efficiently
- **Extensible Architecture**: Add custom refactoring rules and language support
- **Git Integration**: Seamlessly works with version control systems

## Quick Start

```bash
# Install Refac
npm install -g refac

# Run a simple refactoring
refac rename-function oldName newName --path ./src

# Preview changes without applying
refac extract-method --preview --path ./src/utils.js
```

## Why Refac?

### Consistency at Scale
Maintain consistent coding standards across large codebases with automated refactoring rules.

### Time-Saving
Reduce hours of manual refactoring to minutes with intelligent pattern matching.

### Error Prevention
Eliminate human errors in repetitive refactoring tasks with automated transformations.

### Language Agnostic
Work seamlessly across different programming languages with unified commands.

## Get Started

<div class="alert alert-info">
  <strong>New to Refac?</strong> Check out our <a href="{{ '/getting-started/' | relative_url }}">Getting Started Guide</a> for a comprehensive introduction.
</div>

Ready to transform your codebase? Explore our documentation:

- [Installation Guide]({{ '/installation/' | relative_url }}) - Set up Refac on your system
- [Usage Guide]({{ '/usage/' | relative_url }}) - Learn basic and advanced usage patterns
- [API Reference]({{ '/api-reference/' | relative_url }}) - Detailed command and option reference
- [Examples]({{ '/examples/' | relative_url }}) - Real-world refactoring scenarios
- [Contributing]({{ '/contributing/' | relative_url }}) - Join the Refac community

## Community & Support

- **GitHub**: [jowharshamshiri/refac](https://github.com/jowharshamshiri/refac)
- **Issues**: [Report bugs or request features](https://github.com/jowharshamshiri/refac/issues)
- **Discussions**: [Join the conversation](https://github.com/jowharshamshiri/refac/discussions)

## License

Refac is open source software licensed under the MIT License.