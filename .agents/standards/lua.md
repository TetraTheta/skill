# Lua Standards

## Tooling
- Use LuaLS for analysis, diagnostics, and formatting whenever available.
- Check for a project LuaLS configuration (such as `.luarc.json`) at the project root and follow it.
- Use LuaLS documentation comments (`---@...`) whenever they improve type inference, suppress false diagnostics, or clarify APIs.

## Style
- Prefer method-call chaining (for example, `str:Trim():lower()`) over functional forms (for example, `string.lower(string.Trim(str))`) whenever both are supported by the API.
- Keep anonymous functions to a single expression or statement. Otherwise, use a named local function.
- Keep trivial expressions inline instead of extracting helper functions that add names without reducing complexity.

## Garry's Mod Lua (GLua)
- Prefer `https://gmodwiki.com/` as the primary documentation source.
- Use `https://wiki.facepunch.com/gmod` only if the information is unavailable on GMod Wiki.
- Use both `glualint` and LuaLS for diagnostics.
- Continue using LuaLS as the formatter.
- Treat Garry's Mod runtime behavior as unverified until it has been tested in-game.
