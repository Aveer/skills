---
name: worktrees
description: >-
  Use when Git worktree isolation materially protects another active checkout or enables genuinely independent coding lanes. Use the repository's and harness's worktree policy first; never create extra lanes for routine work.
---

# Worktree Isolation

Prefer the existing owner branch and workspace. Inspect repository instructions, current branch, dirty state and `git worktree list` before changing anything. Reuse a suitable existing lane; avoid a new branch for probes or bookkeeping. Use the harness-native isolated workspace when applicable; otherwise follow the repository's Git conventions.

- Create an isolated lane only when authorized by the task or repository policy. Choose the correct base and a work-descriptive branch name; respect no-touch boundaries and unrelated working changes. Ask only when authorization is missing or the operation is destructive or crosses a protected boundary.
- For parallel execution, give each lane a coherent owner and non-overlapping scope; use independent agents only when the cost and dependency graph justify it. Do not require one lane or agent for every subtask.
- In an actual Oh My OpenCode Slim environment, `.slim/worktrees/<slug>/` and optional `.slim/worktrees.json` are a fallback convention only if compatible with repository policy. Existing project locations and tracking win. Local metadata is not a task tracker. Inspect ignore rules; change them only when necessary and authorized.
- Keep edits and builds inside the selected lane. Verify required acceptance gates with relevant evidence; do not automatically rerun lint/build/full tests for already qualified unchanged inputs.
- Review the exact diff and integrate only under the authorized repository workflow. Never remove a dirty or unintegrated worktree, delete unrelated branches, reset, clean or force-push without explicit authorization. Clean up safely after accepted integration when permitted.
