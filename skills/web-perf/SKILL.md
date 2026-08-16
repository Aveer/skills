---
name: web-perf
description: Diagnose and improve real-world web performance, with first-class support for Vue 3, TypeScript, Vite, Vue Router, Nuxt, Electron, and Tauri. Use for slow loading, large bundles, rendering lag, poor Core Web Vitals, excessive memory or CPU usage, inefficient network behavior, and performance regressions.
---

# Web Performance Optimization

Measure first. Optimize the actual bottleneck. Preserve behavior and verify the result.

This skill is framework-aware. Do not copy React, Webpack, browser, SSR, PWA, or deployment-specific techniques into a project until the current stack has been identified.

## Use This Skill When

- Initial page load is slow.
- LCP, INP, CLS, FCP, TTFB, or Lighthouse results are poor.
- A Vue application renders or responds slowly.
- The JavaScript bundle is unexpectedly large.
- A route, panel, modal, editor, chart, table, or dashboard is expensive.
- Large lists stutter or freeze.
- Images, fonts, or third-party scripts delay rendering.
- Repeated requests or reactive updates waste work.
- A production build behaves differently from development.
- Performance regressed after a change.
- A desktop web renderer in Electron or Tauri uses excessive CPU or memory.

Do not use this skill merely to add fashionable optimizations. A change must address an observed cost or a clearly demonstrated risk.

## Primary Goals

Prioritize, in order:

1. Correctness and preserved behavior.
2. User-visible latency and responsiveness.
3. Core Web Vitals for public browser applications.
4. Bundle and network efficiency.
5. CPU, memory, and battery use.
6. Maintainability and observability.

## Required Workflow

### 1. Identify the Runtime and Build Stack

Inspect the repository before proposing changes.

Determine:

- Framework and version: Vue, Nuxt, React, Angular, vanilla, or another framework.
- Language: TypeScript or JavaScript.
- Build tool and version: Vite, Webpack, Rollup, Rolldown, esbuild, Nuxt, or another tool.
- Router: Vue Router, file-based routing, custom routing, or none.
- Runtime: browser SPA, SSR, SSG, Electron, Tauri, browser extension, embedded webview, or hybrid.
- Deployment: Nginx, CDN, static host, Node server, container, desktop package, or unknown.
- Existing PWA or service-worker setup.
- Existing monitoring, analytics, and performance budgets.
- Existing tests, build commands, and bundle-analysis tools.

Inspect at least:

- `package.json`
- lockfile
- build configuration
- router configuration
- application entry point
- deployment configuration when present
- relevant slow components or routes
- existing service worker or PWA configuration

Do not assume that a Vue project uses Vite. Do not assume that a Vite project uses the configuration syntax from a different Vite generation.

### 2. Establish a Baseline

Collect evidence before editing.

Use the most relevant available measurements:

- Production build output and chunk sizes.
- Browser DevTools Performance trace.
- Network waterfall.
- Lighthouse in a production-like build.
- Vue Devtools component performance.
- Chrome Performance Monitor.
- Coverage report for unused JavaScript and CSS.
- Memory allocation or heap snapshots.
- Long-task and event timing data.
- Real-user `web-vitals` telemetry when available.
- Framework or runtime profiler for Electron, Tauri, SSR, or Node.

Record:

- Test environment.
- Route or user action.
- Device or CPU throttling.
- Network profile.
- Cache state.
- Build mode.
- Metric values.
- Largest assets and chunks.
- Long tasks and expensive component updates.

Development-server measurements are not a substitute for a production build.

### 3. Classify the Bottleneck

Choose the dominant category:

- Server or network latency.
- Excessive JavaScript download or parsing.
- Render-blocking CSS or fonts.
- Slow LCP resource discovery.
- Expensive component rendering.
- Excessive reactive invalidation.
- Large DOM or unvirtualized lists.
- Layout instability.
- Main-thread blocking.
- Third-party scripts.
- Duplicate requests or inefficient data loading.
- Memory leak or retained objects.
- Cache or compression misconfiguration.
- Service-worker update or stale-cache issue.

