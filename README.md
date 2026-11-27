# Skills

Source-of-truth repository for agent skills. A skill is a directory with a
`SKILL.md` (YAML frontmatter + instructions), following the
[Agent Skills](https://agentskills.io/specification) format.

Skills live in `skills/` and are synced **additively** to two deployment
targets:

| Target | Folder | Script |
| --- | --- | --- |
| OpenCode | `%USERPROFILE%\.config\opencode\skills` | `mirror-skills-opencode.ps1` |
| Cross-harness (.agents) | `%USERPROFILE%\.agents\skills` | `mirror-skills-agents.ps1` |

The `.agents` folder is the de-facto global skills location read natively by
Codex CLI, Cursor, Gemini CLI, VS Code/Copilot, and OpenCode (compat).
Claude Code does not read it (it uses `~/.claude/skills`).

## Quick Start

```powershell
# 1. Clone
git clone <this-repo-url> skills
cd skills

# 2. Mirror all skills to both targets
.\mirror-skills-opencode.ps1   # -> %USERPROFILE%\.config\opencode\skills
.\mirror-skills-agents.ps1     # -> %USERPROFILE%\.agents\skills
```

## Layout

```
skills/
├── AGENTS.md                  # Rules for agents working in this repo
├── README.md
├── mirror-skills-opencode.ps1 # Additive sync: repo -> OpenCode skills folder
├── mirror-skills-agents.ps1   # Additive sync: repo -> .agents skills folder
├── skills-maintenance/        # Meta skill: how to maintain this repo
└── skills/
    └── <skill-name>/
        ├── SKILL.md           # Required
        └── ...                # Optional scripts / references / assets
```

The meta skill `skills-maintenance/` lives at the repo root (not in
`skills/`) because it maintains this repo rather than serving end users. It
is mirrored to both targets like any other skill.

## The Mirror Scripts

Both scripts are **additive and never destructive**:

- **Add** skills that exist in the repo but not in the target.
- **Update** files of existing skills when they changed in the repo.
- **Never remove** skills or files that exist only in the target folder.
- **Clean** copied files of NTFS alternate data streams (e.g. the
  `Zone.Identifier` "Mark of the Web" that Windows attaches to downloaded
  files), so that junk never propagates into the target folder.

```powershell
.\mirror-skills-opencode.ps1              # sync to %USERPROFILE%\.config\opencode\skills
.\mirror-skills-agents.ps1                # sync to %USERPROFILE%\.agents\skills
.\mirror-skills-opencode.ps1 -WhatIf      # preview changes only
.\mirror-skills-agents.ps1 -TargetPath X  # sync to a custom folder
```

Each script prints a summary of added / updated / unchanged / skipped skills.

## Workflow

1. **Create or edit** a skill in `skills/` (see `skills-maintenance/SKILL.md`
   for the skill format and full maintenance guide).
2. **Update the "Skills" list below** if you added, removed, renamed, or
   re-described a skill.
3. **Commit and push**:
   ```powershell
   git add -A
   git commit -m "add: my-skill"
   git push origin master
   ```
4. **Sync** to both targets:
   ```powershell
   .\mirror-skills-opencode.ps1
   .\mirror-skills-agents.ps1
   ```

### Removing a skill

The mirrors never delete. To retire a skill: delete its directory from
`skills/`, remove it from the list below, commit and push, then manually
remove the folder from each deployment target.

## Skills

| Skill | Description |
| --- | --- |
| [agent-browser](skills/agent-browser) | Use when actual browser automation is needed and the harness has the agent-browser CLI, or the user explicitly requests this CLI. Prefer existing supported browser tools, connectors or project test harnesses when appropriate. |
| [author-voice](skills/author-voice) | Build, calibrate, and apply a reusable author voice profile so editing and drafting preserve a specific writer's identity without imitating accidental typos. |
| [behavioral-design](skills/behavioral-design) | Use when the user explicitly requests behavior change, habit formation, adoption, or retention design. Do not activate merely because onboarding, notifications, or migration are mentioned. |
| [business-model-canvas](skills/business-model-canvas) | Design and analyze business models using the Business Model Canvas framework. |
| [ce-brainstorm](skills/ce-brainstorm) | Use only when the user explicitly requests ce-brainstorm or collaborative requirements exploration for a genuinely unresolved product decision. Never use for accepted specifications, implementation, or a technology verdict. |
| [clonedeps](skills/clonedeps) | Clone dependency source code into a local workspace so agents can inspect library internals. |
| [code-architecture-tailwind-v4-best-practices](skills/code-architecture-tailwind-v4-best-practices) | Tailwind CSS v4 patterns for buttons and components (CVA/tailwind-variants, CSS-first config). |
| [code-architecture-wrong-abstraction](skills/code-architecture-wrong-abstraction) | When to abstract vs. duplicate code; DRY/WET decisions and refactoring abstractions. |
| [codemap](skills/codemap) | Generate comprehensive hierarchical codemaps for unfamiliar repositories. |
| [css-container-queries](skills/css-container-queries) | CSS container queries for component-based responsive design. |
| [customer-research](skills/customer-research) | Conduct, analyze, and synthesize customer research (interviews, surveys, reviews, community mining). |
| [deepwork](skills/deepwork) | Use only in an active Oh My OpenCode Slim orchestrator for large, high-risk dependent work that lacks an existing project-owned execution plan. Do not activate for Nexus foundation work, routine changes, or generic ChatGPT/Codex orchestration. |
| [find-skills](skills/find-skills) | Use only when the user explicitly asks to discover, compare, install or manage agent skills. Not for ordinary how-to questions or work that existing capabilities can perform. |
| [five-whys](skills/five-whys) | Use when a user explicitly requests Five Whys or a specific causal investigation benefits from that technique. Do not impose on routine bug fixes or every issue. |
| [graph-thinking](skills/graph-thinking) | Use when explicit dependency or relationship mapping materially helps solve a complex problem. Do not activate for every architectural or code task. |
| [hypothesis-tree](skills/hypothesis-tree) | Use when a genuinely uncertain research or diagnostic problem needs multiple competing, testable hypotheses. Do not activate for already established causes or routine decisions. |
| [image](skills/image) | Use only for actual marketing/brand visual creation, image optimization, or a concrete image production workflow. Do not activate merely because image tools or design platforms are mentioned. |
| [jobs-to-be-done](skills/jobs-to-be-done) | Understand customer motivations through jobs-to-be-done theory. |
| [loop-engineering](skills/loop-engineering) | Use only when explicitly requesting a bounded loop in a compatible Oh My OpenCode Slim Grill/Monitor runtime with the required loop API. Not for ordinary iterative implementation or verification. |
| [make-interfaces-feel-better](skills/make-interfaces-feel-better) | Use for explicit UI polish or a concrete interaction/visual defect within the authorized frontend scope. Existing design system, accessibility, reduced-motion and product requirements take precedence. |
| [making-product-decisions](skills/making-product-decisions) | Use for material unresolved product trade-offs requiring a structured decision. Do not reopen accepted decisions or require a fixed number of alternatives. |
| [marketing-psychology](skills/marketing-psychology) | Use for explicit marketing, conversion research, ethical persuasion, trust signals, or campaign messaging. Do not activate for ordinary product UI, coding, or general decision-making. |
| [media-recommender](skills/media-recommender) | Build and apply profile-driven cross-media recommendations while separating personal fit, execution confidence, and medium/platform path. |
| [motion](skills/motion) | Use only when the project actually uses Motion Vue (motion-v), or the user explicitly wants to evaluate or adopt it for a concrete animation. Do not install it for routine UI polish. |
| [naming-cheatsheet](skills/naming-cheatsheet) | Use when explicitly reviewing naming or a concrete naming ambiguity cannot be resolved from project conventions; advisory only, not a mandatory rename pass. |
| [nextjs-image-art-direction](skills/nextjs-image-art-direction) | Use only for Next.js image art direction when different viewports genuinely need different assets or crops and the installed API supports it. |
| [nuxt](skills/nuxt) | Use only for an actual Nuxt project and a Nuxt-specific server, routing, rendering, composable or configuration problem; not ordinary Vue or generic SSR. |
| [oh-my-opencode-slim](skills/oh-my-opencode-slim) | Use only for actual Oh My OpenCode Slim configuration, model routing, agent prompts, MCP or plugin behavior changes. Do not use for generic orchestration or unrelated agent platforms. |
| [pest-analysis](skills/pest-analysis) | PEST (Political, Economic, Social, Technological) analysis for strategic planning. |
| [pnpm](skills/pnpm) | Manage Node.js dependencies with pnpm: workspaces, catalogs, overrides, patches, CI. |
| [project-structure](skills/project-structure) | Use only for a React or Next.js project whose architecture or file organization genuinely needs design or reorganization. Never impose this React-specific structure on Vue, other frameworks, or an accepted repository architecture. |
| [react-key-prop](skills/react-key-prop) | Use only for React list identity or reconciliation bugs, or non-trivial React key selection; not Vue lists or routine rendering. |
| [react-use-callback](skills/react-use-callback) | Use only for a React callback identity or measured rendering performance problem where useCallback is relevant. Do not activate for Vue or routine callback creation. |
| [react-use-client-boundary](skills/react-use-client-boundary) | Use only for React Server Components or Next.js App Router client-server boundary decisions and related errors. |
| [react-use-state](skills/react-use-state) | Use only for a non-trivial React useState or state ownership problem. Not for other frameworks or routine React component edits. |
| [reflect](skills/reflect) | Use when the user explicitly requests review of past agent sessions or recurring workflow friction. Inspect relevant existing settings and evidence; do not automatically change agent configuration. |
| [release-smoke-test](skills/release-smoke-test) | Use only for qualifying an Oh My OpenCode Slim release candidate or reproducing a specific compatibility regression in that plugin. |
| [repository-docs-governance](skills/repository-docs-governance) | Audit and restructure a repository's AGENTS.md hierarchy, codemaps, and documentation. |
| [simplify](skills/simplify) | Use only when the user requests simplification or the current authorized change has a concrete maintainability problem. Preserve behavior, scope and project contracts; do not initiate routine post-implementation refactoring. |
| [systematic-debugging](skills/systematic-debugging) | Use for a concrete non-trivial defect, regression, or failure whose cause is uncertain. Diagnose from evidence and verify proportionately; do not impose a ritual on a clear mechanical correction. |
| [theme-epic-story](skills/theme-epic-story) | Structure product work hierarchically using themes, epics, and stories. |
| [ts-library](skills/ts-library) | Use only for a concrete TypeScript library/package API, distribution, export, build or publication decision. Follow the project's actual package consumer and runtime requirements. |
| [tsdown](skills/tsdown) | Use only when the project actually uses tsdown or explicitly evaluates it for a TypeScript package build; do not introduce it to unrelated build workflows. |
| [typescript-best-practices](skills/typescript-best-practices) | Use for a material TypeScript typing, API, compiler configuration, or type-safety question requiring specialized guidance. Do not activate for routine TypeScript edits that follow established project conventions. |
| [user-story-fundamentals](skills/user-story-fundamentals) | Capture requirements as structured user stories with acceptance criteria. |
| [ux-psychology](skills/ux-psychology) | Use for a concrete usability, cognitive load, information architecture, or decision-complexity design problem. Do not activate for routine UI coding or marketing conversion. |
| [verification-planning](skills/verification-planning) | Use before non-trivial implementation when a credible project-specific evidence path is missing or must be reconciled. Reuse accepted acceptance contracts and applicable evidence; no duplicate verification plans. |
| [video](skills/video) | Use only for actual video creation, editing, rendering, or production workflows. Do not activate for media discussion or mentions of video platforms. |
| [vite](skills/vite) | Version-aware Vite build, configuration, plugin, SSR, and migration guidance. |
| [vitest](skills/vitest) | Unit/integration tests for Vite projects with vitest. |
| [vue](skills/vue) | Vue 3 patterns: Composition API, props/emits, VueUse, reactive destructuring. |
| [web-perf](skills/web-perf) | Diagnose and improve real-world web performance (Vue 3, Vite, Nuxt, Electron, Tauri). |
| [worktrees](skills/worktrees) | Use when Git worktree isolation materially protects another active checkout or enables genuinely independent coding lanes. Use the repository's and harness's worktree policy first; never create extra lanes for routine work. |
| [writing-web-documentation](skills/writing-web-documentation) | Write and organize developer-facing documentation for web software projects. |

## Consolidated skills

The following old skill names have been retired. Their original guidance and licenses are retained in the replacement skill's `references/` directory. After pulling this change, manually remove the retired directories from both additive mirror targets; update any explicit references in local agent configuration.

- `ux-psychology`: `cognitive-biases`, `cognitive-fluency-psychology`, `cognitive-load`, `hicks-law`, `progressive-disclosure`.
- `marketing-psychology`: `halo-effect-psychology`, `loss-aversion-psychology`, `social-proof-psychology`, `trust-psychology`, `visual-cues-cta-psychology`.
- `behavioral-design`: `fogg-behavior-model`, `curiosity-gap`, `self-initiated-triggers`, `status-quo-bias`.
- `typescript-best-practices`: `typescript-advanced-types`, `typescript-interface-vs-type`, `typescript-satisfies-operator`.

## Notes

- A skill is any directory under `skills/` containing a `SKILL.md`.
  Directories without one are skipped by the mirrors with a warning.
- Don't edit skills directly in a deployment target - the repo is the source
  of truth and the next mirror run will overwrite repo-tracked files.
