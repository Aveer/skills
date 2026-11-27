# Interaction rendering

Optional observations adapted from the upstream MIT-licensed skill.

- Narrowing transition properties can avoid unintended transitions and make
  behavior clearer when it addresses an observed problem. Respect existing
  styling conventions; do not perform a blanket rewrite of transition rules.
- Transform and opacity animations can sometimes be less expensive than
  layout-affecting changes. Actual rendering and composition costs depend on
  the browser, content, layers and effects.
- Layer hints such as `will-change` can help a measured rendering issue, but can
  increase memory consumption and complexity. Add them only where justified
  and consider their lifetime; do not add them as a standard recipe.
- Diagnose slow interaction in the relevant environment and use existing
  project verification. Avoid new instrumentation, tooling, architecture or
  full builds merely to comply with this reference.
