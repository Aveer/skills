---
name: make-interfaces-feel-better
description: Use as optional design-engineering reference for an explicitly requested UI polish or a specific problem with feedback, motion, readability, alignment or perceived responsiveness. Not a general frontend workflow or a reason to redesign existing screens.
license: MIT
---

# Details that make interfaces feel better

Identify the actual user-facing defect and inspect the existing design language,
shared controls, states and layout. Use the product's own visual and interaction
contracts, accessibility, density, localization and performance requirements.
This skill is a source of ideas, not a second design system or acceptance gate.

- Consider clearer state feedback, readable labels, optical alignment, stable
  geometry and coherent treatment of related controls when they solve the problem.
- Motion is optional. Stillness, immediate state changes or existing animations
  may be the right choice. Consider interruptibility and reduced motion when
  animation is relevant. Do not add effects solely to make a screen feel polished.
- Consider wrapping, numeric alignment and target spacing in context; preserve
  useful density, keyboard access and existing product behavior.
- Prefer fixing a genuine shared-control defect at its existing owner. A local
  exception can be appropriate for a real feature-specific need.

Use any suitable technique within the requested scope, including alternatives
not described here. No prescribed animation, easing, duration, scale, radius,
shadow, border, color, font, framework, hit-area size, review format, or
additional dependency follows from this skill. Do not require changes or checks
beyond the project's actual acceptance criteria just to satisfy an example.
Do not silently change established product decisions; raise evidence of a defect
through the appropriate owner if a change to those decisions is warranted.

Optional references: [typography](typography.md), [surfaces](surfaces.md),
[animations](animations.md), [performance](performance.md).
Read only the material relevant to the specific problem.
