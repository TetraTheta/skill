# Python Standards

## Formatting

- **Indentation**: Follow `.editorconfig` (default: 4 spaces).
- **Style Guide**: Adhere to **PEP 8** unless the project enforces a stricter formatter
  (e.g., Black, Ruff). When a formatter is configured, let it take full control — do not
  manually adjust spacing to override it.
- **Line length**: 88 characters (Black default); fall back to PEP 8's 79 if no formatter
  is configured.

## Type Hinting

- **Mandatory** on all function signatures (parameters and return types).
- Use for complex or non-obvious variable declarations.
- Prefer built-in generics (`list[str]`, `dict[str, int]`) over `typing.List`/`typing.Dict`
  (Python 3.9+).
- Use `X | Y` union syntax over `Union[X, Y]` (Python 3.10+).

## Type Safety

- NEVER use `typing.cast()` or any explicit type coercion to silence type errors.
- Using `typing.cast()` to bypass type checking is considered a bug, not a fix.
- Do NOT use `cast(Any, ...)`, `cast(...)`, `Any`, or similar constructs to bypass static
  type checking.
- Fix the root cause of the mismatch, align annotations with runtime behavior, and refactor
  APIs or abstractions when needed (e.g., `Protocol`, generics, interface redesign).

## Error Handling Philosophy

- Treat type checker errors as real design issues.
- Never resolve them by masking or bypassing the type system.

## Behavior Preservation

- Preserve existing runtime behavior unless a behavior change is explicitly requested.
- Minimize change scope while ensuring correctness.

## Impact Validation

- After Python type-related changes, review all affected call sites and usages.
- Verify no new type mismatches are introduced elsewhere.
- Check for runtime incompatibilities, logical regressions, or unintended behavior changes.
- A type fix is not complete until affected usages are validated.

## Exception

- `typing.cast()` may only be used if explicitly requested.
- In that case, explain why it is safe and does not introduce runtime risk.

## String Formatting

- Use **f-strings** for all string interpolation — they are more readable and faster than
  `%`-formatting or `str.format()`.
- Exception: logging calls — use `%`-style or `logging.Logger` lazy formatting to avoid
  evaluating the string when the log level is suppressed.

## General

- Prefer **high-level APIs**: `pathlib.Path` over `os.path`, `subprocess.run` over
  `os.system`, etc.
- Use context managers (`with`) for all resource management (files, connections, locks).
- Avoid mutable default arguments; use `None` as sentinel and initialize inside the function.

## CLI Script Conventions

- For `argparse`-based scripts, place argument parser/options definition near the top of the
  file so available switches can be identified quickly during review.
- For `argparse`, define and use a custom namespace class.
