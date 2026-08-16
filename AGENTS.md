# AGENTS.md

Rules for agents working in this repository.

## What this repo is

The source of truth for agent skills. Skills live in `skills/` — one skill
per directory, where a skill is a directory containing a `SKILL.md`. The
meta skill `skills-maintenance/` lives at the repo root: it maintains this
repo and is not a user-facing skill.

Skills are deployed to two targets, both synced additively from this repo:

- **OpenCode** — `%USERPROFILE%\.config\opencode\skills` via
  `mirror-skills-opencode.ps1`
- **Cross-harness (.agents)** — `%USERPROFILE%\.agents\skills` via
  `mirror-skills-agents.ps1`. This is the de-facto global skills folder
  read natively by Codex CLI, Cursor, Gemini CLI, VS Code/Copilot, and
  OpenCode (compat). Claude Code does not read it (it uses
  `%USERPROFILE%\.claude\skills`).

## Load the meta skill

When creating or editing a skill, syncing skills, or maintaining this repo,
load the `skills-maintenance` skill first. It contains the full workflow,
skill format, and mirror semantics.

## Hard rules

1. **Repo is the source of truth.** Never edit skills directly in a
   deployment target folder. Edit here, then mirror.
2. **The mirrors are additive.** Both mirror scripts only add or update.
   They never delete from the target. Do not add deletion behavior to them.
3. **One skill per directory under `skills/`.** No loose skill files at the
   repo root, no nested skill directories. The only skill directory at the
   root is the meta skill `skills-maintenance/`.
4. **Valid frontmatter.** Every `SKILL.md` must start with YAML frontmatter
   containing `name` (matching the directory name) and `description`
   (written as a trigger: what it does + when to use it).
5. **Keep the README skill list current.** When adding, removing, renaming,
   or re-describing a skill, update the "Skills" list in `README.md` in the
   same commit.
6. **Commit after every skill change.** Message style:
   `add: <skill>`, `update: <skill>`, `remove: <skill>`, `chore: <what>`.
7. **Push after committing** so the GitHub remote stays current:
   `git push origin master`.

## Standard workflow

```powershell
# after creating/editing a skill
git add -A
git commit -m "add: my-skill"
git push origin master
.\mirror-skills-opencode.ps1   # propagate to the OpenCode folder
.\mirror-skills-agents.ps1     # propagate to the cross-harness .agents folder
```

Use `-WhatIf` on either script to preview a sync before applying it.

## Removing a skill

1. Delete the skill directory from `skills/`.
2. Remove it from the "Skills" list in `README.md`.
3. Commit and push.
4. Manually delete the folder from each deployment target (the mirrors will
   not do this for you).

## Verification

After changes, verify:

- `git status` is clean and the commit is pushed.
- `.\mirror-skills-opencode.ps1 -WhatIf` and `.\mirror-skills-agents.ps1 -WhatIf`
  report the expected added/updated skills.
- New/changed `SKILL.md` frontmatter is valid YAML and `name` matches the
  directory.
- The "Skills" list in `README.md` matches the directories in `skills/`.
