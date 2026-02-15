---
applyTo: './'
---

## App Structure

Use this Next.js App Router structure:
```
apps/client-server/
├── app/                       # Next.js App Router
│   ├── api/                   # API routes
│   │   ├── auth/              # Authentication endpoints (login, signup, logout)
│   │   └── dashboard/         # Dashboard API
│   ├── (pages)/               # Public pages group
│   │   ├── page.tsx           # Landing page
│   │   ├── login/             # Login page
│   │   ├── signup/            # Signup page
│   │   └── (protected)/       # Protected routes group
│   │       └── dashboard/     # Dashboard page
│   ├── layout.tsx             # Root layout
│   ├── page.tsx               # Root page (redirects to landing)
│   └── globals.css            # Global styles
├── components/
│   ├── ui/                    # shadcn/ui components
│   └── theme-provider.tsx     # Theme provider
├── lib/
│   ├── api/                   # API layer functions
│   ├── supabase/              # Supabase client utilities (server.ts, client.ts)
│   ├── types/                 # TypeScript type definitions
│   └── utils.ts               # Utility functions (cn helper)
├── cypress/
│   ├── e2e/                   # End-to-end tests (landing, auth, dashboard)
│   └── support/               # Cypress support files
├── supabase/
│   ├── migrations/            # Database migrations
│   │   └── YYYYMMDD_initial_schema.sql
│   ├── seed.sql               # Database seed data
│   └── README.md              # Supabase setup instructions
├── proxy.ts                   # Next.js 16 proxy for auth middleware
```

## NPM Scripts

"dev": "next dev",
"build": "next build",
"start": "next start",
"lint": "eslint",
"test": "jest",
"test:watch": "jest --watch",
"test:coverage": "jest --coverage",
"cypress": "cypress open",
"cypress:headless": "cypress run",
"e2e": "start-server-and-test dev http://localhost:3000 cypress",
"e2e:headless": "start-server-and-test dev http://localhost:3000 cypress:headless",
"supabase:start": "supabase start",
"supabase:stop": "supabase stop",
"supabase:reset": "supabase db reset",
"supabase:status": "supabase status",
"prepare": "husky"

## NextJS CSS Configuration

- Use Tailwind CSS v4
- DO NOT use `@apply` directives - use CSS variables directly
- DO NOT include `tw-animate-css` plugin in tailwind.config.ts
- Use standard CSS in globals.css with CSS variables

## Environment Variables

Create these environment variables in a .env file at the root of the project:

1. `.env.example` - Template with dummy values
```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url_here
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key_here
```
2. `.env.local` - Local development (git-ignored)
```env
NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```
3. `.env.development` - Remote Supabase (git-ignored)
```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_actual_anon_key
```

Use this pattern in .gitignore:
```gitignore
.env
!.env.example
```

## Husky Setup

- Install and configure Husky
- Enforce conventional commits (e.g., `feat(dashboard): added new graph`)
- Set up pre-commit hooks for linting and formatting
- Create commitlint.config.js with @commitlint/config-conventional
- DO NOT create .vscode or editor-specific settings

## Supabase Database

**Initial Migration** - Create only:
- `profiles` table with `id`, `first_name`, `last_name`, `created_at`, `updated_at`
- RLS policies for profiles
- Trigger to auto-create profile when user signs up
- DO NOT create orders or any other tables
**Seed File** - Create demo user:
```sql
-- Email: demo@example.com
-- Password: password123
-- Use bcrypt hash with crypt() function
-- Auto-create profile via trigger
-- Update profile with first_name "Demo" and last_name "User"
```

## ShadCN Components

- Button
- Input
- Label
- Card (with CardHeader, CardTitle, CardDescription, CardContent, CardFooter)
- Sonner (toast)

## Custom Components

- ThemeProvider (dark mode support)

## API Routes

- `/api/auth/login` - POST endpoint
- `/api/auth/signup` - POST endpoint
- `/api/auth/logout` - POST endpoint
- `/api/dashboard` - GET endpoint

## Testing Setup

- Jest configuration with jsdom
- Cypress E2E tests for landing, auth, dashboard
- Testing library integration