Do not combine unrelated optimizations into one patch unless they are inseparable.

### 4. Apply the Smallest Effective Change

Prefer changes that are:

- Local.
- Measurable.
- Reversible.
- Compatible with the current stack.
- Easy to test.
- Unlikely to create stale-cache or update problems.

### 5. Verify

After each meaningful optimization:

- Build the production application.
- Run relevant tests.
- Reproduce the same scenario.
- Compare against the same baseline conditions.
- Check for functional, visual, routing, hydration, and accessibility regressions.
- Confirm that the cost was reduced rather than shifted elsewhere.

Report both improvements and trade-offs.

## Core Web Vitals

For browser applications, use field measurements at the 75th percentile when available.

| Metric | Good | Needs improvement | Poor |
|---|---:|---:|---:|
| LCP | ≤ 2.5 s | 2.5–4.0 s | > 4.0 s |
| INP | ≤ 200 ms | 200–500 ms | > 500 ms |
| CLS | ≤ 0.1 | 0.1–0.25 | > 0.25 |

Supporting diagnostics:

- TTFB for server and delivery latency.
- FCP for initial rendering.
- TBT for laboratory main-thread blocking.
- Long tasks for responsiveness diagnosis.
- Resource timing for network diagnosis.

Do not present TTI as a current Core Web Vital. Do not calculate INP manually from only `processingEnd - processingStart`.

## Vue 3 and TypeScript

### Lazy-Load Routes

Use dynamic imports for Vue Router route components:

```ts
import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    component: () => import('@/pages/Home.vue'),
  },
  {
    path: '/dashboard',
    component: () => import('@/pages/Dashboard.vue'),
  },
  {
    path: '/settings',
    component: () => import('@/pages/Settings.vue'),
  },
]

export const router = createRouter({
  history: createWebHistory(),
  routes,
})
```

Rules:

- Use route-level dynamic imports for substantial routes.
- Do not wrap route components in `defineAsyncComponent` unless there is a specific reason.
- Preserve router error handling and loading UX.
- Avoid creating dozens of tiny chunks without evidence that it helps.
- Consider route prefetching only for likely next navigation, not every route.

### Lazy-Load Heavy Non-Route Components

Use `defineAsyncComponent` for expensive components that are not needed initially:

```vue
<script setup lang="ts">
import { defineAsyncComponent } from 'vue'

const HeavyEditor = defineAsyncComponent({
  loader: () => import('@/components/HeavyEditor.vue'),
  delay: 150,
  timeout: 15_000,
})
</script>

<template>
  <HeavyEditor />
</template>
```

Good candidates:

- Editors.
- Large charts.
- 3D views.
- Complex settings panels.
- Rarely opened dialogs.
- Optional integrations.
- Admin-only tools.

Do not lazy-load a tiny component whose loading state costs more than its code.

### Mount Only When Needed

Choose intentionally between `v-if` and `v-show`.

- `v-if` avoids mounting and running a hidden expensive subtree.
- `v-show` keeps the subtree mounted and only toggles CSS display.

Prefer `v-if` for heavy, infrequently opened content. Prefer `v-show` for inexpensive content toggled frequently.

### Control Reactive Work

Inspect the dependency graph before applying memoization.

Prefer:

- `computed` for derived values rather than repeated template calculations.
- Stable object and array identities when passing props.
- Narrow watchers over deep watchers.
- Explicit watcher sources.
- Cleanup for timers, listeners, observers, and async operations.
- `shallowRef` or `shallowReactive` for large external objects that do not need deep reactivity.
- `markRaw` for third-party instances that must not be proxied.
- Pagination or virtualization for large collections.
- Debouncing only where delayed updates are acceptable.
- Throttling for high-frequency visual events such as resize or scroll.

Avoid:

