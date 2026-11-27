---
name: systematic-debugging
description: >-
  Use for a concrete non-trivial defect, regression, or failure whose cause is uncertain. Diagnose from evidence and verify proportionately; do not impose a ritual on a clear mechanical correction.
---

# Systematic Debugging

Follow project instructions and role boundaries. Read-only investigators may inspect evidence and use authorized non-mutating reproductions, but do not edit code or add instrumentation. For obvious mechanical failures supported by the existing error and source, fix and verify directly.

1. Establish the claim: expected behavior, observed symptom, relevant revision/environment, and the smallest useful reproduction. Read actual errors, recent changes and relevant boundary logs; avoid exposing credentials or collecting unrelated data.
2. Trace the failing path and compare with a working case when helpful. State the likely cause and what evidence could disprove it. If uncertainty remains, run the cheapest safe diagnostic that distinguishes competing explanations. Reuse applicable evidence; avoid repeatedly reproducing known failures without a reason.
3. When authorized, correct the cause within the owning scope. Add or strengthen a behavior-level regression check where useful; show it detects the original failure when practicable. If the evidence invalidates an accepted contract, resolve the architectural owner before expanding implementation.
4. Verify the actual symptom and affected contract using the project's required gates and proportionate evidence. Report observed result, residual uncertainty and any blocked gate. A passing narrow check proves only its covered behavior.

After unsuccessful attempts, reassess the model of the failure and broaden investigation only along relevant paths. Escalate genuine architecture, permission, destructive or scope conflicts rather than stopping at an arbitrary attempt count. Do not create a new tracker, forced full-suite run, or parallel agent workflow merely to follow this skill.
