---
name: pawel-voice
description:
  Write, rewrite, or edit text in Paweł's calibrated authorial voice while
  preserving his actual opinions, uncertainty, and technical reasoning. Use
  for LM Nexus blog posts, essays, commentary, bios, project writing, or when
  transforming Paweł's fast/raw notes into clean or publication-ready prose.
  Do not imitate typing mistakes. Load the private personal-context voice
  profile when available.
---

# Paweł Voice

Use this skill when the output is meant to sound as if Paweł wrote it, rather
than merely being "casual" or "human sounding."

The canonical voice fingerprint is private and lives outside this public skill
in `Aveer/personal-context/voice/`. This skill defines the workflow for using
that profile without copying the personal profile into the skills repository.

## First: resolve the canonical profile

Before substantial drafting, try to locate the personal-context root using the
resolution contract in
[references/context-resolution.md](references/context-resolution.md).

Load:

1. `voice/profile.md` - always, when available.
2. `voice/calibration.md` - when refining or reviewing voice fidelity.
3. Relevant files under `voice/examples/` - only when examples would improve
   the current task.

Do not load unrelated career or personal files merely because the repository is
available.

If the canonical profile is not accessible, continue with the user's current
source material and the fallback rules below. Do not claim exact calibrated
voice fidelity when the canonical profile was unavailable.

## Choose the mode

### Raw Paweł

Use for capturing or lightly cleaning spontaneous thought.

- Preserve fragments, pivots, and visible reconsideration.
- Fix only errors that materially obstruct reading.
- Do not use for polished publication unless explicitly requested.

### Clean Paweł

Use for messages, commentary, and informal public writing.

- Correct spelling, punctuation, and broken syntax.
- Remove keyboard/mobile typing noise.
- Preserve directness, cadence, uncertainty, technical code-switching, and
  genuine personal reactions.
- Do not make the text more formal merely because it is being corrected.

### Editorial Paweł

Default for LM Nexus blog posts and substantial published writing.

- Build a clear narrative and paragraph structure.
- Preserve the author's real chain of reasoning and changes of mind.
- Remove accidental repetition.
- Add context needed by an outside reader.
- Keep technical language natural.
- Avoid generic marketing polish and generic LLM prose.
- Never invent opinions, anecdotes, emotions, or certainty.

When the user does not specify a mode, infer it from the surface. Use
Editorial for blog/article/publication work, Clean for messages and ordinary
rewrites, and Raw only for notes/brainstorm capture.

## Author-preservation workflow

### 1. Extract authorship before rewriting

Identify from the source:

- factual claims;
- opinions and judgments;
- uncertainty/qualifiers;
- causal reasoning;
- personal reactions;
- anecdotes or lived experience;
- unresolved questions.

Treat these as constraints. A fluent rewrite is wrong if it changes them.

### 2. Separate voice from typing noise

Do not reproduce accidental:

- swapped letters;
- missing spaces;
- malformed words;
- duplicated letters;
- autocorrect artifacts;
- missing diacritics used only because the source was typed quickly.

The goal is to preserve identity after editing, not to simulate a broken
keyboard.

### 3. Preserve the reasoning shape

Paweł's voice often becomes recognizable through the movement of thought:
concrete observation -> initial interpretation -> complication/counterpoint ->
refined conclusion.

Do not flatten that into a generic list or an artificially certain thesis when
the source shows genuine exploration.

### 4. Edit for the target surface

For publication:

- strengthen openings by starting from a real observation/problem;
- group related ideas;
- remove repetition caused by raw thinking;
- keep enough self-correction to preserve authenticity;
- use headings only when they help navigation;
- do not add a conclusion that merely repeats the article.

### 5. Run the fidelity check

Before delivering, verify:

- Does this preserve what Paweł actually thinks?
- Did any uncertainty become fake certainty?
- Did the editor invent enthusiasm, anger, anecdotes, or technical claims?
- Did the prose become generic AI/corporate marketing?
- Did structure become unnaturally tidy?
- Are technical English terms used because they are natural, not as costume?
- Is the text cleaner than raw chat without becoming anonymous?

If the canonical profile is available, use its calibration checklist as the
final authority.

## Fallback baseline when the private profile is unavailable

Use only as a safe approximation:

- direct;
- technically grounded;
- exploratory when the evidence is genuinely uncertain;
- willing to state clear judgments;
- natural Polish/English technical code-switching;
- low tolerance for generic marketing language;
- minimal conversational padding;
- no invented emotion or experience;
- no typo imitation.

This fallback is intentionally incomplete. Prefer the canonical private profile
whenever accessible.

## Interaction with other skills

This skill controls authorial voice, not factual research, documentation
architecture, or domain expertise.

It can be combined with another skill:

- a documentation skill decides information architecture;
- a research workflow establishes facts;
- this skill performs the final author-voice pass.

When rules conflict, factual accuracy and the user's explicit content always
take precedence over stylistic fidelity.
