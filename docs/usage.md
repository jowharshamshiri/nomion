---
title: Usage Guide
layout: default
---

## Basic Commands

### Rename files and content
```bash
refac /project/path "oldString" "newString"
```

### Preview changes (dry-run)
```bash
refac . "deprecated" "updated" --dry-run
```

### Only process specific files
```bash
refac . "old" "new" --include "*.rs" --include "*.toml"
```

## Advanced Options

| Option | Description |
|--------|-------------|
| `--max-depth N` | Limit directory traversal depth |
| `--threads N`   | Set number of processing threads |
| `--backup`      | Create backups before modification |
| `--ignore-case` | Case-insensitive matching |
| `--progress`    | Show progress display (auto/always/never) |

## Exit Codes

| Code | Meaning |
|------|---------|
| 0    | Success |
| 1    | General error |
| 2    | Invalid arguments |
| 3    | Collision detected |
| 4    | Permission denied |