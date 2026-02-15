---
applyTo: 'apps/desktop-app/**'
---

# Remix v2 Best Practices

## File-Based Routing

### Route File Naming Conventions

- [ ] Use `_index.tsx` for index routes (e.g., `/` route)
- [ ] Use dot notation for nested URLs: `concerts.trending.tsx` → `/concerts/trending`
- [ ] Use `$` prefix for dynamic segments: `invoices.$id.tsx` → `/invoices/:id`
- [ ] Use `_leading` underscore for pathless layout routes (no URL segment)
- [ ] Use `trailing_` underscore to opt out of parent layout nesting
- [ ] Place related code in route folders with `route.tsx` as the route module

### Route Structure Examples

```
✅ Good:
app/routes/_index.tsx                    → /
app/routes/integrations.tsx              → /integrations
app/routes/integrations.$id.tsx          → /integrations/:id
app/routes/integrations.$id.sync.tsx     → /integrations/:id/sync
app/routes/_auth.login.tsx               → /login (with _auth layout)
app/routes/_auth.register.tsx            → /register (with _auth layout)

❌ Avoid:
app/routes/index.tsx                     (use _index.tsx instead)
app/routes/integrations/[id].tsx         (use $id instead of [id])
```

### Route Folder Organization

```
✅ Recommended for scale:
app/routes/integrations.$id/
  ├── route.tsx              # Route module with loader, action, component
  ├── integration-card.tsx   # Components used only in this route
  ├── sync-status.tsx
  └── utils.server.ts        # Server-only utilities

❌ Don't:
app/routes/integrations.$id.tsx          # Files in folder won't become routes
app/routes/integrations.$id/card.tsx     # Only route.tsx is the route
```

## Data Loading (Loaders)

### Loader Best Practices

- [ ] Export `loader` function from route modules for server-side data loading
- [ ] Use `LoaderFunctionArgs` type for loader parameters
- [ ] Always return `json()` helper or `Response` instances
- [ ] Use `useLoaderData<typeof loader>()` for type-safe data access
- [ ] Access route params via `params` argument
- [ ] Read request headers and search params from `request` argument
- [ ] Throw responses for redirects or error states

```typescript
✅ Good:
import { json, type LoaderFunctionArgs } from "@remix-run/node";
import { useLoaderData } from "@remix-run/react";
import { db } from "~/lib/db.server";

export async function loader({ params, request }: LoaderFunctionArgs) {
  // Read search params
  const url = new URL(request.url);
  const filter = url.searchParams.get("filter");
  
  // Access route params
  const integrationId = params.id;
  
  // Fetch data
  const integration = await db.query.integrations.findFirst({
    where: eq(integrations.id, integrationId),
  });
  
  // Throw 404 if not found
  if (!integration) {
    throw new Response("Not Found", { status: 404 });
  }
  
  // Return JSON response
  return json({ integration, filter });
}

export default function Integration() {
  // Type-safe data access
  const { integration, filter } = useLoaderData<typeof loader>();
  
  return <div>{integration.name}</div>;
}

❌ Avoid:
export const loader = async ({ params }) => {
  // Missing types
  const data = await fetch(...);
  return data; // Should return json() or Response
};
```

### Loader Security

- [ ] Loaders only run on the server
- [ ] Database code in loaders is tree-shaken from client bundle
- [ ] Use `.server.ts` suffix for server-only modules
- [ ] Never expose sensitive data in loader return values (they go to client)
- [ ] Treat loaders like public API endpoints

```typescript
✅ Good:
// app/lib/supabase.server.ts - Won't be in browser bundle
import { createSupabaseServerClient } from '@supabase/ssr';
export const createClient = (request) => {...};

// app/routes/api.users.ts
export async function loader({ request }) {
  const { supabase } = await requireAuth(request);
  const { data: users } = await supabase
    .from('users')
    .select('id, name, email'); // Only select needed columns
  return json(users);
}

❌ Avoid:
export async function loader({ request }) {
  const { supabase } = await requireAuth(request);
  const { data: users } = await supabase
    .from('users')
    .select('*'); // May include sensitive fields
  return json(users);
}
```

## Data Mutations (Actions)

### Action Best Practices

- [ ] Export `action` function from route modules for mutations
- [ ] Actions handle non-GET requests (POST, PUT, DELETE, PATCH)
- [ ] Use `ActionFunctionArgs` type for action parameters
- [ ] Read form data via `await request.formData()`
- [ ] Return `redirect()` after successful mutations
- [ ] Return `json()` for validation errors
- [ ] Co-locate actions with loaders in the same route file

