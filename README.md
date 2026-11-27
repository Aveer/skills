# Skills

Canonical curated library of reusable Agent Skills. Only install a skill when it provides specialized knowledge or a useful method beyond the agent's native capability. Repository-specific contracts and instructions always win.

## Selection and distribution

`skills-policy.json` owns the exact deployment profiles. The repository contains **24** retained skills; not all should be globally visible.

- **Shared / .agents:** 7 focused UI, debugging and technology skills for compatible local ChatGPT/Codex clients.
- **OpenCode:** the same 7 default skills. Technical knowledge is not tied to the coding agent. Do not mirror redundant host-bundled workflows.
- **On demand:** 17 specialist skills, including generic documentation governance, CSS container queries and pnpm. Opt in for concrete needs; use repository-owned governance and the actual package manager. Private personal-context adapters can consume `author-voice` and `media-recommender`; do not package private context here.

No separate ChatGPT plugin copy of this collection is required. A cloud session without the local skill path may read the canonical GitHub skill when relevant. The Nexus plugin remains independently maintained. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for attribution and licenses.

## Skills

| Skill | Description | Distribution |
| --- | --- | --- |
| [agent-browser](skills/agent-browser) | Use when actual browser automation is needed and the harness has the agent-browser CLI, or the user explicitly requests this CLI. Prefer existing supported browser tools, connectors or project test harnesses when appropriate. | On demand |
| [author-voice](skills/author-voice) | Build, calibrate, and apply a reusable author voice profile so editing and drafting preserve a specific writer's identity without imitating accidental typos. | On demand |
| [behavioral-design](skills/behavioral-design) | Use when the user explicitly requests behavior change, habit formation, adoption, or retention design. Do not activate merely because onboarding, notifications, or migration are mentioned. | On demand |
| [code-architecture-tailwind-v4-best-practices](skills/code-architecture-tailwind-v4-best-practices) | Tailwind CSS v4 patterns for buttons and components (CVA/tailwind-variants, CSS-first config). | On demand |
| [css-container-queries](skills/css-container-queries) | CSS container queries for component-based responsive design. | On demand |
| [customer-research](skills/customer-research) | Conduct, analyze, and synthesize customer research (interviews, surveys, reviews, community mining). | On demand |
| [jobs-to-be-done](skills/jobs-to-be-done) | Understand customer motivations through jobs-to-be-done theory. | On demand |
| [make-interfaces-feel-better](skills/make-interfaces-feel-better) | Optional concrete UI polish advice on feedback, motion, alignment and readability; no independent design system. | Shared |
| [marketing-psychology](skills/marketing-psychology) | Use for explicit marketing, conversion research, ethical persuasion, trust signals, or campaign messaging. Do not activate for ordinary product UI, coding, or general decision-making. | On demand |
| [media-recommender](skills/media-recommender) | Build and apply profile-driven cross-media recommendations while separating personal fit, execution confidence, and medium/platform path. | On demand |
| [motion](skills/motion) | Use only when the project actually uses Motion Vue (motion-v), or the user explicitly wants to evaluate or adopt it for a concrete animation. Do not install it for routine UI polish. | On demand |
| [nuxt](skills/nuxt) | Use only for an actual Nuxt project and a Nuxt-specific server, routing, rendering, composable or configuration problem; not ordinary Vue or generic SSR. | On demand |
| [pnpm](skills/pnpm) | Manage Node.js dependencies with pnpm: workspaces, catalogs, overrides, patches, CI. | On demand |
| [release-smoke-test](skills/release-smoke-test) | Use only for qualifying an Oh My OpenCode Slim release candidate or reproducing a specific compatibility regression in that plugin. | On demand |
| [repository-docs-governance](skills/repository-docs-governance) | Generic repository documentation governance when no project-specific owner exists. | On demand |
| [systematic-debugging](skills/systematic-debugging) | Use for a concrete non-trivial defect, regression, or failure whose cause is uncertain. Diagnose from evidence and verify proportionately; do not impose a ritual on a clear mechanical correction. | Shared |
| [ts-library](skills/ts-library) | Use only for a concrete TypeScript library/package API, distribution, export, build or publication decision. Follow the project's actual package consumer and runtime requirements. | On demand |
| [tsdown](skills/tsdown) | Use only when the project actually uses tsdown or explicitly evaluates it for a TypeScript package build; do not introduce it to unrelated build workflows. | On demand |
| [typescript-best-practices](skills/typescript-best-practices) | TypeScript type-system, API and compiler guidance constrained by the selected toolchain and contracts. | Shared |
| [ux-psychology](skills/ux-psychology) | Evidence-informed usability and expert workflow design; preserve discoverability, explicit choices and user control. | Shared |
| [vite](skills/vite) | Version-aware Vite configuration, bundling, plugins, HMR and authorized migrations. | Shared |
| [vitest](skills/vitest) | Focused Vitest API, fixtures, mocks, timing and test diagnostics within the project's acceptance contract. | Shared |
| [vue](skills/vue) | Focused Vue 3 reactivity, component contracts, composable lifecycle and framework-specific debugging. | Shared |
| [writing-web-documentation](skills/writing-web-documentation) | Write and organize developer-facing documentation for web software projects. | On demand |

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

The active library excludes retired low-value, duplicate, stack-mismatched or competing procedural skills, including the explicitly retired `web-perf`, `code-architecture-wrong-abstraction` and `verification-planning`. OMO bundled equivalents stay available through OMO, not through stale copies in this repository. The previous consolidated reference material remains in the retained routers. Retired names are listed in the policy, with original revisions retained in Git history.
