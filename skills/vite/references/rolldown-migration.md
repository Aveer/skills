---
name: vite-rolldown
description: Vite 8 Rolldown bundler and Oxc transformer migration
---

# Rolldown Migration (Vite 8)

Vite 8 replaces esbuild+Rollup with Rolldown, a unified Rust-based bundler.

## What Changed

| Before (Vite 7)            | After (Vite 8)    |
| -------------------------- | ----------------- |
| esbuild (dev transform)    | Oxc Transformer   |
| esbuild (dep pre-bundling) | Rolldown          |
| Rollup (production build)  | Rolldown          |
| `rollupOptions`            | `rolldownOptions` |
| `esbuild` option           | `oxc` option      |

## Performance Impact

Treat upstream performance claims as version- and workload-dependent. Measure
the project's actual build only when the question calls for performance evidence.
A change in bundler does not guarantee a particular speedup or runtime benefit.

## Config Migration

### rollupOptions → rolldownOptions

```ts
// Before (Vite 7)
export default defineConfig({
  build: {
    rollupOptions: {
      external: ['vue'],
      output: { globals: { vue: 'Vue' } },
    },
  },
})

// After (Vite 8)
export default defineConfig({
  build: {
    rolldownOptions: {
      external: ['vue'],
      output: { globals: { vue: 'Vue' } },
    },
  },
})
```

### esbuild → oxc

```ts
// Before (Vite 7)
export default defineConfig({
  esbuild: {
    jsxFactory: 'h',
    jsxFragment: 'Fragment',
  },
})

// After (Vite 8)
export default defineConfig({
  oxc: {
    jsx: {
      runtime: 'classic',
      pragma: 'h',
      pragmaFrag: 'Fragment',
    },
  },
})
```

### JSX Configuration

```ts
export default defineConfig({
  oxc: {
    jsx: {
      runtime: 'automatic',  // or 'classic'
      importSource: 'react', // for automatic runtime
    },
    jsxInject: `import React from 'react'`,  // auto-inject
  },
})
```

### Custom Transform Targets

```ts
export default defineConfig({
  oxc: {
    include: ['**/*.ts', '**/*.tsx'],
    exclude: ['node_modules/**'],
  },
})
```

## Plugin Compatibility

Most Vite plugins work unchanged. Rolldown supports Rollup's plugin API.

If a plugin only works during build:

```ts
{
  ...rollupPlugin(),
  enforce: 'post',
  apply: 'build',
}
```

## New Capabilities

Rolldown unlocks features not possible before:

- Full bundle mode (experimental)
- Module-level persistent cache
- More flexible chunk splitting
- Module Federation support

## Migration scope

Historical transition packages and overrides are not baseline dependencies.
Only consider changes within an explicitly authorized migration; inspect
actual compatibility, locked versions, compiler/plugin integration and
production output. Use the project's existing package manager and agreed
qualification gates. Do not override transitive Vite or install an intermediate
bundler just because this reference describes a migration.

<!--
Source references:
- https://vite.dev/blog/announcing-vite8-beta
- https://vite.dev/blog/announcing-vite7
- https://vite.dev/config/shared-options#oxc
-->
