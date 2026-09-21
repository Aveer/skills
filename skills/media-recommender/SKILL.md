---
name: media-recommender
description:
  Personalized cross-media recommendation and ranking workflow driven by a
  supplied taste profile. Use when recommending, comparing, prioritizing, or
  choosing games, manga, anime, visual novels, films, or TV for a specific
  person while separating personal fit from general reputation, concept fit
  from execution confidence, and title fit from medium/platform fit.
compatibility:
  Web access is recommended when current availability, release status,
  adaptation status, regional catalog access, product state, patches/DLC, or
  platform support can materially change the recommendation.
---

# Media Recommender

Use this skill to make **profile-driven recommendations** without baking one
person's tastes into the reusable workflow.

The recommendation engine and the user's taste profile are separate artifacts.

## Inputs

Use, in order:

1. the user's current message and explicit constraints;
2. a supplied/current taste profile;
3. prior calibration examples, when available;
4. current external facts when they materially affect the decision.

If no durable profile exists, build a provisional one from explicit user
preferences using [assets/profile-template.md](assets/profile-template.md).
Do not pretend the recommendation is deeply personalized when evidence is thin.

## Load references

For substantial work, read:

- [references/scoring.md](references/scoring.md) - explainable fit and confidence.
- [references/domain-overlays.md](references/domain-overlays.md) - domain-specific considerations.
- [references/output-formats.md](references/output-formats.md) - response shapes.

For a tiny one-title fit check, the active profile plus the relevant domain
section may be enough.

## Core rules

1. **Current user evidence wins.**
   If a current reaction conflicts with a stored profile, treat the reaction as
   calibration evidence rather than forcing it through the old model.

2. **Do not overfit one anecdote.**
   Separate foreground cause from incidental traits before changing a broad
   preference rule.

3. **Separate personal fit from general reputation.**
   A famous or critically acclaimed work is not automatically the best fit.

4. **Separate concept fit from execution confidence.**
   A premise/design can look ideal while evidence that the work actually
   delivers remains weak.

5. **Rate the version/path, not only the IP.**
   Anime vs manga vs VN, platform choice, game state, edition, patches, DLC, or
   release timing can materially change the recommendation.

6. **Distinguish slow from static.**
   Slow pacing can still accumulate tension, knowledge, character change,
   systems mastery, or payoff. Repetition without meaningful accumulation is a
   different risk.

7. **Treat striking traits as modifiers, not automatic foundations.**
   Gore, transgression, nostalgia, aesthetics, difficulty, novelty, or genre
   labels should not dominate the model unless the user profile shows that
   they genuinely do.

8. **Track journey fit and payoff fit separately when useful.**
   Some works are mediocre moment-to-moment but unusually strong in their
   eventual emotional/conceptual payoff.

9. **Prefer explainable recommendations.**
   State the dominant fit mechanisms and the main risk rather than returning
   unexplained scores.

10. **Verify current facts live when they matter.**
    Examples: regional availability, adaptation completeness, release state,
    DLC/patch status, platform support, pricing, or whether a game is still
    rapidly changing.

11. **Avoid spoilers by default.**
    Discuss hooks, structure, design, tone, and risks without revealing major
    late twists, deaths, identities, or endings unless requested.

## Workflow

1. Identify the request type:
   - one-title fit check;
   - comparison;
   - ranked shortlist;
   - what-to-start-next;
   - best medium/version;
   - backlog recalibration.

2. Load the smallest relevant part of the taste profile.

3. Choose the domain overlay:
   - games;
   - manga/anime/VN;
   - films/TV.

4. Gather current facts if needed.

5. Evaluate:
   - concept fit;
   - execution confidence;
   - medium/platform/path fit;
   - dominant fit mechanisms;
   - meaningful risks;
   - friction/commitment.

6. For a ranking, compare candidates on the same dimensions. Avoid fake
   numerical precision when evidence is weak.

7. Recommend the practical path:
   - start now;
   - try a low-friction sample first;
   - choose another medium/version;
   - wait for a materially better release state.

8. When the user reports a reaction, update calibration conservatively.

## Profile maintenance

A good taste profile should contain:

- stable cross-domain preference dimensions;
- domain overlays;
- positive/negative calibration examples;
- anti-overfitting notes;
- provisional vs confirmed evidence;
- response preferences;
- optional machine-readable weights.

Keep **durable taste** separate from transient state such as "currently
watching/playing" unless a separate system owns that state.

## Final quality check

Before finalizing:

- Did I confuse prestige with personal fit?
- Did I overfit one example?
- Did I explain why the recommendation fits?
- Did I separate concept fit from confidence?
- Did I account for the actual medium/platform/version?
- Did I distinguish slow build from static repetition?
- Did I flag the strongest mismatch/risk?
- Did I verify current facts when they matter?
- Did I avoid spoilers?
