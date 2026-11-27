---
name: vitest
description: Use for a concrete Vitest API, fixture, mocking, timer, environment, configuration or test-diagnostic problem in a project that uses Vitest. Not a mandatory testing or verification methodology.
license: MIT
---

# Vitest

Use the installed Vitest version, current test configuration, repository test
scripts and accepted behavioral/architecture contracts. Follow the real
package manager. Do not change coverage thresholds, pools, parallelism,
dependency versions or the selected test stack simply to match an example.

Read only the relevant reference:

| Topic | Reference |
| --- | --- |
| Configuration, CLI, projects | [config](references/config.md) |
| Test API, hooks and fixtures | [test-api](references/test-api.md) |
| Mocks, timers, spies | [mocking](references/mocking.md) |
| Assertions, snapshots, filtering, coverage | [utilities](references/utilities.md) |
| Environments, browser mode, type tests | [advanced](references/advanced.md) |

Use the actual tests and project gate for the intended claim. Mocks and DOM
emulators are useful for some claims; do not present them as proof of native
browser, real dependency, integration or lifecycle behavior when those are
required. An accepted test mapping and applicable existing evidence take
precedence over generic testing recipes. No mandatory extra test plan,
coverage change, test count, full-suite run or review phase follows from this
reference. Confirm version-sensitive APIs before using them.
