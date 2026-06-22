---
name: coding-standards
description: >
  Codex-first coding standards bundle for reusable local skills.
  Primary target is OpenAI Codex with secondary compatibility for Claude Code.
  Includes general, frontend, Java, JavaScript/TypeScript, Kotlin, and Python rules.
---

# Coding Standards

This repository ships reusable AI tool assets with this layout:

- `.agents/`: shared skills, tools, and standards source
- `.codex/`: Codex-specific global config destination structure

## Tool Priority

- Primary: OpenAI Codex
- Secondary: Anthropic Claude Code

## Canonical Standards Source

- `.agents/standards/*.md` (`general.md` first, then alphabetical)

## Installer

Run from repo root:

```bash
python install_ai_files.py
```

Useful options:

```bash
python install_ai_files.py --tool codex
python install_ai_files.py --tool claude
python install_ai_files.py --home /path/to/home
python install_ai_files.py --claude-target /path/to/CLAUDE.md
python install_ai_files.py --dry-run
```

## Copy-to-home workflow

- Copy `<repo>/.agents` to `$HOME/.agents`
- Copy `<repo>/.codex` to `$HOME/.codex` (or install with the script)

## Standards Files

- [General](.agents/standards/general.md)
- [Frontend](.agents/standards/frontend.md)
- [Java](.agents/standards/java.md)
- [JavaScript & TypeScript](.agents/standards/javascript-typescript.md)
- [Kotlin](.agents/standards/kotlin.md)
- [Python](.agents/standards/python.md)
