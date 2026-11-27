# Skills

Canonical curated library of reusable Agent Skills. Only install a skill when it provides specialized knowledge or a useful method beyond the agent's native capability. Repository-specific contracts and instructions always win.

## Selection and distribution

`skills-policy.json` owns the exact deployment profiles. The repository contains **27** retained skills; not all should be globally visible.

- **Shared / .agents:** 7 selected cross-harness skills (visible to compatible local ChatGPT/Codex clients). All are potential Nexus aids, not replacements for Nexus-owned architecture/continuity or project-specific technical skills.
- **OpenCode:** the shared set plus 6 focused Vue/TypeScript/Vite/toolchain skills. Do not mirror redundant OMO bundled workflows; native OMO implementations are preferred. The custom `verification-planning` is an intentional cross-harness adaptation.
- **On demand:** 14 specialist skills; keep in the repository and opt in for a concrete need. Personal adapters in the private Paweł Context plugin can consume `author-voice` and `media-recommender`; do not package personal context into this public library.

No separate ChatGPT plugin copy of this collection is required. A cloud session without the local skill path may read the canonical GitHub skill when relevant. The Nexus plugin remains independently maintained. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for attribution and licenses.

## Skills

| Skill | Description | Distribution |
| --- | --- | --- |
| [agent-browser](skills/agent-browser) | Use when actual browser automation is needed and the harness has the agent-browser CLI, or the user explicitly requests this CLI. Prefer existing supported browser tools, connectors or project test harnesses when appropriate.  On demand |
| [author-voice](skills/author-voice) | Build, calibrate, and apply a reusable author voice profile so editing and drafting preserve a specific writer's identity without imitating accidental typos.  On demand |
| [behavioral-design](skills/behavioral-design) | Use when the user explicitly requests behavior change, habit formation, adoption, or retention design. Do not activate merely because onboarding, notifications, or migration are mentioned.  On demand |
| [code-architecture-tailwind-v4-best-practices](skills/code-architecture-tailwind-v4-best-practices) | Tailwind CSS v4 patterns for buttons and components (CVA/tailwind-variants, CSS-first config).  On demand |
| [code-architecture-wrong-abstraction](skills/code-architecture-wrong-abstraction) | When to abstract vs. duplicate code; DRY/WET decisions and refactoring abstractions.  Shared |
| [css-container-queries](skills/css-container-queries) | CSS container queries for component-based responsive design.  OpenCode |
| [customer-research](skills/customer-research) | Conduct, analyze, and synthesize customer research (interviews, surveys, reviews, community mining).  On demand |
| [jobs-to-be-done](skills/jobs-to-be-done) | Understand customer motivations through jobs-to-be-done theory.  On demand |
| [make-interfaces-feel-better](skills/make-interfaces-feel-better) | Use for explicit UI polish or a concrete interaction/visual defect within the authorized frontend scope. Existing design system, accessibility, reduced-motion and product requirements take precedence.  Shared |
| [marketing-psychology](skills/marketing-psychology) | Use for explicit marketing, conversion research, ethical persuasion, trust signals, or campaign messaging. Do not activate for ordinary product UI, coding, or general decision-making.  On demand |
| [media-recommender](skills/media-recommender) | Build and apply profile-driven cross-media recommendations while separating personal fit, execution confidence, and medium/platform path.  On demand |
| [motion](skills/motion) | Use only when the project actually uses Motion Vue (motion-v), or the user explicitly wants to evaluate or adopt it for a concrete animation. Do not install it for routine UI polish.  On demand |
| [nuxt](skills/nuxt) | Use only for an actual Nuxt project and a Nuxt-specific server, routing, rendering, composable or configuration problem; not ordinary Vue or generic SSR.  On demand |
| [pnpm](skills/pnpm) | Manage Node.js dependencies with pnpm: workspaces, catalogs, overrides, patches, CI.  OpenCode |
| [release-smoke-test](skills/release-smoke-test) | Use only for qualifying an Oh My OpenCode Slim release candidate or reproducing a specific compatibility regression in that plugin.  On demand |
| [repository-docs-governance](skills/repository-docs-governance) | Generic repository documentation governance when no project-specific owner exists.  Shared |
| [systematic-debugging](skills/systematic-debugging) | Use for a concrete non-trivial defect, regression, or failure whose cause is uncertain. Diagnose from evidence and verify proportionately; do not impose a ritual on a clear mechanical correction.  Shared |
| [ts-library](skills/ts-library) | Use only for a concrete TypeScript library/package API, distribution, export, build or publication decision. Follow the project's actual package consumer and runtime requirements.  On demand |
| [tsdown](skills/tsdown) | Use only when the project actually uses tsdown or explicitly evaluates it for a TypeScript package build; do not introduce it to unrelated build workflows.  On demand |
| [typescript-best-practices](skills/typescript-best-practices) | Use for a material TypeScript typing, API, compiler configuration, or type-safety question requiring specialized guidance. Do not activate for routine TypeScript edits that follow established project conventions.  OpenCode |
| [ux-psychology](skills/ux-psychology) | Use for a concrete usability, cognitive load, information architecture, or decision-complexity design problem. Do not activate for routine UI coding or marketing conversion.  Shared |
| [verification-planning](skills/verification-planning) | Use before non-trivial implementation when a credible project-specific evidence path is missing or must be reconciled. Reuse accepted acceptance contracts and applicable evidence; no duplicate verification plans.  Shared |
| [vite](skills/vite) | Version-aware Vite build, configuration, plugin, SSR, and migration guidance.  OpenCode |
| [vitest](skills/vitest) | Unit/integration tests for Vite projects with vitest.  OpenCode |
| [vue](skills/vue) | Vue 3 patterns: Composition API, props/emits, VueUse, reactive destructuring.  OpenCode |
| [web-perf](skills/web-perf) | Diagnose and improve real-world web performance (Vue 3, Vite, Nuxt, Electron, Tauri).  Shared |
| [writing-web-documentation](skills/writing-web-documentation) | Write and organize developer-facing documentation for web software projects.  On demand |

