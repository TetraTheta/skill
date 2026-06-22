# Kotlin Standards

## Formatter / Linter Preferences
- Generate Kotlin code in a KtLint-compatible style by default, even when the project does not explicitly configure KtLint.
- When a project configures KtLint, follow the project-local KtLint version, rules, and `.editorconfig`.
- Do not intentionally generate code that violates the KtLint `standard` ruleset unless the project configuration or user request requires it.
- Enable experimental KtLint rules only when the project explicitly adopts them.
- Treat rules that KtLint cannot enforce as review and authoring standards.

## Formatting
- Follow `.editorconfig` and the official Kotlin Coding Conventions unless the project defines stricter local rules.
- Omit semicolons.
- Prefer `val` by default; use `var` only when reassignment is required.

## Class Layout
- Use this default class body order: property declarations and initializer blocks, secondary constructors, methods, companion object, then private nested or helper classes.
- Place the `companion object` at the bottom of the class when there are no private nested or helper classes.
- Place private nested or helper classes below the `companion object`.
- Group fields by responsibility first, then sort fields inside each group by natural ascending order.
- Group methods by reading flow and related behavior first, then sort methods inside each group by natural ascending order.
- Always keep overloads next to each other.

## File Organization and Visibility
- Mark top-level helper types, `data class` declarations, extension functions, and extension properties as `private` when they are used only inside the file.
- Put shared helper types in their own `.kt` file by default.
- Strongly coupled helper types may stay in the same file as top-level declarations.
- Name files after the representative public type, or use an UpperCamelCase name that describes the file's responsibility.

## Public API
- Declare explicit return types and property types for public APIs.
- Write KDoc for public classes, interfaces, methods, and non-obvious behavior.
- Explicitly declare Kotlin types when Java platform types are exposed through public APIs or properties.

## Null Safety and Idioms
- Avoid `!!`; use intent-revealing alternatives such as `requireNotNull`, `checkNotNull`, Elvis return or throw, and safe calls.
- Prefer immutable collection interfaces.
- Use extension functions when there is a meaningful receiver, and apply the narrowest reasonable visibility.
