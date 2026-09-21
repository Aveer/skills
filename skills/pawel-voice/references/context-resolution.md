# Personal-context resolution

The public skill must not embed a private copy of Paweł's personal profile.

## Canonical source

Expected canonical repository:

`Aveer/personal-context` (private)

Relevant path for this skill:

`voice/`

## Resolution order

Try, in order:

1. an explicitly configured `PAWEL_PERSONAL_CONTEXT_ROOT`;
2. a host/application-specific configured personal-context root;
3. a controlled sibling checkout named `personal-context`.

Do not guess arbitrary machine-specific absolute paths.

## Sync model

The canonical repository is authoritative. Local copies are consumer mirrors.

Preferred direction:

`Aveer/personal-context -> local mirror -> agent/skill consumer`

Do not silently write calibration changes into a mirrored copy and assume they
reached canonical storage. Changes to the fingerprint should be committed back
to the private source-of-truth repository through an explicit maintenance
workflow.

## Privacy boundary

Load only what the task needs.

For writing-voice work, normally read only:

- `voice/profile.md`;
- `voice/calibration.md` when needed;
- relevant `voice/examples/*`.

Do not load career, interests, or other personal context merely because it is
available.