```typescript
✅ Good:
import { json, redirect, type ActionFunctionArgs } from "@remix-run/node";
import { Form } from "@remix-run/react";
import { db } from "~/lib/db.server";

export async function action({ request, params }: ActionFunctionArgs) {
  const formData = await request.formData();
  const name = formData.get("name");
  const amount = formData.get("amount");
  
  // Validation
  if (!name || !amount) {
    return json(
      { errors: { name: "Name is required", amount: "Amount is required" } },
      { status: 400 }
    );
  }
  
  // Mutation
  const budget = await db.insert(budgets).values({
    name: String(name),
    amount: Number(amount),
    categoryId: params.categoryId,
  });
  
  // Redirect after success
  return redirect(`/budgets/${budget.id}`);
}

export default function NewBudget() {
  return (
    <Form method="post">
      <input type="text" name="name" />
      <input type="number" name="amount" />
      <button type="submit">Create Budget</button>
    </Form>
  );
}

❌ Avoid:
export async function action({ request }: ActionFunctionArgs) {
  const data = await request.json(); // Use formData() instead
  // ... mutation ...
  return json({ success: true }); // Should redirect after mutation
}
```

### Form Handling

- [ ] Use `<Form>` component from `@remix-run/react` (not `<form>`)
- [ ] Forms without `action` prop post to their own route
- [ ] Use `method="post"` for mutations
- [ ] Use `?index` to post to index routes explicitly
- [ ] Multiple forms can exist on same page with different actions

```typescript
✅ Good:
import { Form } from "@remix-run/react";

// Posts to current route's action
<Form method="post">
  <input name="title" />
  <button type="submit">Create</button>
</Form>

// Posts to specific route's action
<Form action="/integrations/sync" method="post">
  <button type="submit">Sync All</button>
</Form>

// Posts to index route explicitly
<Form action="/budgets?index" method="post">
  <button type="submit">Create Budget</button>
</Form>

❌ Avoid:
<form method="post"> {/* Use Form component */}
  <button onClick={handleClick}> {/* Use form submission */}
</form>
```

## Error Handling

### Error Boundaries

- [ ] Export `ErrorBoundary` component to handle route errors
- [ ] Use `useRouteError()` to access error details
- [ ] Use `isRouteErrorResponse()` to check for thrown responses
- [ ] Throw responses from loaders/actions to trigger error boundaries

```typescript
✅ Good:
import { useRouteError, isRouteErrorResponse } from "@remix-run/react";

export async function loader({ params }: LoaderFunctionArgs) {
  const data = await db.query.findFirst({ where: { id: params.id } });
  
  if (!data) {
    throw new Response("Not Found", { status: 404 });
  }
  
  return json(data);
}

export function ErrorBoundary() {
  const error = useRouteError();
  
  if (isRouteErrorResponse(error)) {
    if (error.status === 404) {
      return <div>Resource not found</div>;
    }
    if (error.status === 401) {
      return <div>Unauthorized: {error.data}</div>;
    }
  }
  
  return <div>Something went wrong</div>;
}

❌ Avoid:
export async function loader({ params }: LoaderFunctionArgs) {
  try {
    const data = await db.query.findFirst(...);
    return json(data || null); // Return null instead of throwing
  } catch (error) {
    return json({ error: error.message }); // Handle errors in loader
  }
}
```

## Resource Routes (API Routes)

### API Route Best Practices

- [ ] Resource routes export only loader/action, no default component
- [ ] Use for API endpoints, webhooks, file downloads
- [ ] Return any Response (JSON, XML, PDF, etc.)
- [ ] Can be in any route file structure

```typescript
✅ Good - API endpoint:
// app/routes/api.integrations.$id.sync.ts
import { json, type ActionFunctionArgs } from "@remix-run/node";
import { IntegrationService } from "~/services/integrations";

export async function action({ params }: ActionFunctionArgs) {
  const service = new IntegrationService();
  const result = await service.syncIntegration(params.id);
  
  return json(result);
}

// No default export = resource route (API only)

✅ Good - Webhook:
// app/routes/webhooks.stripe.ts
import { type ActionFunctionArgs } from "@remix-run/node";

export async function action({ request }: ActionFunctionArgs) {
  const signature = request.headers.get("stripe-signature");
  const payload = await request.text();
  
  // Verify and process webhook
  // ...
  
  return new Response("OK", { status: 200 });
}

❌ Avoid:
// Don't mix UI component with API route
export async function action({ request }: ActionFunctionArgs) {
  // ... API logic ...
  return json({ success: true });
}

export default function Component() {
  return <div>This shouldn't exist for API routes</div>;
}
```

