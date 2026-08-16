# Vue and Vite Performance Patterns

Use this reference after confirming that the application uses Vue 3 and Vite.

## Route Splitting

```ts
const routes = [
  {
    path: '/workspace',
    component: () => import('@/pages/WorkspacePage.vue'),
  },
]
```

Dynamic imports are normally enough to create route chunks.

## Conditional Heavy Component

```vue
<script setup lang="ts">
import { defineAsyncComponent, ref } from 'vue'

const isOpen = ref(false)

const MonacoEditor = defineAsyncComponent(
  () => import('@/components/MonacoEditor.vue'),
)
</script>

<template>
  <button type="button" @click="isOpen = true">
    Open editor
  </button>

  <MonacoEditor v-if="isOpen" />
</template>
```

This avoids downloading and mounting the editor until required.

## Narrow Derived State

Avoid repeatedly filtering large arrays directly in templates.

```ts
import { computed, ref } from 'vue'

interface Item {
  id: string
  title: string
  visible: boolean
}

const items = ref<Item[]>([])

const visibleItems = computed(() =>
  items.value.filter((item) => item.visible),
)
```

## Avoid Accidental Deep Reactivity

For large third-party objects:

```ts
import { markRaw, shallowRef } from 'vue'

interface EditorInstance {
  dispose(): void
}

const editor = shallowRef<EditorInstance>()

function setEditor(instance: EditorInstance): void {
  editor.value = markRaw(instance)
}
```

Use only when nested properties do not need Vue reactivity.

## Watcher Cleanup

```ts
import { onBeforeUnmount, watch } from 'vue'

const stop = watch(
  () => route.params.id,
  (id) => {
    void loadItem(String(id))
  },
  { immediate: true },
)

onBeforeUnmount(() => {
  stop()
})
```

Vue stops component-scoped synchronous watchers automatically, but explicit cleanup can clarify ownership. Always clean up external resources created by the watcher.

## Abort Obsolete Fetches

```ts
import { onBeforeUnmount, watch } from 'vue'

let controller: AbortController | undefined

const stop = watch(
  searchText,
  async (value) => {
    controller?.abort()
    controller = new AbortController()

    try {
      results.value = await search(value, controller.signal)
    } catch (error) {
      if (!(error instanceof DOMException && error.name === 'AbortError')) {
        throw error
      }
    }
  },
)

onBeforeUnmount(() => {
  controller?.abort()
  stop()
})
```

## Expensive Lists

Investigate:

- Number of mounted rows.
- DOM node count.
- Row component update frequency.
- Stable keys.
- deep watchers.
- resizing observers.
- tooltip and menu instances per row.
- hidden expanded content.
- synchronous sorting and filtering.

Use a virtual scroller only after checking keyboard behavior, focus restoration, screen-reader behavior, variable row heights, and testability.

## Vite Bundle Analysis

Use a project-compatible visualization plugin or Vite’s current build output. Do not add a bundle analyzer permanently unless the project needs it.

Inspect:

- Initial entry chunk.
- Route chunks.
- duplicated dependencies.
- editor, chart, syntax-highlighting, date, locale, and icon packages.
- source maps.
- worker chunks.
- CSS per route.

## Manual Chunks

Do not paste a generic `manualChunks` configuration without checking the installed Vite version and its current bundler API.

Introduce manual grouping only when it produces a verified improvement such as:

- A stable, independently cached large dependency.
- Isolation of a feature used by a small subset of routes.
- Removal of an unwanted dependency cycle or initialization issue.
- Predictable chunking required by deployment constraints.

Verify cold load, warm navigation, caching, and execution order afterward.

## Component Profiling Questions

- Which prop or state change causes this component to update?
- Does the update invalidate children that did not change?
- Is a new object, array, or callback created on every parent render?
- Is a computed property recalculating because its dependencies are too broad?
- Is a global store update invalidating the whole page?
- Does a hidden panel remain mounted?
- Does one user action trigger repeated layout reads and writes?
- Is an expensive library initialized more than once?
