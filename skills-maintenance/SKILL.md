---
name: skills-maintenance
description:
  Maintain the skills repository - create new skills, modify existing ones,
  sync skills to the OpenCode and cross-harness .agents skills folders, and
  manage the repo. Use whenever a skill needs to be created or edited,
  skills need to be synced, or the skills repo needs to be maintained
  (commits, push, cleanup).
---

# Skills Maintenance

This repo is the **source of truth** for all agent skills. Skills live in
`skills/`; the meta skill (this one) lives at the repo root. Skills are
deployed to two targets, kept in sync from this repo by additive mirror
scripts:

- **OpenCode:** `%USERPROFILE%\.config\opencode\skills` via
  `mirror-skills-opencode.ps1`
- **Cross-harness (.agents):** `%USERPROFILE%\.agents\skills` via
  `mirror-skills-agents.ps1` — the de-facto global skills folder read
  natively by Codex CLI, Cursor, Gemini CLI, VS Code/Copilot, and OpenCode
  (compat). Claude Code does not read it (it uses `~/.claude/skills`).

## Repo Layout

```
skills/
├── AGENTS.md                  # Rules for agents working in this repo
├── README.md                  # Human-facing documentation (includes the skill list)
├── mirror-skills-opencode.ps1 # Additive sync: repo -> OpenCode skills folder
├── mirror-skills-agents.ps1   # Additive sync: repo -> .agents skills folder
├── skills-maintenance/        # This meta skill (root-level, not in skills/)
└── skills/
    └── <skill-name>/          # One directory per skill
        ├── SKILL.md           # Required: frontmatter (name, description) + body
        └── ...                # Optional: scripts, references, assets
```

A skill is any directory under `skills/` that contains a `SKILL.md`. The
only skill directory at the repo root is this meta skill.

## Creating a New Skill

1. Create a new directory under `skills/` named after the skill (kebab-case).
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
4. Add the skill to the "Skills" list in `README.md`.
5. Commit and push (see "Repo Maintenance").
6. Sync to both targets (see "Syncing").

## Modifying a Skill

1. Edit the skill files in this repo.
2. If the skill's name or description changed, update the "Skills" list in
   `README.md`.
3. Commit and push.
4. Run the mirrors to propagate changes.

Never edit skills directly in a deployment target folder - local-only edits
will be overwritten by the next mirror run (for files that also exist in the
repo).

## Syncing (Repo -> Target Folders)

Run both mirror scripts from the repo root:

```powershell
.\mirror-skills-opencode.ps1   # -> %USERPROFILE%\.config\opencode\skills
.\mirror-skills-agents.ps1     # -> %USERPROFILE%\.agents\skills
```

Useful variants:

```powershell
.\mirror-skills-opencode.ps1 -WhatIf              # preview, change nothing
.\mirror-skills-agents.ps1 -TargetPath D:\other   # mirror to a custom folder
```

### Mirror semantics (additive, never destructive)

| Situation | Behavior |
| --- | --- |
| Skill in repo, missing in target | Copied over in full (added) |
| Skill in both, file changed in repo | Target file overwritten from repo |
| Skill in both, file identical | Left alone |
| File/skill only in target | **Never touched, never removed** |
| Repo directory without SKILL.md | Skipped with a warning |
| Windows "Mark of the Web" streams | Stripped from copied files |

The mirrors only ever add or update. They never delete anything from the
target folders. Copied files are cleaned of NTFS alternate data streams
(e.g. `Zone.Identifier`), so downloaded-file junk never propagates.

## Removing a Skill

The mirrors cannot remove skills. To retire a skill:

1. Delete the skill directory from `skills/`.
2. Remove it from the "Skills" list in `README.md`.
3. Commit and push.
4. Manually delete the skill folder from each deployment target
   (`%USERPROFILE%\.config\opencode\skills\<skill-name>` and
   `%USERPROFILE%\.agents\skills\<skill-name>`).

## Repo Maintenance

- **Commit** after every skill change: `git add -A; git commit -m "..."`.
  Use clear messages: `add: <skill>`, `update: <skill>`, `remove: <skill>`.
- **Push** to the GitHub remote (`origin`) so the repo stays backed up:
  `git push origin master`.
- **Keep the README skill list current**: the "Skills" table in `README.md`
  must match the directories in `skills/` (add/remove/rename entries in the
  same commit as the skill change).
- Keep one skill per directory under `skills/`; no loose skill files at the
  root, no nested skill directories. The only root-level skill directory is
  this meta skill.
- Keep `SKILL.md` frontmatter valid (parseable YAML, `name` matches the
  directory).
- After structural changes (new scripts, renamed files), run
  `.\mirror-skills-opencode.ps1 -WhatIf` and
  `.\mirror-skills-agents.ps1 -WhatIf` to sanity-check what will sync.

## Quick Reference

| Task | Command / Action |
| --- | --- |
| Create skill | New dir under `skills/` + `SKILL.md`, README list, commit, push, mirror |
| Edit skill | Edit in repo, README list if needed, commit, push, mirror |
| Sync to OpenCode | `.\mirror-skills-opencode.ps1` |
| Sync to .agents | `.\mirror-skills-agents.ps1` |
| Preview sync | `.\mirror-skills-opencode.ps1 -WhatIf` / `.\mirror-skills-agents.ps1 -WhatIf` |
| Remove skill | Delete dir, README list, commit, push, manual delete in both targets |
| Backup | `git push origin master` |
