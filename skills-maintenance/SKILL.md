---
name: skills-maintenance
description:
  Maintain the skills repository - create new skills, modify existing ones,
  sync skills to the OpenCode skills folder, and manage the repo. Use whenever
  a skill needs to be created or edited, skills need to be synced with the
  OpenCode folder, or the skills repo needs to be maintained (commits, push,
  cleanup).
---

# Skills Maintenance

This repo is the **source of truth** for all OpenCode skills. The OpenCode
skills folder (`%USERPROFILE%\.config\opencode\skills`) is a deployment
target, kept in sync from this repo by an additive mirror script.

## Repo Layout

```
skills/
├── AGENTS.md              # Rules for agents working in this repo
├── README.md              # Human-facing documentation
├── mirror-skills.ps1      # Additive sync: repo -> OpenCode skills folder
├── skills-maintenance/    # This meta skill
└── <skill-name>/          # One directory per skill
    ├── SKILL.md           # Required: frontmatter (name, description) + body
    └── ...                # Optional: scripts, references, assets
```

A skill is any top-level directory that contains a `SKILL.md`.

## Creating a New Skill

1. Create a new top-level directory named after the skill (kebab-case).
2. Add a `SKILL.md` with YAML frontmatter:

   ```markdown
   ---
   name: my-skill
   description:
     What the skill does. Use when <trigger conditions> - describe clearly
     when the agent should load this skill.
   ---

   # My Skill

   <instructions, workflows, examples>
   ```

   - `name` must match the directory name.
   - `description` is what the agent sees when deciding whether to load the
     skill. Write it as a trigger: what it does + when to use it.
3. Add any supporting files (scripts, references) inside the skill directory.
4. Commit and push (see "Repo Maintenance").
5. Sync to the OpenCode folder (see "Syncing").

## Modifying a Skill

1. Edit the skill files in this repo.
2. Commit and push.
3. Run the mirror to propagate changes.

Never edit skills directly in the OpenCode folder - local-only edits will be
overwritten by the next mirror run (for files that also exist in the repo).

## Syncing (Repo -> OpenCode Folder)

Run the mirror script from the repo root:

```powershell
.\mirror-skills.ps1
```

Useful variants:

```powershell
.\mirror-skills.ps1 -WhatIf                 # preview, change nothing
.\mirror-skills.ps1 -TargetPath D:\other    # mirror to a custom folder
```

### Mirror semantics (additive, never destructive)

| Situation | Behavior |
| --- | --- |
| Skill in repo, missing in target | Copied over in full (added) |
| Skill in both, file changed in repo | Target file overwritten from repo |
| Skill in both, file identical | Left alone |
| File/skill only in target | **Never touched, never removed** |
| Repo directory without SKILL.md | Skipped with a warning |

The mirror only ever adds or updates. It never deletes anything from the
target folder.

## Removing a Skill

The mirror cannot remove skills. To retire a skill:

1. Delete the skill directory from this repo.
2. Commit and push.
3. Manually delete the skill folder from the OpenCode skills folder
   (`%USERPROFILE%\.config\opencode\skills\<skill-name>`).

## Repo Maintenance

- **Commit** after every skill change: `git add -A; git commit -m "..."`.
  Use clear messages: `add: <skill>`, `update: <skill>`, `remove: <skill>`.
- **Push** to the GitHub remote (`origin`) so the repo stays backed up:
  `git push origin master`.
- Keep one skill per top-level directory; no loose skill files at the root.
- Keep `SKILL.md` frontmatter valid (parseable YAML, `name` matches the
  directory).
- After structural changes (new scripts, renamed files), run
  `.\mirror-skills.ps1 -WhatIf` to sanity-check what will sync.

## Quick Reference

| Task | Command / Action |
| --- | --- |
| Create skill | New dir + `SKILL.md`, commit, push, mirror |
| Edit skill | Edit in repo, commit, push, mirror |
| Sync to OpenCode | `.\mirror-skills.ps1` |
| Preview sync | `.\mirror-skills.ps1 -WhatIf` |
| Remove skill | Delete dir, commit, push, manual delete in target |
| Backup | `git push origin master` |
