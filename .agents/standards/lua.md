# Lua Standards

## Tooling
- Actively use LuaLS for Lua projects.
- Check whether the project root contains a LuaLS configuration file, such as `.luarc.json`, and follow it when present.
- Use LuaLS documentation comments (`---@...`) when they help prevent diagnostics, type ambiguity, or editor warnings.

## Garry's Mod Lua (GLua)
- Prefer the Garry's Mod documentation at `https://gmodwiki.com/`.
- Fall back to `https://wiki.facepunch.com/gmod` only when `https://gmodwiki.com/` is unavailable.
- Use both `glualint` and LuaLS for linting GLua code.
- Use LuaLS for formatting GLua code.
