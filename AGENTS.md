# Repository instructions

This repository owns a curated public library of reusable Agent Skills, not every skill installed on an agent host. Read [skills-maintenance/SKILL.md](skills-maintenance/SKILL.md) for changes to this library or its distribution.

## Invariants

- One active skill per directory under `skills/`; its `SKILL.md` begins with valid YAML containing the matching name and a discriminative description. The maintenance skill is repo-only.
- Preserve verified original license text and copyright notices. Record origin, historical source anchor, modifications and uncertainty in each skill's `PROVENANCE.md`; keep the root `THIRD_PARTY_NOTICES.md` index current. Never invent a copyright owner, license or import revision. Original repository material uses MIT; third-party material keeps its own license.
- `skills-policy.json` is the sole deployment policy. Keep its active sets, README catalog and provenance index aligned in the same commit. Retire duplicate/bundled or no-longer-useful skills explicitly; preserve historical provenance in Git. Do not create new global workflow instructions merely because a technique exists.
- Keep user and project-specific skills outside this public library. Never include private profiles or secrets. A shared skill must not override repository-owned architecture, security, scope or qualification.
- Edit the canonical checkout, not deployment targets. Only mirror committed, clean skill sources. Never blindly delete or overwrite unowned local content: the mirror archives changed managed directories, preserves unknown entries, and archives excluded/retired names only with explicit `-Reconcile`. No automatic deletion or cache cleanup.
- Stage only the relevant files; use a work-descriptive branch and PR for coordinated changes. Do not sweep unrelated uncommitted work into a commit or force push.

## Verification

Use `python tests/check-repository.py` (requires PyYAML) for the policy, catalog, frontmatter and provenance structure. Run `tests/test-mirror-skills.ps1` in Windows PowerShell for mirror behavior, especially after script or profile changes. No host installation is needed for the fixture tests. Run a read-only preview before changing real targets and a separate `-Check` afterward. Do not report native verification unless it was actually run.

Detailed commands and safe recovery are in the maintenance skill and README.
