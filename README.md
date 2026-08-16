# Skills

Source-of-truth repository for [OpenCode](https://opencode.ai) skills.

Each top-level directory is one skill (a `SKILL.md` plus optional supporting
files). The repo is synced **additively** into the local OpenCode skills
folder (`%USERPROFILE%\.config\opencode\skills`) with `mirror-skills.ps1`.

## Quick Start

```powershell
# 1. Clone
git clone <this-repo-url> skills
cd skills

# 2. Mirror all skills into the OpenCode skills folder
.\mirror-skills.ps1
```

## Layout

```
skills/
├── AGENTS.md              # Rules for agents working in this repo
├── README.md
├── mirror-skills.ps1      # Additive sync: repo -> OpenCode skills folder
├── skills-maintenance/    # Meta skill: how to maintain this repo
└── <skill-name>/
    ├── SKILL.md           # Required
    └── ...                # Optional scripts / references / assets
```

## The Mirror Script

`mirror-skills.ps1` copies skills from this repo into the OpenCode skills
folder. It is **additive and never destructive**:

- **Adds** skills that exist in the repo but not in the target.
- **Updates** files of existing skills when they changed in the repo.
- **Never removes** skills or files that exist only in the target folder.
- **Cleans** copied files of NTFS alternate data streams (e.g. the
  `Zone.Identifier` "Mark of the Web" that Windows attaches to downloaded
  files), so that junk never propagates into the target folder.

```powershell
.\mirror-skills.ps1                  # sync to %USERPROFILE%\.config\opencode\skills
.\mirror-skills.ps1 -WhatIf          # preview changes only
.\mirror-skills.ps1 -TargetPath X    # sync to a custom folder
```

The script prints a summary of added / updated / unchanged / skipped skills.

## Workflow

1. **Create or edit** a skill in this repo (see `skills-maintenance/SKILL.md`
   for the skill format and full maintenance guide).
2. **Commit and push**:
   ```powershell
   git add -A
   git commit -m "add: my-skill"
   git push origin master
   ```
3. **Sync** to the OpenCode folder:
   ```powershell
   .\mirror-skills.ps1
   ```

### Removing a skill

The mirror never deletes. To retire a skill: delete its directory here,
commit and push, then manually remove the folder from
`%USERPROFILE%\.config\opencode\skills`.

## Notes

- A skill is any top-level directory containing a `SKILL.md`. Directories
  without one are skipped by the mirror with a warning.
- Don't edit skills directly in the OpenCode folder - the repo is the source
  of truth and the next mirror run will overwrite repo-tracked files.
