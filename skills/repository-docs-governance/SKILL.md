---
name: repository-docs-governance
description: Use when auditing or restructuring a repository's AGENTS.md hierarchy, codemaps, documentation indexes, README guidance, and project skills; also use for periodic documentation-governance refreshes that identify stale, duplicated, misplaced, or missing repository instructions.
---

# Repository Documentation Governance

Optimize the repository's instruction and documentation system, not merely its
prose. The goal is maximum useful instruction density: critical constraints are
always available, while topology, procedures, and reference explanations live in
authoritative on-demand locations.

This skill does not replace a technical-writing skill for drafting user guides or
the `codemap` skill for generating a new repository atlas.

## Choose The Mode

- **Audit:** inspect and recommend changes without editing.
- **Migration:** implement an accepted redistribution of instructions and docs.
- **Refresh:** compare the current system with repository reality and update
  stale indexes, codemaps, guidance, and skill routing.

Infer the mode from the request. Do not edit during an audit-only request.

## Classification Model

Classify each meaningful rule or section before moving it:

| Kind | Destination |
| --- | --- |
| Invariant needed before action | Root `AGENTS.md` |
| Subtree-wide invariant | Nearest nested `AGENTS.md` |
| Location, topology, ownership, entry point | `codemap.md` or equivalent atlas |
| Task-specific procedure | Small on-demand skill |
| Detailed explanation or authoring reference | Architecture/development docs |
| Duplicate, historical, superseded, or low-value text | Remove or archive |

Do not assume every rule removed from `AGENTS.md` should become a skill.

## 1. Discover The Current System

Read enough context to identify authoritative homes before proposing changes:

1. Root and nested `AGENTS.md`, `CLAUDE.md`, or configured instruction files.
2. Root and nearest codemaps, architecture maps, or ownership indexes.
3. Documentation landing pages and current/archive indexes.
4. README/contributing guidance that repeats agent instructions.
5. Project-local skills and relevant OpenCode configuration or ignore rules.
6. Version-control status so unrelated work is preserved.

Measure root instruction lines/words and the effective context for representative
subtrees. A compact root can still be costly when large nested guides stack with
it.

If behavior depends on OpenCode discovery, precedence, or skill paths, consult
current OpenCode documentation and test the installed runtime. References named
inside `AGENTS.md` are routing instructions; do not assume their bodies are
automatically loaded.

## 2. Audit Ownership And Drift

Check for:

- safety, security, storage, publication, and architecture rules that must remain
  always-on;
- topology and implementation inventories duplicated outside the codemap;
- detailed procedures embedded in universal instructions;
- hand-maintained document catalogs that duplicate an index;
- exact counts, route lists, filenames, commands, status summaries, and dated
  archive paths likely to drift;
- current plans mixed with completed or historical evidence;
- skills whose names/descriptions do not reveal when to load them;
- instructions already enforced by a stronger authoritative mechanism;
- conflicting statements across README, guides, codemaps, and docs;
- critical rules reachable only through an optional skill.

Prefer one authoritative owner plus concise routing links over synchronized
copies.

## 3. Design The Target Hierarchy

Keep root instructions focused on orientation, universal work rules, hard
architecture invariants, safety/storage/security boundaries, publication rules,
and explicit on-demand workflow triggers.

Use nested guides only for durable rules that apply throughout one subtree and
are irrelevant elsewhere. Do not add a nested guide merely to hold a file list.

Use skills for coherent task categories with clear literal triggers. Each skill
should contain only the workflow and local constraints needed for that category,
then link to authoritative docs/codemaps. Avoid one giant catch-all development
skill and many microscopic skills.

Use codemaps for navigation and ownership facts. Use docs for durable rationale,
behavior explanations, authoring guidance, and historical evidence. Let docs
indexes own document inventories.

## 4. Migrate Safely

1. Record the accepted contract and evidence criteria when the repository
   requires tracked or specification-driven work.
2. Add or update destination files before deleting source guidance.
3. Maintain a crosswalk so every removed critical rule has an authoritative home.
4. Add discriminative skill triggers to the root or nearest always-on guide.
5. Keep project skills in the repository's committed project-skill path.
6. If the tool directory also stores local runtime state, unignore only committed
   skill/config source rather than the entire directory.
7. Remove duplicated catalogs, procedures, examples, and volatile status prose.
8. Preserve unrelated work and publish only when requested.

Do not optimize for a line-count target at the expense of safety or architecture.

## 5. Refresh Existing Documentation

For a periodic refresh, compare documentation claims against current evidence:

- filesystem topology and code ownership versus codemaps;
- docs directory contents versus indexes;
- active plans versus archive state;
- commands and paths versus scripts/configuration;
- architecture status and non-goals versus accepted current records;
- storage/runtime ownership versus path helpers and application behavior;
- root/nested skill routing versus installed project skills;
- README summaries versus authoritative indexes.

Update only facts supported by current code, configuration, tests, or accepted
records. Do not promote archived documents back to authority or silently change
product behavior through a documentation refresh.

## 6. Verify The Governance Contract

Use the narrowest available checks:

- inspect final status and diff, including untracked additions;
- run whitespace/format checks appropriate for documentation;
- verify all referenced local paths exist;
- validate every `SKILL.md` frontmatter name, folder match, and description;
- use `opencode debug skill --pure` when available to prove native discovery;
- search for removed stale phrases and duplicate inventories;
- recount root and representative nested effective context;
- test representative task prompts against skill descriptions;
- confirm no critical invariant depends only on optional skill loading.

Application tests are unnecessary for pure instruction/docs changes unless the
repository contract requires them or source/configuration behavior also changed.

## Output

For an audit, report an executive assessment, section-by-section classification,
target root structure, proposed skills, nested/codemap changes, duplication and
stale-content findings, and a low-risk migration plan.

For a migration or refresh, report the authoritative ownership changes, preserved
invariants, verification evidence, publication state, and any unresolved drift or
runtime-discovery caveat.
