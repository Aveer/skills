# Typography

Optional design-engineering observations adapted from the upstream MIT-licensed
skill; the product's typography, localization and accessibility rules govern.

- `text-wrap: balance` can improve short multi-line headings; `text-wrap: pretty`
  can improve selected prose. Inspect actual widths, languages and rendering cost;
  ordinary wrapping, line clamping or a deliberately single-line control may fit
  better. Use supported browser features only.
- `font-variant-numeric: tabular-nums` can keep changing counters, timestamps and
  aligned numeric columns stable if the selected font supports it. Proportional
  digits remain appropriate for other text.
- Font smoothing is platform- and font-dependent. Inspect the rendering; do not
  apply root-wide antialiasing, substitute fonts or change text weight simply
  because a sample uses it.
- Preserve readability and access to full labels at narrow widths, high zoom,
  keyboard focus and relevant localized text. Follow the existing typography
  hierarchy, semantic styles and theme rather than prescribing new defaults.
