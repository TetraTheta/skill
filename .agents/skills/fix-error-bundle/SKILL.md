---
name: fix-error-bundle
description: Fix one or more code errors from structured input containing file path or file content, failing code, and diagnostics from linters, type checkers, compilers, tests, or runtime errors.
---

You are handling a structured error-fix bundle.

The user may provide one or more cases. Each case contains:

- `file_or_path`: either a file path or the full file content
- `failing_code`: the code region related to the error
- `diagnostics`: linter, type checker, compiler, test, or runtime error messages

## Workflow

1. Treat the structured fields as authoritative.
2. Do not ask the user to wrap code or diagnostics in Markdown fences.
3. For each case, determine whether `file_or_path` is a path or inline file content.
4. If it is a path and the file exists in the workspace, inspect the actual file.
5. Do not limit analysis to the provided snippet if related files, imports, call sites, or type definitions are needed.
6. Map diagnostics to the smallest relevant code region.
7. Identify the root cause, not only the reported line.
8. If multiple cases share one root cause, fix the shared cause once.
9. Make the smallest safe change that resolves the root cause across the affected type graph, not merely the smallest local edit.
10. Preserve existing runtime behavior unless the user explicitly requests a behavior change.

## Python type safety rules

When writing or modifying Python code:

- NEVER use `typing.cast()` or any form of explicit type coercion to silence type errors.
- Using `typing.cast()` to bypass type checking is considered a bug, not a fix.
- Do NOT use `cast(Any, ...)`, `cast(...)`, `Any`, or similar constructs to bypass static type checking.

Instead:

- Fix the root cause of the type mismatch.
- Adjust type annotations so they correctly reflect actual runtime types.
- Refactor code so that types align naturally.
- Introduce proper abstractions when necessary, such as `Protocol`, generics, or interface redesign.

## Error handling philosophy

- Treat type checker errors as real design issues, not something to suppress.
- Never resolve them by masking or bypassing the type system.

## Behavior preservation

- Preserve existing runtime behavior unless the user explicitly requests a change.
- Minimize the scope of changes while ensuring correctness.

## Type impact analysis

When fixing type errors, do not optimize only for the smallest local edit.

Before changing any of the following, analyze downstream and upstream impact:

- function return types
- parameter types
- class attributes
- dataclass fields
- TypedDict fields
- Protocol or ABC methods
- generic type parameters
- overloads
- public API signatures
- values shared across module boundaries

For each candidate fix, determine whether the root cause is:

1. the producer returns or exposes the wrong type,
2. the consumer expects the wrong type,
3. the annotation is narrower or wider than the actual runtime behavior,
4. a missing runtime branch or invariant check,
5. an interface or abstraction boundary mismatch.

Prefer the fix that makes the type model consistent across all affected call sites.

Do not change a return type merely to satisfy one caller if other callers rely on the existing contract.

Do not change a caller merely to satisfy one callee if the callee annotation is inconsistent with its actual runtime behavior.

If changing a signature or return type is necessary:

1. inspect all call sites,
2. update affected annotations and usages together,
3. preserve runtime behavior,
4. run the project-appropriate type checker after the full set of changes.

## Impact validation

After changes:

1. Review all call sites and usages of modified code.
2. Verify that no type mismatches are introduced elsewhere.
3. Check for runtime incompatibilities, logical regressions, or unintended behavior changes.
4. Before reporting completion, validate that the fix does not move the same type mismatch to another caller, callee, module, or return path.

For Python code changes:

1. If the project defines a specific validation command in ``.codex/AGENTS.md`, `AGENTS.md`, `README.md`, `Makefile`, `tox.ini`, `noxfile.py`, `pyproject.toml`, or CI configuration, prefer the project-defined command.
2. Detect the project environment before running Python validation commands:
   - If the project contains `uv.lock`, `[tool.uv]` in `pyproject.toml`, or documented commands using `uv run`, treat it as a `uv` project and prefer `uv run <command>`.
   - If the project appears to use Poetry, PDM, Hatch, tox, or nox, prefer the corresponding documented command form.
   - If no project environment manager is detected, and the command is available on PATH, run it directly.
3. If the diagnostics mention `pyright`, or if the project contains `pyrightconfig.json` or `[tool.pyright]` in `pyproject.toml`, run the appropriate Pyright command:
   - For `uv` projects: `uv run pyright`
   - Otherwise: `pyright`
4. If the diagnostics mention `mypy`, or if the project contains mypy configuration in `pyproject.toml`, `mypy.ini`, `setup.cfg`, or `tox.ini`, run the appropriate mypy command:
   - For `uv` projects: `uv run mypy .`
   - Otherwise: `mypy .`
5. If both Pyright and mypy appear to be configured, run both.
6. If a validation command fails because the command is missing, the environment is unavailable, or dependencies are not installed, report:
   - the exact command attempted
   - the exact failure reason
   - what validation remains manual

A fix is not complete until affected usages are validated.

## Optional improvements

- Do NOT introduce behavioral changes, optimizations, or redesigns silently.
- Provide them separately as clearly labeled optional suggestions.

## Exception

- `typing.cast()` may only be used if explicitly requested by the user.
- In that case, explain why it is safe and does not introduce runtime risk.

## Response format

After completing the work, report in Korean:

- 변경한 파일
- 근본 원인
- 타입 영향 범위
- 정확한 수정 내용
- 실행한 검증 명령
- 검증 결과
- 남은 불확실성, 있는 경우
- 선택 제안, 관련 있는 경우만

Do not say that full-project validation was skipped because the command was unspecified if a project-appropriate validation command could be inferred, such as `uv run pyright`, `pyright`, `uv run mypy .`, `mypy .`, or another configured command.

## Language

- All explanations, comments, and docstrings must be written in Korean.