- Deep-watching large state trees.
- Creating new objects or arrays in hot templates without reason.
- Repeated expensive filtering or sorting in templates.
- Global state updates that invalidate unrelated components.
- Watchers that write to their own dependencies.
- Unbounded event listeners, intervals, observers, or subscriptions.
- Premature `v-memo` use without profiling.

### Large Lists

For hundreds or thousands of rows:

- Use virtualization.
- Keep row keys stable and unique.
- Avoid expensive row-level watchers.
- Avoid mounting hidden detail panels for every row.
- Batch or paginate network data when appropriate.
- Keep selection and hover state local where possible.
- Measure scrolling, keyboard navigation, resizing, and updates.

Do not replace an accessible table with an inaccessible virtualized surface without preserving expected semantics and keyboard behavior.

### Async Data and Requests

- Deduplicate equivalent in-flight requests.
- Cancel obsolete requests with `AbortController`.
- Avoid request waterfalls when calls can safely run in parallel.
- Do not fetch hidden or unvisited route data without a reason.
- Cache stable data at an appropriate layer.
- Define stale and invalidation behavior explicitly.
- Prevent stale responses from overwriting newer state.
- Avoid loading the same data independently in many components.

Example:

```ts
let activeController: AbortController | undefined

export async function loadSearchResults(query: string): Promise<unknown> {
  activeController?.abort()
  activeController = new AbortController()

  const response = await fetch(`/api/search?q=${encodeURIComponent(query)}`, {
    signal: activeController.signal,
  })

  if (!response.ok) {
    throw new Error(`Search request failed with ${response.status}`)
  }

  return response.json()
}
```

## Bundling and Code Splitting

### Default Approach

Use dynamic imports as natural split points. Analyze the production bundle before introducing manual chunk rules.

Check for:

- Large libraries imported for one small function.
- Duplicate library versions.
- Barrel imports that prevent effective tree shaking.
- Entire icon, locale, date, chart, or editor packages imported unnecessarily.
- Development-only code in production.
- Source maps or debug assets shipped unintentionally.
- Polyfills that are not required by supported targets.
- Worker code accidentally included in the main bundle.

### Vite

Do not paste Webpack configuration into a Vite project.

Before editing Vite chunk configuration:

1. Check the installed Vite version.
2. Read the local configuration and migration context.
3. Confirm the correct build-option API for that version.
4. Generate and inspect a bundle visualization.
5. Add manual chunking only for a demonstrated reason.

Manual chunking can worsen caching, request overhead, execution ordering, and initialization. A single generic `vendor` chunk is not automatically optimal.

### Webpack

Only apply Webpack-specific optimization when the project actually uses Webpack.

Example starting point:

```js
module.exports = {
  optimization: {
    splitChunks: {
      chunks: 'all',
    },
  },
}
```

Do not force all dependencies into one named vendor chunk without measuring its effect on caching and load order.

### Dependency Strategy

Before replacing a dependency:

- Confirm its contribution to the production bundle.
- Check whether imports can be narrowed.
- Check whether the feature can be dynamically loaded.
- Consider maintenance, browser compatibility, correctness, and accessibility.
- Avoid large rewrites for a small theoretical saving.

## Images

### Responsive Image Example

```vue
<template>
  <picture>
    <source
      srcset="
        /images/example-400.avif 400w,
        /images/example-800.avif 800w,
        /images/example-1200.avif 1200w
      "
      type="image/avif"
    >

    <source
      srcset="
        /images/example-400.webp 400w,
        /images/example-800.webp 800w,
        /images/example-1200.webp 1200w
      "
      type="image/webp"
    >

    <img
      src="/images/example-800.jpg"
      srcset="
        /images/example-400.jpg 400w,
        /images/example-800.jpg 800w,
        /images/example-1200.jpg 1200w
      "
      sizes="(max-width: 600px) 100vw, 50vw"
      width="800"
      height="600"
      loading="lazy"
      decoding="async"
      alt="Description"
    >
  </picture>
</template>
```

