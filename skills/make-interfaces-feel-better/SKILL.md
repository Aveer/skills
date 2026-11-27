---
name: make-interfaces-feel-better
description: Optional design review checklist for a specific UI polish problem involving feedback, motion, readability, focus, or visual hierarchy. Use the product's own UI guidance and shared components first.
license: MIT
---

# Details that make interfaces feel better

Start with the actual screen, the interaction that feels off, and an existing
product pattern that solves the same problem. Check the project's tokens,
motion settings, density and component ownership before changing shared UI.
Preserve the project's accessibility requirements and existing dependencies.

- Give actions a clear response using the product's existing hover, press,
  focus, or state-change patterns. Add motion when it clarifies what moved,
  opened, or changed. Dense lists often benefit from stillness.
- Make motion interruptible and honor reduced motion. Transition only the
  relevant properties. Add a layer hint such as `will-change` only when
  profiling shows a benefit and remove it when it is no longer needed.
- Check readability and target spacing at real widths. Consider wrapping,
  static truncation, or a way to expose the full label based on the role of
  the text. Verify focus and touch as well as pointer hover.
- Compare related controls in context before choosing a scale, duration,
  shadow, border, or radius. Reuse shared tokens and components when a
  change should apply across screens.

The accompanying MIT-licensed reference files preserve upstream examples:
[typography](typography.md), [surfaces](surfaces.md),
[animations](animations.md), and [performance](performance.md).
Consult them only when a particular example helps. Their numeric values,
frameworks, and review formats are optional.