## File Organization

### Project Structure

```
✅ Recommended:
app/
├── routes/                      # All routes
│   ├── _index.tsx              # Homepage
│   ├── integrations/           # Route folder
│   │   ├── route.tsx           # /integrations
│   │   ├── integration-card.tsx
│   │   └── utils.ts
│   ├── integrations.$id/       # Route folder
│   │   ├── route.tsx           # /integrations/:id
│   │   └── sync-button.tsx
│   └── api.sync.ts             # API route
├── components/                  # Shared components
│   ├── ui/                     # shadcn components
│   └── layout/
├── lib/                        # Shared utilities
│   ├── db.server.ts
│   └── utils.ts
├── services/                   # Business logic
│   ├── integrations/
│   ├── budgets/
│   └── transactions/
└── db/                         # Database schema
    └── schema.ts
```

### Server-Only Code

- [ ] Use `.server.ts` suffix for server-only files
- [ ] Import server code only in loaders/actions
- [ ] Vite will error if server code is imported in client code

```typescript
✅ Good:
// app/lib/supabase.server.ts
export const createSupabaseServerClient = (...);

// app/routes/budgets.tsx
import { createSupabaseServerClient } from "~/lib/supabase.server"; // ✅ Only in loader

export async function loader({ request }) {
  const { supabase } = await requireAuth(request);
  const { data } = await supabase.from('budgets').select();
  return json(data);
}

❌ Avoid:
// app/components/budget-list.tsx
import { createSupabaseServerClient } from "~/lib/supabase.server"; // ❌ Client component

export function BudgetList() {
  // Can't use Supabase server client here!
}
```

## Performance

### Optimization Best Practices

- [ ] Use `defer()` for slow data to stream responses
- [ ] Prefetch data with `<Link prefetch="intent">`
- [ ] Implement optimistic UI with `useFetcher()`
- [ ] Cache loader responses with appropriate headers
- [ ] Use React.lazy() for code splitting heavy components

```typescript
✅ Good - Streaming slow data:
import { defer, type LoaderFunctionArgs } from "@remix-run/node";
import { Await, useLoaderData } from "@remix-run/react";
import { Suspense } from "react";

export async function loader() {
  // Fast data loads immediately
  const quickData = await db.query.quickStuff.findMany();
  
  // Slow data streams later
  const slowDataPromise = expensiveApiCall();
  
  return defer({
    quickData,
    slowData: slowDataPromise, // Don't await!
  });
}

export default function Component() {
  const { quickData, slowData } = useLoaderData<typeof loader>();
  
  return (
    <div>
      <div>{quickData}</div>
      <Suspense fallback={<div>Loading...</div>}>
        <Await resolve={slowData}>
          {(data) => <div>{data}</div>}
        </Await>
      </Suspense>
    </div>
  );
}
```

## Common Pitfalls to Avoid

❌ **Don't use React Router v6 conventions in Remix v2**
- No `useParams()` in loaders (use function argument)
- No `useSearchParams()` in loaders (use `request.url`)

❌ **Don't mix client and server code**
- Server-only code should use `.server.ts` suffix
- Don't import database clients in components

❌ **Don't forget to return from loaders/actions**
- Always return `json()`, `redirect()`, or `Response`
- Type errors if you forget

❌ **Don't use nested folders for routes without `route.tsx`**
- `routes/foo/bar.tsx` won't work
- Use `routes/foo.bar.tsx` or `routes/foo.bar/route.tsx`

❌ **Don't ignore form progressive enhancement**
- Use `<Form>` not `<form>` for automatic enhancement
- Forms work without JavaScript

## Migration from Older Remix Versions

### V1 → V2 Breaking Changes

- [ ] Update to flat file route convention (or use compat flag)
- [ ] Use `@remix-run/node` instead of `@remix-run/server-runtime`
- [ ] Update `json()` imports to `@remix-run/node`
- [ ] Update error boundary exports (single `ErrorBoundary` not separate CatchBoundary)
- [ ] Migrate to Vite from Remix App Server if needed
