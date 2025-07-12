---
title: Installation
layout: default
---

## Pre-built Binaries

Download the latest release for your platform:

- [Windows (x64)](/downloads/refac-win-x64.zip)
- [macOS (Apple Silicon)](/downloads/refac-macos-arm64.tar.gz)
- [Linux (x64)](/downloads/refac-linux-x64.tar.gz)

## From Source

1. Install Rust toolchain:
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

2. Build and install:
```bash
cargo install refac-tool
```

## Verify Installation
```bash
refac --version
# refac 1.0.0
```

## Docker Usage
```bash
docker run -v $(pwd):/data ghcr.io/your-repo/refac /data "old" "new"
```