# Measurement and Monitoring

## Comparable Test Conditions

Before comparing results, keep constant:

- production build
- route and user action
- viewport
- browser version
- CPU throttling
- network throttling
- cache state
- login state
- test data volume
- extension state
- machine load

Run multiple samples. Report the median and notable variance when practical.

## Browser Tools

### Network

Inspect:

- request waterfalls
- redirects
- blocking time
- connection reuse
- transfer versus decoded size
- cache status
- resource priority
- duplicate requests
- late-discovered LCP resource
- API serialization size

### Performance Trace

Inspect:

- long tasks
- script evaluation
- style recalculation
- layout
- paint
- event handlers
- forced synchronous layout
- repeated component updates
- excessive timers
- garbage collection

### Coverage

Coverage can reveal unused JavaScript and CSS on one tested route. It does not prove that code is unused across the whole application.

### Memory

Use heap snapshots and allocation timelines to find retained:

- components
- event listeners
- closures
- detached DOM nodes
- workers
- editor instances
- cached responses
- timers and observers

## Real-User Monitoring

Prefer the official `web-vitals` package for LCP, INP, and CLS.

Useful dimensions, subject to privacy and consent:

- application release
- route template
- browser family
- device class
- connection class
- navigation type
- authenticated versus anonymous aggregate
- experiment identifier

Do not send full URLs containing identifiers, search terms, document names, or other sensitive data.

## Analytics Payload

```ts
import type { Metric } from 'web-vitals'

export interface PerformanceMetricPayload {
  name: Metric['name']
  value: number
  rating: Metric['rating']
  id: string
  route: string
  release?: string
  navigationType: Metric['navigationType']
  recordedAt: string
}
```

Normalize dynamic routes before reporting, for example `/projects/:id` rather than a real project identifier.

## Regression Reporting Template

```text
Scenario:
Build:
Environment:
Cache state:

Before:
- LCP:
- INP or TBT:
- CLS:
- Initial JS:
- Requests:
- Long tasks:

After:
- LCP:
- INP or TBT:
- CLS:
- Initial JS:
- Requests:
- Long tasks:

Behavior checks:
Trade-offs:
Remaining bottleneck:
```

## Lighthouse

Use Lighthouse as a diagnostic laboratory tool, not the sole source of truth.

- Test a production-like build.
- Repeat runs.
- Inspect opportunities and trace evidence rather than optimizing only the score.
- Compare equivalent environments.
- Prefer field data for real-user Core Web Vitals when available.

## CI Budgets

Possible CI checks:

- bundle-size diff
- maximum entry chunk size
- route chunk budgets
- Lighthouse CI
- maximum number of requests
- asset-size limits
- performance test for a critical interaction

Avoid noisy gates that developers learn to ignore.
