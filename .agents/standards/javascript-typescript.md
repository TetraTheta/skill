# JavaScript & TypeScript Standards

## Formatter / Linter Preferences
- **Preferred Stack**: Use **ESLint + Prettier ESLint** for JavaScript/TypeScript projects.
- **Config Location**: Prefer dedicated config files (for example, `eslint.config.mjs`, `.prettierrc.*`) instead of embedding tool config in `package.json`.

## Tooling Dependency Policy
- **Baseline Dependencies**: Keep `prettier`, `eslint`, and `prettier-eslint` in project dependencies so the editor workflow stays deterministic across environments.
- **TypeScript Scope**: In TypeScript projects, manage `@typescript-eslint/parser` and `typescript` as a matched pair to avoid parser/runtime drift.
- **Vue Scope**: Add `vue-eslint-parser` only when Vue SFC parsing is part of the project.
- **Version Strategy**: Treat the workspace-local ESLint as the source of truth for editor linting, and pin exact versions only when the repository explicitly requires strict reproducibility.

## Syntax
- **Semicolons**: Always use explicit semicolons (`;`) — never rely on ASI.
- **Indentation**: Follow `.editorconfig` (default: 2 spaces).
- **Quotes**: Prefer single quotes for strings; use template literals when interpolating.

## Language Features
- **Target**: ES2020+ — use modern syntax actively:
  - Optional chaining (`?.`)
  - Nullish coalescing (`??`) and nullish assignment (`??=`)
  - Dynamic `import()`
  - `Promise.allSettled`, `Promise.any`
  - Logical assignment operators (`||=`, `&&=`)
- **Avoid**: `var`. Use `const` by default, `let` only when reassignment is necessary.
- **Arrow functions**: Prefer for callbacks and short expressions; use named `function` declarations for top-level functions to aid stack traces.

## Documentation
- Use JSDoc for public APIs, exported functions, complex types, and non-obvious behavior.
- Match the project's dominant documentation language unless the user explicitly requests Korean documentation.

## TypeScript-specific
- **Strict mode**: Always enable `"strict": true` in `tsconfig.json`.
- **Type annotations**: Required on all function parameters and return types. Avoid `any`; prefer `unknown` when the type is genuinely unknown.
- **Interfaces vs Types**: Use `interface` for object shapes that may be extended; use `type` for unions, intersections, and aliases.