## Maintenance and synchronization

Read [AGENTS.md](AGENTS.md) and [skills-maintenance/SKILL.md](skills-maintenance/SKILL.md). The maintenance skill is repo-only, not a global skill.

The two existing mirror commands now use one shared engine, `mirror-skills.ps1`. They require a clean committed source and mirror only their configured profile, with explicit optional includes. They are safe to preview:

```powershell
# From the canonical checkout, after reviewing and pulling the desired revision:
.\mirror-skills-agents.ps1 -Reconcile -WhatIf
.\mirror-skills-opencode.ps1 -Reconcile -WhatIf
```

Only after reviewing the plan:

```powershell
.\mirror-skills-agents.ps1 -Reconcile
.\mirror-skills-opencode.ps1 -Reconcile
```

Then run:

```powershell
.\mirror-skills-agents.ps1 -Check
.\mirror-skills-opencode.ps1 -Check
```

Default targets are `%USERPROFILE%\.agents\skills` and `%USERPROFILE%\.config\opencode\skills`. `-TargetPath` supports an explicit alternative. Add an optional retained skill via `-IncludeSkill <name>` (use the same list for later checks/reconciliation). Default sync adds or replaces selected directories, preserving a backup before replacement; `-Reconcile` also archives exact known excluded/retired directories. Unknown or private skills are preserved. Backups live outside active discovery in a sibling `skill-mirror-backups` directory. No target entries are deleted. `-Check` is read-only and reports managed drift without requiring unmanaged directories to be removed.

Check repository structure with `python tests/check-repository.py` (requires PyYAML), and test the mirrors with `.\tests\test-mirror-skills.ps1` before changing real targets. The test uses only disposable fixtures.


## Retirement rationale

Removed 27 low-value, duplicate, stack-mismatched or competing procedural skills. OMO bundled equivalents stay available through OMO, not through stale copies in this repository. The previous consolidated reference material remains in the retained routers. Retired names are listed in the policy, with original revisions retained in Git history.