Rules:

- Set intrinsic `width` and `height`, or reserve space with `aspect-ratio`.
- Use responsive sources.
- Compress at an appropriate quality.
- Prefer AVIF or WebP with a suitable fallback where needed.
- Lazy-load below-the-fold images.
- Do not lazy-load the likely LCP image.
- Give the LCP image high discovery priority when justified.
- Avoid large CSS background images for important content when an image element is more appropriate.
- Preserve meaningful alt text.

For a likely LCP image:

```html
<img
  src="/images/hero.webp"
  width="1600"
  height="900"
  fetchpriority="high"
  decoding="async"
  alt="..."
>
```

Do not add `fetchpriority="high"` to many resources.

## Fonts

- Prefer a small number of font files, weights, and styles.
- Subset fonts where licensing and tooling permit.
- Preload only critical fonts.
- Use an appropriate `font-display` strategy.
- Match fallback font metrics to reduce layout shifts.
- Avoid loading icon fonts when a small SVG set is sufficient.
- Check whether a variable font is actually smaller for the used range.

Do not preload every font.

## CSS and Rendering

- Remove genuinely unused CSS through the project’s supported build pipeline.
- Avoid enormous global stylesheets for route-specific UI.
- Prefer transform and opacity for frequent visual animations.
- Avoid layout-triggering animation of width, height, top, or left when a composited alternative is appropriate.
- Reduce expensive blur, filter, shadow, and backdrop effects in large moving surfaces.
- Reserve space for async content.
- Batch DOM reads and writes in custom imperative code.
- Use `content-visibility` only after checking browser support and accessibility behavior.
- Do not trade maintainability for microscopic selector optimizations.

## Third-Party Code

Inventory analytics, telemetry, chat widgets, syntax highlighters, editors, maps, and embedded media.

For each third-party dependency:

- Measure transfer size.
- Measure main-thread cost.
- Check when it executes.
- Delay it until consent or interaction where appropriate.
- Load it only on relevant routes.
- Use a facade for expensive embeds.
- Remove duplicate functionality.
- Verify legal, privacy, and product requirements before changing it.

Third-party scripts are often the dominant cost. Treat them as application code.

## Caching

### Recommended HTTP Cache Policy

For content-hashed immutable build assets:

```http
Cache-Control: public, max-age=31536000, immutable
```

For HTML entry documents:

```http
Cache-Control: no-cache
```

For APIs, choose an explicit policy based on data semantics. Do not apply long-lived caching to personalized, sensitive, or rapidly changing responses without a correct invalidation design.

### Service Workers

Do not add a service worker solely because the application is slow.

Use a service worker when offline behavior, installability, resilient navigation, or controlled runtime caching is a product requirement.

Prefer Workbox or the framework’s established PWA integration over a hand-written cache-everything service worker.

A production service worker must address:

- Versioning.
- Old cache cleanup.
- Navigation requests.
- Hashed asset precaching.
- Runtime cache boundaries.
- Cache expiration.
- Opaque responses.
- Failed requests.
- Update activation.
- User-visible update behavior.
- Authentication and private responses.
- Development disablement.
- Rollback.

Never cache all requests indiscriminately. Never cache mutation requests.

## Compression and Delivery

Compression is a deployment concern. Do not edit Nginx configuration for an Electron or Tauri package unless that application also has a relevant web deployment.

Example Nginx gzip baseline:

```nginx
gzip on;
gzip_vary on;
gzip_min_length 1024;
gzip_comp_level 6;
gzip_types
  text/plain
  text/css
  text/xml
  application/json
  application/javascript
  application/xml
  application/rss+xml
  image/svg+xml;
```

Prefer Brotli when the server or CDN supports it correctly, while retaining gzip fallback where appropriate.

Also inspect:

- HTTP/2 or HTTP/3 support.
- CDN behavior.
- Cache headers.
- origin latency.
- TLS and redirects.
- image transformation.
- compression duplication.
- server timing.
- reverse-proxy buffering.

