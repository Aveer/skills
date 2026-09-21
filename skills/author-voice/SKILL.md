---
name: author-voice
description:
  Build, calibrate, and apply an author's reusable writing voice profile. Use
  when analyzing writing samples to extract a style fingerprint, turning raw
  notes into polished prose without losing the author's identity, or writing
  new text that should match a supplied voice profile. Supports raw, clean,
  and editorial modes. Do not imitate accidental typos or invent opinions,
  experiences, or emotions.
---

# Author Voice

Use this skill when the goal is not merely "good writing" but preserving a
specific author's recognizable voice across editing and drafting.

The skill is intentionally generic. It contains no personal profile and no
hard-coded user identity. A voice profile must come from writing samples or be
supplied by the user.

## What this skill does

It supports two related workflows:

1. **Profile building** - analyze representative writing samples and produce a
   reusable voice fingerprint.
2. **Voice-preserving writing** - use that fingerprint to rewrite raw notes or
   draft new text while preserving the author's actual tone and reasoning.

A strong result should be cleaner than raw writing without becoming anonymous
or generic.

## Choose the mode

### Raw

Use for notes, brainstorming, or lightly cleaned spontaneous thought.

- Preserve fragments, pivots, and visible reconsideration.
- Fix only errors that materially obstruct reading.
- Keep the author's natural cadence.

### Clean

Use for messages, commentary, and informal public writing.

- Correct spelling, punctuation, and broken syntax.
- Remove typing noise and autocorrect artifacts.
- Preserve directness, uncertainty, code-switching, humor, and personal
  reactions where they are genuinely present.
- Do not make the text more formal merely because it is corrected.

### Editorial

Use for blog posts, essays, long-form articles, and substantial public writing.

- Build a clear narrative and paragraph structure.
- Preserve the author's real reasoning and changes of mind.
- Remove accidental repetition.
- Add context needed by an outside reader.
- Avoid generic corporate or LLM-style polish.
- Never invent opinions, anecdotes, emotions, or certainty.

If the user does not specify a mode, infer it from the surface: Editorial for
publication, Clean for ordinary rewriting, Raw only for notes/brainstorming.

## Workflow A: build a voice profile

When enough source writing is available:

1. Separate stable style from situational noise.
2. Identify recurring traits in:
   - sentence rhythm;
   - paragraph shape;
   - directness/formality;
   - uncertainty and qualification;
   - humor;
   - transitions;
   - rhetorical questions;
   - technical vocabulary and code-switching;
   - how arguments develop;
   - how strongly judgments are stated.
3. Explicitly exclude accidental typing patterns such as:
   - swapped letters;
   - missing spaces;
   - malformed words;
   - autocorrect artifacts;
   - missing punctuation caused by rushed typing.
4. Record anti-patterns: phrases or structures that make the result sound like
   a generic assistant instead of the author.
5. Create a reusable profile using
   [assets/voice-profile-template.md](assets/voice-profile-template.md).
6. Add calibration examples using
   [assets/calibration-template.md](assets/calibration-template.md).

Prefer stable patterns that appear across multiple topics. Do not overfit to a
single message or mood.

## Workflow B: apply a voice profile

### 1. Extract authorship constraints

Before rewriting, identify:

- factual claims;
- opinions and judgments;
- uncertainty/qualifiers;
- causal reasoning;
- personal reactions;
- anecdotes or lived experience;
- unresolved questions.

These are semantic constraints. Fluency must not change them.

### 2. Preserve reasoning shape

Voice is often carried by the movement of thought, not just vocabulary.

When the source follows a pattern such as:

`observation -> initial interpretation -> complication -> refined conclusion`

preserve that shape unless the target format genuinely requires a different
structure.

Do not flatten genuine exploration into an artificially certain thesis.

### 3. Separate voice from noise

Do not imitate accidental typos, keyboard slips, missing spaces, or malformed
words unless the user explicitly wants a faithful transcript.

The target is the author's voice after editing, not a simulation of rushed
typing.

### 4. Edit for the target surface

For publication:

- start from a real observation, question, or problem where possible;
- group related ideas;
- remove repetition caused by raw thinking;
- preserve enough self-correction to keep the writing human;
- use headings only when they improve navigation;
- avoid conclusion sections that merely repeat the article.

### 5. Fidelity check

Before delivering, verify:

- Did the meaning stay intact?
- Did uncertainty become fake certainty?
- Were any opinions, emotions, or experiences invented?
- Did the prose become generic marketing or generic AI copy?
- Did the structure become unnaturally tidy?
- Are distinctive vocabulary and code-switching used naturally rather than as
  costume?
- Is the result recognizably the same author, only better edited?

## Building confidence in a profile

Treat voice profiles as calibrated artifacts, not one-shot prompts.

Improve them with explicit feedback such as:

- "this sounds exactly like me";
- "too formal";
- "I would never use that phrase";
- "keep more of the hesitation";
- "less polished";
- "this is the right level for publication."

Record both positive and negative examples. Negative examples are especially
useful because they define the boundary of the voice.

## Interaction with other skills

This skill controls authorial voice, not factual research or information
architecture.

It can be combined with other skills:

- research establishes facts;
- documentation skills decide structure;
- this skill performs the author-voice pass.

Factual accuracy and explicit user intent always take precedence over stylistic
fidelity.
