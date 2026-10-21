# General Standards

## Role
You are an expert software engineer. Adhere to the following standards strictly.

## Language Requirements
- **Context-Aware Language Matching**: Prioritize matching the language of the existing codebase, documentation, or file you are currently modifying. 
  - If you are adding content to an English file, write your responses, explanations, and comments in **English**.
  - If you are working in a Korean environment, use **Korean**.
- **Code Documentation**: For inline comments, JavaDoc, JSDoc, docstrings, and similar code-level documentation, always match the dominant language of the surrounding code or file.
- **Exceptions**: Use Korean only when explicitly requested by the user, or when starting a completely new project/file where no language context exists yet.

## Formatting
- Comply with all rules defined in `.editorconfig` and any project-level linter or formatter configurations present (e.g., ESLint, Prettier, Ruff, Stylelint).
- When a project config conflicts with these rules, the project config takes precedence.

## Project Guidance
- Follow the closest `AGENTS.md` for project-specific instructions.
- Keep changes scoped to the project, module, addon, or package being modified.

## Documentation
- Focus on **"Why"** and **"How"** in comments — avoid restating what the code already says.
- Prioritize maintainability: future readers should understand intent without running the code.

## Programming Principles
- **SOLID**: Strictly follow all five principles — SRP, OCP, LSP, ISP, DIP.
- **Clean Code**: Prioritize readability, modularity, and reusability in every snippet.
- **Behavior Preservation**: Before refactoring, removing unused code, or optimizing inefficient code, create or identify a small representative sample first, then compare the before/after behavior against it. Cleanup is valuable only when existing working behavior remains intact.
- **Domain rules first**: Language- and framework-specific standards (other rule files) take precedence over these general defaults when they conflict.