Do not compress already-compressed formats such as JPEG, PNG, AVIF, WebP, ZIP, or video merely to satisfy a checklist.

## Web Vitals Monitoring with TypeScript

Prefer the `web-vitals` package rather than custom metric approximations.

```ts
import {
  onCLS,
  onINP,
  onLCP,
  type Metric,
} from 'web-vitals'

interface WebVitalPayload {
  metric: Metric['name']
  value: number
  rating: Metric['rating']
  id: string
  navigationType: Metric['navigationType']
  timestamp: number
}

function reportMetric(metric: Metric): void {
  const payload: WebVitalPayload = {
    metric: metric.name,
    value: metric.value,
    rating: metric.rating,
    id: metric.id,
    navigationType: metric.navigationType,
    timestamp: Date.now(),
  }

  const body = JSON.stringify(payload)

  if (navigator.sendBeacon) {
    navigator.sendBeacon('/api/analytics', body)
    return
  }

  void fetch('/api/analytics', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body,
    keepalive: true,
  })
}

export function initializeWebVitals(): void {
  onCLS(reportMetric)
  onINP(reportMetric)
  onLCP(reportMetric)
}
```

Register monitoring once per page load, normally from the application entry point.

Before adding telemetry:

- Check existing analytics.
- Avoid duplicate reporting.
- Respect consent and privacy requirements.
- Sample appropriately.
- Include release, route, device class, and environment only when permitted.
- Avoid sending personal or sensitive data.
- Verify that the endpoint accepts beacon requests and the chosen content type.

## Electron and Tauri

Core Web Vitals may be useful diagnostically but are not always the primary product target.

Prioritize:

- Renderer startup time.
- Time to interactive UI.
- Main-thread long tasks.
- IPC frequency and payload size.
- Repeated serialization.
- Window and route initialization.
- Editor, terminal, chart, or file-tree mounting cost.
- Memory retained across tabs or workspaces.
- Background polling.
- Hidden-window work.
- Native bridge bottlenecks.
- Cold versus warm startup.

Do not add browser service-worker caching to a desktop renderer without a clear runtime requirement.

## Nuxt and SSR

Inspect whether the cost occurs during:

- Server rendering.
- Data fetching.
- Hydration.
- Client navigation.
- Payload transfer.
- Image processing.
- Edge or origin execution.

Prefer framework-native facilities for:

- Route-level splitting.
- Server data caching.
- image optimization.
- payload extraction.
- preload and prefetch.
- island or partial hydration patterns when supported.

Check for hydration mismatch and duplicated server/client fetching after every SSR optimization.

## Common Diagnosis Map

| Symptom | Investigate first |
|---|---|
| Slow first load | TTFB, LCP discovery, JS/CSS size, images, fonts |
| Good load, slow clicks | INP, long tasks, component updates, event handlers |
| Page jumps | Missing dimensions, async insertion, fonts, dynamic banners |
| Large JS bundle | Route imports, heavy dependencies, duplicates, locales |
| Slow route navigation | Route chunk, data waterfall, expensive mount |
| Typing lag | Reactive fan-out, synchronous validation, large DOM |
| Slow large table | Virtualization, row watchers, unstable keys, layout |
| High idle CPU | polling, animations, observers, runaway watchers |
| Rising memory | listeners, timers, closures, cached components, workers |
| Stale production UI | service worker, CDN caching, HTML cache policy |
| Fast locally, slow remotely | origin, CDN, compression, cache, device CPU |
| Poor mobile only | CPU cost, memory, image sizing, third parties |

## Performance Budgets

Use project-specific budgets when they exist. Otherwise propose budgets based on the application rather than pretending one universal threshold fits all products.

Possible budgets:

- Maximum initial JavaScript transfer.
- Maximum route chunk size.
- Maximum LCP resource size.
- Maximum third-party script cost.
- Maximum long-task duration or count.
- Maximum DOM node count for a view.
- Maximum API request count for a user flow.
- Maximum cold-start time.
- Core Web Vitals pass rate.

