# Vue Router Typing

Type-safe routing patterns for Vue Router.

> Examples apply only to the installed Router version and existing routing ownership. Preserve explicit route registration and manifest-driven routing where required. Nuxt-specific conventions apply only to actual Nuxt projects.

## Route Meta Types

Extend `RouteMeta` for typed route.meta:

```ts
// router/types.ts
import 'vue-router'

declare module 'vue-router' {
  interface RouteMeta {
    requiresAuth?: boolean
    title?: string
    roles?: ('admin' | 'user')[]
  }
}
```

**Usage:**

```ts
const route = useRoute()
route.meta.requiresAuth // boolean | undefined (typed!)
route.meta.title // string | undefined
```

## Typed Route Params

Use the project's existing typed route definitions and generated types when
available. Consult the installed Vue Router version's documented mechanisms
for named routes and parameter types. File-based generation or an
`unplugin-vue-router` integration is only relevant where already adopted or
explicitly under evaluation; this reference does not authorize adding it,
replacing explicit routes, or changing route ownership. Validate normalized
params at the consuming boundary when the route permits optional or repeated
segments.

## Scroll Behavior Types

Type scroll behavior function:

```ts
import type { RouterScrollBehavior } from 'vue-router'

const scrollBehavior: RouterScrollBehavior = (to, from, savedPosition) => {
  if (savedPosition) return savedPosition
  if (to.hash) return { el: to.hash, behavior: 'smooth' }
  return { top: 0 }
}

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior,
})
```

## Dynamic Route Params

Handle union types for dynamic segments:

```ts
// routes/[type].vue where type can be 'posts' | 'users' | 'comments'
const route = useRoute()

// Narrow params type
type ContentType = 'posts' | 'users' | 'comments'

const type = route.params.type as ContentType

// Or use route guards
if (route.params.type === 'posts') {
  // TypeScript knows type is 'posts'
}
```

## Navigation Guards Types

Type navigation guards:

```ts
import type { NavigationGuardWithThis, RouteLocationNormalized } from 'vue-router'

const authGuard: NavigationGuardWithThis<undefined> = (to, from) => {
  if (to.meta.requiresAuth && !isAuthenticated()) {
    return { name: 'login', query: { redirect: to.fullPath } }
  }
}

router.beforeEach(authGuard)
```

**Per-route guards:**

```ts
const routes = [
  {
    path: '/admin',
    component: AdminPage,
    beforeEnter: (to: RouteLocationNormalized) => {
      if (!hasAdminRole()) return { name: 'forbidden' }
    },
  },
]
```

## RouteLocation Types

Common route types:

```ts
import type {
  RouteLocationNormalized,     // Resolved route (after navigation)
  RouteLocationNormalizedLoaded, // Current route (from useRoute)
  RouteLocationRaw,            // Input to router.push()
  RouteRecordRaw,              // Route config definition
} from 'vue-router'
```

## Common Mistakes

**Not extending RouteMeta module:**

```ts
// ❌ Loses type info
route.meta.customField // any

// ✅ Extend the interface
declare module 'vue-router' {
  interface RouteMeta { customField: string }
}
```

**Assuming params are always strings:**

```ts
// Catch-all routes have string[] params
const route = useRoute()

// ❌ May be string[]
const id = route.params.id

// ✅ Handle both cases
const id = Array.isArray(route.params.id)
  ? route.params.id[0]
  : route.params.id
```
