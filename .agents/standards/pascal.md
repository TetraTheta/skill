# Pascal Standards

## Tooling
- Prefer validating Lazarus projects with the same primary config path used by the IDE. Packages installed in the IDE are recorded in the user's Lazarus configuration, so running `lazbuild` with a temporary `--pcp` path can make valid packages appear as `Broken dependency`.
- Do not remove Lazarus packages from `.lpi` `RequiredPackages` only because CLI build cannot find them. First verify the IDE config path, package installation location, and project intent.
- After GUI form changes, run at least `lazbuild <project>.lpi`. If form creation, widgetset behavior, or theme packages are involved, also verify by running from the IDE.

## Lazarus Forms
- If an `.lfm` file directly names a custom control class, the Lazarus form designer must know that class at design time. `RegisterClass` in a project unit is not always enough for designer loading.
- Register custom controls in a design-time package when they must be placed and edited visually in the form designer.
- For a small behavior change needed only by one form, keep the standard LCL control name in `.lfm` and consider an interposer class in the Pascal unit.
- Do not replace or free `.lfm`-created controls during form creation (`OnCreate`, immediately after `Loaded`, etc.). This can conflict with LCL or widgetset internal references and cause access violations.
- In Lazarus, `Name` is the code identifier; display text is usually `Caption` or `Text`. Labels and buttons normally use `Caption`, while edit-like controls normally use `Text`.

## Numeric Controls
- Do not treat `TFloatSpinEdit.DecimalPlaces` as display-only. It can also affect rounding during value updates.
- When user-entered decimal precision must be preserved, set `DecimalPlaces` high enough and control display string generation separately.
- To remove unnecessary trailing zeroes, prefer overriding `ValueToStr` over manually rewriting `Text` in events. LCL `UpdateControl` can overwrite event-assigned `Text`.
- Keeping `TFloatSpinEdit` in `.lfm` while declaring an interposer class with the same name in the project unit can override virtual behavior such as `ValueToStr` without design-time custom control registration.

## Porting From WinForms
- When porting a WinForms `NumericUpDown` display override such as `UpdateEditText`, first consider mapping it to `TFloatSpinEdit.ValueToStr` in Lazarus.
- Port WinForms designer location, size, tab order, and event wiring by comparing both `.lfm` and the form unit. Do not copy only coordinates while dropping event behavior.
- For behavior that depends on parsing strings, such as ListBox item double-click handlers, verify both the original input/output format and the current locale decimal separator.
- Do not remove existing project packages, theme setup, or resource configuration during a port only because they seem unrelated to the immediate behavior. First confirm whether they are visual or runtime requirements of the original app.
