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