A budget is useful only if it is measured in CI or release monitoring.

## Safe Optimization Order

Prefer this sequence:

1. Fix correctness issues, request duplication, and pathological loops.
2. Improve LCP resource discovery and image sizing.
3. Remove unnecessary initial JavaScript.
4. Split large routes or optional features.
5. Reduce expensive rendering and reactive invalidation.
6. Virtualize genuinely large collections.
7. Fix layout instability.
8. Delay or remove third-party work.
9. Configure caching and compression.
10. Add monitoring and enforce budgets.

The order may change when profiling identifies a different dominant bottleneck.

## Anti-Patterns

Do not:

- Optimize without a baseline.
- Report Lighthouse development-server results as production truth.
- Replace measured field data with one synthetic run.
- Add lazy loading to the LCP image.
- Split every component.
- Create a giant vendor chunk by default.
- Add a cache-everything service worker.
- add memoization everywhere.
- Debounce essential immediate feedback without product approval.
- Remove accessibility semantics to gain speed.
- Hide a slow operation behind a spinner and call it optimized.
- Move work to a worker without measuring serialization overhead.
- Add preload or high priority to many resources.
- Introduce a dependency solely to save a trivial amount of code.
- Change framework or bundler configuration without checking its installed version.
- confuse smaller transfer size with lower execution cost.
- Ignore mobile CPU and memory.
- Ignore stale cache and upgrade behavior.

## Expected Output from the Agent

When asked to investigate performance, produce:

### Findings

- Environment and build stack.
- Reproduction scenario.
- Baseline measurements.
- Dominant bottleneck.
- Evidence with relevant files, chunks, requests, components, or traces.

### Changes

For every change state:

- What changed.
- Why it targets the measured bottleneck.
- Files modified.
- Expected effect.
- Risks or trade-offs.

### Validation

Include:

- Production build result.
- Relevant test result.
- Before-and-after measurements under comparable conditions.
- Functional or visual checks.
- Remaining bottlenecks.

### Next Actions

List only actions supported by current evidence. Separate required follow-up from optional experimentation.

## Optimization Checklist

### Discovery

- [ ] Framework, runtime, bundler, and versions identified.
- [ ] Production build command identified.
- [ ] Slow route or user flow reproduced.
- [ ] Baseline recorded.
- [ ] Dominant bottleneck classified.

### Loading

- [ ] LCP resource is discovered early.
- [ ] LCP image is not lazy-loaded.
- [ ] Route splitting matches meaningful boundaries.
- [ ] Optional heavy components load on demand.
- [ ] Third-party code is limited to relevant routes or interactions.
- [ ] Fonts and critical styles are intentionally loaded.

### Rendering

- [ ] Expensive component updates are profiled.
- [ ] Large lists are paginated or virtualized where appropriate.
- [ ] Reactive dependencies are narrow.
- [ ] Timers, listeners, observers, and subscriptions are cleaned up.
- [ ] Hidden expensive trees are not mounted unnecessarily.
- [ ] Layout space is reserved for async content.

### Network and Delivery

- [ ] Requests are deduplicated and obsolete requests are cancelled.
- [ ] Avoidable waterfalls are removed.
- [ ] Hashed assets have long-lived immutable caching.
- [ ] HTML update behavior is correct.
- [ ] Compression is enabled at the appropriate delivery layer.
- [ ] Service-worker behavior is intentional and tested.

### Validation

- [ ] Production build succeeds.
- [ ] Tests pass.
- [ ] Baseline scenario is remeasured.
- [ ] Behavior and accessibility are preserved.
- [ ] Improvement and trade-offs are documented.

## Reference Files

Read these only when relevant:

- `references/vue-vite-patterns.md`
- `references/measurement-and-monitoring.md`
- `references/caching-pwa-delivery.md`
