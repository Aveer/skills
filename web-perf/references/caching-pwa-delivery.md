# Caching, PWA, and Delivery

## Asset Caching

Content-hashed assets can usually be cached for a long time:

```http
Cache-Control: public, max-age=31536000, immutable
```

The HTML entry document normally needs revalidation:

```http
Cache-Control: no-cache
```

This allows new deployments to reference new hashed assets without serving stale HTML indefinitely.

## API Caching

Choose policy from data semantics:

- private versus public
- user-specific versus shared
- immutable versus frequently updated
- safe versus unsafe to serve stale
- invalidation source
- offline expectations
- authorization boundaries

Possible mechanisms:

- browser HTTP cache
- CDN cache
- server-side cache
- application query cache
- IndexedDB
- service worker runtime cache

Do not stack multiple caches without defining ownership and invalidation.

## Service-Worker Decision

Add a service worker only when one or more are required:

- offline shell
- offline content
- installable PWA
- resilient navigation
- controlled background synchronization
- deliberate runtime caching

Do not add one as a generic speed fix.

## Runtime Strategy Examples

Choose per resource class:

- Hashed static assets: precache or cache-first.
- HTML navigation: network-first or stale-while-revalidate with carefully designed update behavior.
- Stable public API data: stale-while-revalidate with bounded expiration.
- Frequently changing API data: network-first with a safe fallback.
- Personalized or sensitive API data: normally network-only unless explicitly designed otherwise.
- Mutations: network-only.

## Update Safety

Test:

- first install
- normal update
- multiple tabs
- old tab after deployment
- offline startup
- failed deployment
- cache cleanup
- authentication changes
- logout
- rollback
- version mismatch between HTML and assets

Expose an update prompt when immediate activation could disrupt active work.

## Compression

Enable compression at the server or CDN.

Good candidates:

- HTML
- CSS
- JavaScript
- JSON
- XML
- SVG
- plain text

Usually poor candidates:

- JPEG
- PNG
- WebP
- AVIF
- ZIP
- gzip archives
- video
- audio

## Nginx Example

```nginx
gzip on;
gzip_vary on;
gzip_min_length 1024;
gzip_comp_level 6;
gzip_types
  text/plain
  text/css
  application/json
  application/javascript
  application/xml
  image/svg+xml;
```

When using precompressed assets, confirm that the deployment correctly serves matching content encoding and varies caches by encoding.

## CDN Checklist

- Is the CDN actually caching?
- Are cache keys correct?
- Are cookies unnecessarily bypassing cache?
- Is query-string behavior intentional?
- Are compression and image transformations active?
- Is HTML invalidation reliable?
- Are regional origin latencies acceptable?
- Are redirects occurring before the CDN?
- Are error responses cached accidentally?
