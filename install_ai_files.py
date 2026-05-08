#!/usr/bin/env python3
"""Install reusable AI tool instruction assets into a home directory."""

from __future__ import annotations

import argparse
import shutil
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Literal

ToolName = Literal["codex", "claude", "all"]

TOOL_CHOICES: tuple[ToolName, ...] = ("codex", "claude", "all")
ASSET_SECTIONS: tuple[str, ...] = ("skills", "tools", "standards")
FRONTMATTER_DELIMITER = "---"
CONTENT_SEPARATOR = "\n\n---\n\n"


class ConfigError(RuntimeError):
    """Raised when the repository layout cannot support installation."""


class InstallArgs(argparse.Namespace):
    tool: ToolName
    home: Path
    claude_target: Path | None
    dry_run: bool


@dataclass(frozen=True)
class InstallPlan:
    repo_root: Path
    standards_dir: Path
    home_dir: Path
    tool: ToolName
    claude_target: Path | None
    dry_run: bool


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Install Codex/Claude instruction files into a home directory",
    )
    parser.add_argument(
        "--tool",
        choices=TOOL_CHOICES,
        default="all",
        help="Which tool files to install (default: all)",
    )
    parser.add_argument(
        "--home",
        type=Path,
        default=Path.home(),
        help="Home directory to install into (default: current user's home)",
    )
    parser.add_argument(
        "--claude-target",
        type=Path,
        default=None,
        help="Optional explicit CLAUDE.md target path (default: <home>/CLAUDE.md)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be written without modifying files",
    )
    return parser


def parse_args() -> InstallArgs:
    return build_parser().parse_args(namespace=InstallArgs())


def resolve_user_path(path: Path) -> Path:
    return path.expanduser().resolve()


def create_install_plan(args: InstallArgs) -> InstallPlan:
    repo_root = Path(__file__).resolve().parent
    standards_dir = repo_root / ".agents" / "standards"
    claude_target = resolve_user_path(args.claude_target) if args.claude_target is not None else None

    return InstallPlan(
        repo_root=repo_root,
        standards_dir=standards_dir,
        home_dir=resolve_user_path(args.home),
        tool=args.tool,
        claude_target=claude_target,
        dry_run=args.dry_run,
    )


def strip_frontmatter(text: str) -> str:
    lines = text.splitlines()
    has_frontmatter = len(lines) >= 3 and lines[0].strip() == FRONTMATTER_DELIMITER

    if not has_frontmatter:
        return text

    for index, line in enumerate(lines[1:], start=1):
        if line.strip() == FRONTMATTER_DELIMITER:
            return "\n".join(lines[index + 1 :]).lstrip("\n")

    return text


def collect_rule_files(standards_dir: Path) -> list[Path]:
    if not standards_dir.is_dir():
        raise ConfigError(f"standards directory not found: {standards_dir}")

    rule_files = sorted(standards_dir.glob("*.md"))
    general_rule = standards_dir / "general.md"

    if general_rule not in rule_files:
        return rule_files

    return [general_rule, *[path for path in rule_files if path != general_rule]]


def build_combined_content(standards_dir: Path) -> str:
    rule_files = collect_rule_files(standards_dir)

    if not rule_files:
        raise ConfigError(f"No standards markdown files found in: {standards_dir}")

    chunks = [read_rule_content(rule_file) for rule_file in rule_files]
    return f"{CONTENT_SEPARATOR.join(chunks)}\n"


def read_rule_content(rule_file: Path) -> str:
    raw_content = rule_file.read_text(encoding="utf-8")
    return strip_frontmatter(raw_content).strip()


def write_text(target: Path, content: str, dry_run: bool) -> None:
    if dry_run:
        print(f"  - would write {target}")
        return

    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(content, encoding="utf-8", newline="\n")
    print(f"  - wrote {target}")


def install_codex(content: str, home_dir: Path, dry_run: bool) -> None:
    write_text(home_dir / ".codex" / "AGENTS.md", content, dry_run)


def install_claude(
    content: str,
    home_dir: Path,
    claude_target: Path | None,
    dry_run: bool,
) -> None:
    target = claude_target if claude_target is not None else home_dir / "CLAUDE.md"
    write_text(target, content, dry_run)


def sync_agents_directory(repo_root: Path, home_dir: Path, dry_run: bool) -> None:
    source_root = repo_root / ".agents"
    target_root = home_dir / ".agents"

    for section in ASSET_SECTIONS:
        sync_agent_section(source_root / section, target_root / section, dry_run)


def sync_agent_section(source: Path, target: Path, dry_run: bool) -> None:
    if not source.is_dir():
        return

    if dry_run:
        print(f"  - would sync {source} -> {target}")
        return

    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copytree(source, target, dirs_exist_ok=True)
    print(f"  - synced {source} -> {target}")


def install_tools(plan: InstallPlan, content: str) -> None:
    if plan.tool in {"codex", "all"}:
        install_codex(content, plan.home_dir, plan.dry_run)

    if plan.tool in {"claude", "all"}:
        install_claude(content, plan.home_dir, plan.claude_target, plan.dry_run)


def print_install_header(plan: InstallPlan) -> None:
    print(f"Source standards: {plan.standards_dir}")
    print(f"Install home:     {plan.home_dir}")
    print(f"Tool selection:   {plan.tool}")


def run_install(args: InstallArgs) -> int:
    plan = create_install_plan(args)
    content = build_combined_content(plan.standards_dir)

    print_install_header(plan)
    sync_agents_directory(plan.repo_root, plan.home_dir, plan.dry_run)
    install_tools(plan, content)
    print("Done.")

    return 0


def main() -> int:
    try:
        return run_install(parse_args())
    except ConfigError as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
