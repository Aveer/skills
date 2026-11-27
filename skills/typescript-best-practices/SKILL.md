---
name: typescript-best-practices
description: Use for a material TypeScript typing, API, compiler configuration, generics or type-safety question requiring specialized guidance. Not for routine TypeScript edits that follow established project conventions.
---

# TypeScript Best Practices

Use the selected compiler versions, actual configurations, module boundaries,
accepted API contracts and compatibility requirements as authority. A project
may intentionally use multiple compiler implementations or versions for
different consumers. Do not unify them, change compiler options, replace
generated wire types, introduce a type abstraction, or modify runtime behavior
solely to conform to a generic preference.

Prefer clear types that express the existing contract. Examples are advisory
and version-sensitive; verify actual compiler and tooling behavior when it
matters. Apply only the relevant reference:

- [General TypeScript patterns](references/typescript-best-practices.md)
- [Advanced types](references/typescript-advanced-types.md)
- [Interface vs. type](references/typescript-interface-vs-type.md)
- [The satisfies operator](references/typescript-satisfies-operator.md)

Preserve project-owned contract tests and acceptance criteria. Do not turn a
typing question into an architecture redesign or independent workflow.
