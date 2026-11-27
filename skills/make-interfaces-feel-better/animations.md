# Motion and interaction feedback

Optional observations adapted from the upstream MIT-licensed skill.
Motion is not a requirement. Existing product motion policy, actual behavior,
accessibility and user preference determine whether and how to animate.

- An interruptible transition can make reversal of an interactive state feel
  coherent. CSS transitions, existing framework facilities, immediate updates
  and other techniques are all valid depending on state and lifecycle.
- Staggering entrances can communicate relationships in some compositions, but
  can introduce latency and visual noise in dense workspaces or repeated
  actions. No fixed delay or stagger is prescribed.
- Exit motion can clarify where content went, but should not delay interaction,
  cancellation or state publication. Do not retain stale interactive content
  solely for an animation.
- Icon swaps may use a simple state change or a cross-fade where it clarifies
  meaning. Ensure correct accessible names, focus and disabled/loading state;
  duplicating DOM icons or introducing blur, scaling or spring motion is not
  inherently an improvement.
- Press feedback may be an existing color, border, focus or state treatment.
  Scale effects are optional and may be undesirable in stable, dense controls.
- Consider whether initial rendering benefits from motion; no mandatory
  entrance animation or blanket ban follows from this reference.
- Honor reduced motion and use the product's existing mechanism if appropriate.
  Do not prescribe a library, duration, easing, scale or spring parameter.
