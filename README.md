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
| [agent-browser](skills/agent-browser) | Browser automation CLI for AI agents: navigate pages, fill forms, click, screenshot, scrape data, and test web apps and Electron apps. |
| [business-model-canvas](skills/business-model-canvas) | Design and analyze business models using the Business Model Canvas framework. |
| [ce-brainstorm](skills/ce-brainstorm) | Explore vague or ambitious ideas into a right-sized, requirements-only plan before building. |
| [clonedeps](skills/clonedeps) | Clone dependency source code into a local workspace so agents can inspect library internals. |
| [code-architecture-tailwind-v4-best-practices](skills/code-architecture-tailwind-v4-best-practices) | Tailwind CSS v4 patterns for buttons and components (CVA/tailwind-variants, CSS-first config). |
| [code-architecture-wrong-abstraction](skills/code-architecture-wrong-abstraction) | When to abstract vs. duplicate code; DRY/WET decisions and refactoring abstractions. |
| [codemap](skills/codemap) | Generate comprehensive hierarchical codemaps for unfamiliar repositories. |
| [cognitive-biases](skills/cognitive-biases) | Apply cognitive bias knowledge to product design and decision-making. |
| [cognitive-fluency-psychology](skills/cognitive-fluency-psychology) | Use cognitive fluency principles to improve clarity, trust, and conversion. |
| [cognitive-load](skills/cognitive-load) | Design experiences that optimize mental resources using Cognitive Load Theory. |
| [css-container-queries](skills/css-container-queries) | CSS container queries for component-based responsive design. |
| [curiosity-gap](skills/curiosity-gap) | Create engagement through strategic information gaps that drive user action. |
| [customer-research](skills/customer-research) | Conduct, analyze, and synthesize customer research (interviews, surveys, reviews, community mining). |
| [deepwork](skills/deepwork) | High-cost orchestrator workflow for large, high-risk, multi-phase coding efforts. |
| [find-skills](skills/find-skills) | Help users discover and install agent skills. |
| [five-whys](skills/five-whys) | Root cause analysis using the Five Whys technique. |
| [fogg-behavior-model](skills/fogg-behavior-model) | Design behavior change using the B=MAP framework. |
| [graph-thinking](skills/graph-thinking) | Graph-based thinking for mapping dependencies and solving problems non-linearly. |
| [halo-effect-psychology](skills/halo-effect-psychology) | Apply the halo effect in product design and UX. |
| [hicks-law](skills/hicks-law) | Optimize decision speed by managing the quantity of choices. |
| [hypothesis-tree](skills/hypothesis-tree) | Structure complex questions into testable hypotheses. |
| [image](skills/image) | Create, generate, edit, and optimize marketing images with AI tools. |
| [jobs-to-be-done](skills/jobs-to-be-done) | Understand customer motivations through jobs-to-be-done theory. |
| [loop-engineering](skills/loop-engineering) | Loop engineering runtime: Grill + Monitor. |
| [loss-aversion-psychology](skills/loss-aversion-psychology) | Leverage loss aversion in product design and messaging. |
| [make-interfaces-feel-better](skills/make-interfaces-feel-better) | Design engineering principles for making interfaces feel polished. |
| [making-product-decisions](skills/making-product-decisions) | Framework for structured product decision-making and tradeoff analysis. |
| [marketing-psychology](skills/marketing-psychology) | Apply psychological principles and behavioral science to marketing. |
| [motion](skills/motion) | Animations with Motion Vue (motion-v) for Vue 3/Nuxt. |
| [naming-cheatsheet](skills/naming-cheatsheet) | Language-agnostic naming conventions using the A/HC/LC pattern. |
| [nextjs-image-art-direction](skills/nextjs-image-art-direction) | Art direction for Next.js images with `getImageProps()` (per-viewport images). |
| [nuxt](skills/nuxt) | Nuxt 4+ patterns: server routes, file-based routing, middleware, h3 v1, nitropack v2. |
| [oh-my-opencode-slim](skills/oh-my-opencode-slim) | Configure and improve oh-my-opencode-slim (agents, models, prompts, skills, MCPs, presets). |
| [pest-analysis](skills/pest-analysis) | PEST (Political, Economic, Social, Technological) analysis for strategic planning. |
| [pnpm](skills/pnpm) | Manage Node.js dependencies with pnpm: workspaces, catalogs, overrides, patches, CI. |
| [progressive-disclosure](skills/progressive-disclosure) | Reduce complexity by revealing information progressively. |
| [project-structure](skills/project-structure) | React/Next.js/TypeScript project organization using feature-based architecture. |
| [react-key-prop](skills/react-key-prop) | Proper usage of the `key` prop in React lists. |
| [react-use-callback](skills/react-use-callback) | Proper usage of the `useCallback` hook in React. |
| [react-use-client-boundary](skills/react-use-client-boundary) | Proper usage of the `"use client"` directive in React/Next.js. |
| [react-use-state](skills/react-use-state) | Proper usage of the React `useState` hook. |
| [reflect](skills/reflect) | Review recent work, find repeated workflow patterns, suggest reusable skills, agents, and playbooks. |
| [release-smoke-test](skills/release-smoke-test) | Test an oh-my-opencode-slim release candidate or bugfix before publishing. |
| [repository-docs-governance](skills/repository-docs-governance) | Audit and restructure a repository's AGENTS.md hierarchy, codemaps, and documentation. |
| [self-initiated-triggers](skills/self-initiated-triggers) | Design internal triggers for sustained user engagement. |
| [simplify](skills/simplify) | Simplify and refine recently modified code for clarity and consistency. |
| [social-proof-psychology](skills/social-proof-psychology) | Leverage social proof to build trust and influence user behavior. |
| [status-quo-bias](skills/status-quo-bias) | Design for users' preference for the current state over change. |
| [systematic-debugging](skills/systematic-debugging) | Systematic debugging before proposing fixes for any bug or test failure. |
| [theme-epic-story](skills/theme-epic-story) | Structure product work hierarchically using themes, epics, and stories. |
| [trust-psychology](skills/trust-psychology) | Build trust signals that reduce perceived risk and enable user action. |
| [ts-library](skills/ts-library) | Authoring TypeScript libraries: setup, exports, build tooling, API design, publishing. |
| [tsdown](skills/tsdown) | Bundling TypeScript libraries with tsdown: dual ESM/CJS, `.d.ts`, validation. |
| [typescript-advanced-types](skills/typescript-advanced-types) | TypeScript advanced type system: generics, conditional/mapped types, template literals. |
| [typescript-best-practices](skills/typescript-best-practices) | TypeScript best practices for type safety, organization, and maintainability. |
| [typescript-interface-vs-type](skills/typescript-interface-vs-type) | When to use `interface` vs. `type` in TypeScript. |
| [typescript-satisfies-operator](skills/typescript-satisfies-operator) | Proper usage of TypeScript's `satisfies` operator vs. type annotations. |
| [user-story-fundamentals](skills/user-story-fundamentals) | Capture requirements as structured user stories with acceptance criteria. |
| [verification-before-completion](skills/verification-before-completion) | Run verification commands and confirm output before claiming work is complete. |
| [verification-planning](skills/verification-planning) | Plan project-specific verification evidence for non-trivial coding work. |
| [video](skills/video) | Create, generate, and produce video content with AI tools or programmatic frameworks. |
| [visual-cues-cta-psychology](skills/visual-cues-cta-psychology) | Design effective CTAs using visual attention and gaze psychology. |
| [vite](skills/vite) | Version-aware Vite build, configuration, plugin, SSR, and migration guidance. |
| [vitest](skills/vitest) | Unit/integration tests for Vite projects with vitest. |
| [vue](skills/vue) | Vue 3 patterns: Composition API, props/emits, VueUse, reactive destructuring. |
| [web-perf](skills/web-perf) | Diagnose and improve real-world web performance (Vue 3, Vite, Nuxt, Electron, Tauri). |
| [worktrees](skills/worktrees) | Manage Git worktrees as isolated coding lanes for complex or parallel work. |
| [writing-web-documentation](skills/writing-web-documentation) | Write and organize developer-facing documentation for web software projects. |

## Notes

- A skill is any directory under `skills/` containing a `SKILL.md`.
  Directories without one are skipped by the mirrors with a warning.
- Don't edit skills directly in a deployment target - the repo is the source
  of truth and the next mirror run will overwrite repo-tracked files.
