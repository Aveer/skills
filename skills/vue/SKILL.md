---
name: vue
description: Use for a concrete Vue 3 framework question about reactivity, component or composable contracts, lifecycle, routing, Vue-specific tests or a non-trivial Vue defect. Not required for routine edits that follow project conventions.
license: MIT
---

# Vue 3 Development

Use the installed Vue, Router, compiler and tooling versions and the project's
actual package manager, component library, public contracts, state ownership,
test conventions and architecture. Generic framework examples are advisory.
Do not add libraries, routing generators, JSX, Nuxt, VueUse, new state/cache
owners or wrappers merely to follow this skill. Do not change the selected
compiler or build setup, replace generated API types, or reopen an accepted
architecture. For Nuxt-specific work, consult that framework only if applicable.

Read the specific reference that addresses the concrete question:

| Topic | Reference |
| --- | --- |
| Props, emits, slots, component contracts | [components](references/components.md) |
| Composables, lifetime, cleanup | [composables](references/composables.md) |
| Pure client utilities | [utils-client](references/utils-client.md) |
| Vue component/composable tests | [testing](references/testing.md) |
| SFC types, generics, injection keys | [typescript](references/typescript.md) |
| Router typing and guards | [router](references/router.md) |
| Reactive state, refs, watchers | [reactivity](references/reactivity.md) |
| Directives | [directives](references/directives.md) |
| Dependency injection | [provide-inject](references/provide-inject.md) |
| Edge cases and compiler diagnostics | [gotchas](references/gotchas.md) |

Check current source or official documentation for version-dependent behavior
before relying on a historical example. Follow existing project acceptance
criteria; unit mocks are not substitutes for required actual consumer,
lifecycle, browser or integration evidence. No new process or additional skill
loading is required merely because a Vue file is involved.
