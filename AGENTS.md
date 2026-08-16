# AGENTS.md

Rules for agents working in this repository.

## What this repo is

The source of truth for OpenCode skills. One skill per top-level directory;
a skill is a directory containing a `SKILL.md`. The local OpenCode skills
folder (`%USERPROFILE%\.config\opencode\skills`) is a deployment target,
synced from this repo by `mirror-skills.ps1`.

## Load the meta skill

When creating or editing a skill, syncing skills, or maintaining this repo,
load the `skills-maintenance` skill first. It contains the full workflow,
skill format, and mirror semantics.

## Hard rules

1. **Repo is the source of truth.** Never edit skills directly in the
   OpenCode skills folder. Edit here, then mirror.
2. **The mirror is additive.** `mirror-skills.ps1` only adds or updates. It
   never deletes from the target. Do not add deletion behavior to it.
3. **One skill per top-level directory.** No loose skill files at the repo
   root. No nested skill directories.
4. **Valid frontmatter.** Every `SKILL.md` must start with YAML frontmatter
   containing `name` (matching the directory name) and `description`
   (written as a trigger: what it does + when to use it).
5. **Commit after every skill change.** Message style:
   `add: <skill>`, `update: <skill>`, `remove: <skill>`, `chore: <what>`.
6. **Push after committing** so the GitHub remote stays current:
   `git push origin master`.

## Standard workflow

```powershell
# after creating/editing a skill
git add -A
git commit -m "add: my-skill"
git push origin master
.\mirror-skills.ps1            # propagate to the OpenCode folder
```

Use `.\mirror-skills.ps1 -WhatIf` to preview a sync before applying it.

## Removing a skill

1. Delete the skill directory from this repo.
2. Commit and push.
3. Manually delete the folder from the OpenCode skills folder (the mirror
   will not do this for you).

## Verification

After changes, verify:

- `git status` is clean and the commit is pushed.
- `.\mirror-skills.ps1 -WhatIf` reports the expected added/updated skills.
- New/changed `SKILL.md` frontmatter is valid YAML and `name` matches the
  directory.
