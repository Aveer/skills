---
name: skills-maintenance
description: Maintain Aveer/skills, its provenance and distribution policy. Use only when explicitly curating, editing, licensing, validating or synchronizing this repository; not general skill creation or routine project work.
---

# Skills Maintenance

This repo is the canonical public library. Keep a skill only if its specialized knowledge or method materially improves work. Prefer native host facilities and project-owned contracts over duplicated general workflows. Make useful technology knowledge available across coding hosts; do not infer which host implements versus reviews. Activation depends on the concrete task and installed technologies, not the host. Do not mirror the repo-only maintenance skill or package private personal context.

## 1. Curate and attribute

- Read the existing skill, its supporting files, actual source/authority, upstream license and version or historical source anchor. For a new import, inspect the exact source before copying; record the revision, path, copyright and license in `PROVENANCE.md`. Preserve all applicable upstream licenses and notices with the files, including reference-level notices when consolidating. If permission is unresolved, do not distribute a new import. For an existing ambiguous copy, report and resolve the uncertainty; do not guess or silently change its license.
- Original repository material uses the root MIT convention. A local wrapper does not relicense third-party references. Mark adaptations and scope them to the current host and installed versions. Prefer a focused trigger and on-demand references; don't chain-load irrelevant skills.
- Maintain `skills-policy.json`: agents = shared local ChatGPT/Codex selection; opencode = the same defaults unless an actual host-specific requirement warrants a difference; optional = retained on-demand skills; nexusCandidates = advisory relevant subset of agents (not a deployment destination); retired = exact historical names eligible for explicit local archival; repoOnly = maintenance skill. Keep README and THIRD_PARTY_NOTICES in sync.
- Check for existing personal-context or project consumers and OMO bundled equivalents before retiring or renaming. Update explicit references to retired names; don't duplicate project-specific governance in global skills.

## 2. Validate and publish

1. Work from the live correct base and preserve unrelated edits. Review the exact diff; stage only intended files and use the repository PR workflow. Do not run a deployment mirror against an uncommitted skill/policy change.
2. Run `python tests/check-repository.py` (PyYAML required). For mirror changes, execute `tests/test-mirror-skills.ps1` on Windows PowerShell; it creates isolated temporary fixtures. Reuse applicable evidence; do not claim host behavior from static review.
3. Integrate only when required checks are satisfied and merge is authorized. Source of truth remains the Git repository, not local agent configuration or a plugin snapshot.

## 3. Synchronize on Windows

Run commands from a clean canonical checkout after updating it. Never modify real targets before inspecting the plan.

```powershell
git status --short
.\mirror-skills-agents.ps1 -Reconcile -WhatIf
.\mirror-skills-opencode.ps1 -Reconcile -WhatIf
```

If the previews show exactly the intended changes, apply:

```powershell
.\mirror-skills-agents.ps1 -Reconcile
.\mirror-skills-opencode.ps1 -Reconcile
```

Verify:

```powershell
.\mirror-skills-agents.ps1 -Check
.\mirror-skills-opencode.ps1 -Check
```

- Both wrappers use one engine. Default updates selected profiles only; changed existing directories are archived before replacement. `-Reconcile` additionally archives known retired/out-of-profile names; no target entries are deleted. Unknown/private/project-only entries remain untouched and are reported.
- Backups are in a sibling `skill-mirror-backups` directory outside active skill discovery. Keep the backup until host behavior is verified. To recover a specific directory, inspect the backup and destination, then move it back only after protecting any replacement.
- `-Check` reads exact managed file sets and SHA-256 hashes; managed drift fails the check, unmanaged entries do not. `-WhatIf` makes no changes.
- `-IncludeSkill <name>` explicitly adds retained optional or other-profile skills. Pass the same include list on future checks/reconciliations, or deliberately archive it; do not create a second policy. A custom target can be specified using `-TargetPath`.
- Source is limited to a clean tracked Git checkout. Links/reparse points and overlapping roots are refused. Copy only main file streams; source metadata is not modified.

After synchronization, reload the affected host if needed, check its actual skill catalog and update explicit OMO skill grants where retired names were locally overridden. A local .agents mirror is not proof of availability in a remote ChatGPT session. Do not publish a duplicate account plugin unless explicitly needed.
