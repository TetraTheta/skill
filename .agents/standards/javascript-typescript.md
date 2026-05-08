# JavaScript & TypeScript Standards

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
- **Arrow functions**: Prefer for callbacks and short expressions; use named `function`
  declarations for top-level functions to aid stack traces.

## TypeScript-specific

- **Strict mode**: Always enable `"strict": true` in `tsconfig.json`.
- **Type annotations**: Required on all function parameters and return types. Avoid `any`;
  prefer `unknown` when the type is genuinely unknown.
- **Interfaces vs Types**: Use `interface` for object shapes that may be extended; use
  `type` for unions, intersections, and aliases.
