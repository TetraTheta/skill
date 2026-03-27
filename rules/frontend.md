# Frontend Standards

## HTML & Embedded Content

- **Indentation**: CSS inside `<style>` and JS inside `<script>` tags must use 2-space
  indentation, matching the surrounding HTML structure.
- **Separation of Concerns**: Prefer external files over inline styles/scripts. Exception:
  single-file prototypes (e.g., standalone Claude artifacts).

## UI/UX Design

- **Design Philosophy**: Apply **Flat Design** — minimize gradients, drop shadows, and 3D
  effects. Emphasize clarity, whitespace, and typography.
- **Primary Typeface**: Use **Pretendard Variable**.
  - Load via CDN:
    ```
    https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable.min.css
    ```
  - Apply as: `font-family: "Pretendard Variable", Pretendard, -apple-system, sans-serif;`
    on `:root` or `body`.
- **Responsiveness**: All components must be **Mobile-First** and fully responsive.

## CSS / Styling

- **Naming Convention**: Use **BEM** (Block__Element--Modifier), or follow the project's
  existing convention if one is established.
- **Layout**: Prefer **Flexbox** and **CSS Grid** over older float/positioning techniques.
- **Modern CSS**: Use custom properties (`--var`), logical properties, and container queries
  where appropriate.
