# GitHub Copilot Instructions

This directory contains reusable instruction files for GitHub Copilot to ensure consistent development practices across projects. These instruction files can be placed in a project's `.github/instructions/` directory to guide Copilot's code generation and recommendations.

## Directory Structure

```
github-copilot-instructions/
├── core-development/       # Core development workflow and validation
├── infrastructure/         # Infrastructure as Code (IaC) practices
├── framework/             # Framework-specific guidelines
├── backend/               # Backend and API development
├── frontend/              # Frontend and UI development
├── version-control/       # Git and commit practices
├── documentation/         # Documentation standards
└── project-specific/      # Project-specific configurations
```

## Available Instruction Files

### Core Development

#### [core-development/actions.instructions.md](core-development/actions.instructions.md)
**Purpose:** Guidelines for GitHub Actions workflow configuration  
**Apply to:** `.github/workflows/**`  
**Key Rules:**
- Use main branch (no develop branch)
- Trigger on push to main and pull_request to main
- Hardcode non-sensitive variables
- Use GitHub Secrets for sensitive data

#### [core-development/finalize.instructions.md](core-development/finalize.instructions.md)
**Purpose:** Validation checklist before completing work  
**Apply to:** `apps/desktop-app/**`  
**Key Rules:**
- Run `npm run lint` to validate code style
- Run `npm run typecheck` to validate TypeScript types
- Run `npm run build` to ensure code compiles
- Run `npm run test` to verify all tests pass

#### [core-development/misc.instructions.md](core-development/misc.instructions.md)
**Purpose:** General development assumptions  
**Apply to:** `apps/desktop-app/**`  
**Key Rules:**
- Assume services are running on correct ports
- Hot reloading is enabled
- Use `lsof -i :<port>` to check if app is running
- App runs on port 3000

### Infrastructure

#### [infrastructure/iac.instructions.md](infrastructure/iac.instructions.md)
**Purpose:** Infrastructure as Code best practices using SST v3  
**Apply to:** `iac/**`  
**Key Rules:**
- Use SST v3 with TypeScript
- Keep `iac/` folder at repository root
- Organize infrastructure by application in `iac/apps/`
- Define secrets in `iac/apps/api/secrets.ts`
- Use `npx sst secret set` to set secrets (never commit values)
- Use `sst.aws.Remix` component for Remix applications

### Framework

#### [framework/remix.instructions.md](framework/remix.instructions.md)
**Purpose:** Comprehensive Remix v2 best practices (466 lines)  
**Apply to:** `apps/desktop-app/**`  
**Key Rules:**
- File-based routing with proper naming conventions
- Use `_index.tsx` for index routes
- Use dot notation for nested URLs
- Use `$` prefix for dynamic segments
- Data loading with loaders
- Server-side utilities and type safety

#### [framework/setup.instructions.md](framework/setup.instructions.md)
**Purpose:** Next.js App Router project structure (142 lines)  
**Apply to:** `./`  
**Key Rules:**
- Use Next.js App Router structure
- Organize API routes in `app/api/`
- Group pages with route groups
- Store Supabase utilities in `lib/supabase/`

### Backend

#### [backend/api.instructions.md](backend/api.instructions.md)
**Purpose:** API development guidelines  
**Apply to:** `apps/api/**`  
**Key Rules:**
- Add tests for all new endpoints

#### [backend/supabase.instructions.md](backend/supabase.instructions.md)
**Purpose:** Supabase database management  
**Apply to:** `apps/api/supabase/**`  
**Key Rules:**
- Assume Supabase is always running locally
- Create new migration files (never modify old ones)
- Update types in api/webapp after database changes
- Never stop the local Supabase instance

#### [backend/webhooks.instructions.md](backend/webhooks.instructions.md)
**Purpose:** Webhook service development  
**Apply to:** `apps/api/src/services/webhookService.ts`  
**Key Rules:**
- Read documentation in `./docs` before making changes

### Frontend

#### [frontend/webapp.instructions.md](frontend/webapp.instructions.md)
**Purpose:** Web application development guidelines  
**Apply to:** `apps/webapp/**`  
**Key Rules:**
- Use `useAxiosAuth` for protected API endpoints
- Check user exists before authenticated requests
- Use `axiosAuth` for all HTTP methods
- Add tests for new features

#### [frontend/widgets.instructions.md](frontend/widgets.instructions.md)
**Purpose:** Custom widget development  
**Apply to:** `apps/client-server/custom-components/widgets/**`  
**Key Rules:**
- Read documentation in `./docs` before making changes

### Version Control

#### [version-control/commit.instructions.md](version-control/commit.instructions.md)
**Purpose:** Commit message formatting  
**Apply to:** All files  
**Key Rules:**
- Follow conventional commit format
- Limit first line to 72 characters or less

### Documentation

#### [documentation/mdcleaner.instructions.md](documentation/mdcleaner.instructions.md)
**Purpose:** Markdown file organization  
**Apply to:** `**/*.md`  
**Key Rules:**
- Markdown files only in README.md files
- README.md allowed in: root, iac, apps/webapp, apps/api
- Exception: `docs` folder (ignore)

### Project-Specific

#### [project-specific/general.instructions.md](project-specific/general.instructions.md)
**Purpose:** Project-specific development guidelines (165 lines)  
**Apply to:** `**`  
**Key Rules:**
- Never start/restart services automatically
- Assume services are already running
- Services have hot-reloading enabled
- Specific port configurations per service

## Usage

To use these instruction files in your project:

1. Create a `.github/instructions/` directory in your project root
2. Copy the relevant instruction files from the appropriate category folders
3. Customize the `applyTo` frontmatter to match your project structure
4. Commit the instruction files to your repository

### Example `.github/instructions/` Structure

```
.github/
└── instructions/
    ├── actions.instructions.md      # from core-development/
    ├── api.instructions.md          # from backend/
    ├── finalize.instructions.md     # from core-development/
    ├── iac.instructions.md          # from infrastructure/
    ├── misc.instructions.md         # from core-development/
    ├── remix.instructions.md        # from framework/
    └── supabase.instructions.md     # from backend/
```

### Quick Copy Commands

```bash
# Copy all core development instructions
cp core-development/*.md .github/instructions/

# Copy specific categories
cp backend/api.instructions.md .github/instructions/
cp infrastructure/iac.instructions.md .github/instructions/

# Copy all instructions from multiple categories
cp core-development/*.md backend/*.md framework/remix.instructions.md .github/instructions/
```

## Instruction File Format

Each instruction file follows this format:

```markdown
```instructions
---
applyTo: 'path/pattern/**'
---

# Title

## Section

- [ ] Checklist item 1
- [ ] Checklist item 2
```
```

- **Frontmatter:** Defines which files/directories the instructions apply to
- **Checklists:** Action items for Copilot to follow
- **Sections:** Organized by topic for easy reference

## Contributing

When adding new instruction files:

1. Use clear, descriptive filenames ending in `.instructions.md`
2. Place the file in the appropriate category folder:
   - **core-development/**: Build, test, validation workflows
   - **infrastructure/**: IaC, deployment, cloud resources
   - **framework/**: Framework-specific patterns (Remix, Next.js, etc.)
   - **backend/**: API, database, server-side logic
   - **frontend/**: UI components, client-side code
   - **version-control/**: Git workflows, commit standards
   - **documentation/**: Documentation standards and organization
   - **project-specific/**: One-off project configurations
3. Include frontmatter with `applyTo` pattern
4. Organize rules as checklists using `- [ ]` format
5. Add an entry to this README with purpose and key rules
6. Keep instructions specific and actionable

## Projects Using These Instructions

- **budget-shark**: Full set (actions, api, finalize, iac, misc, remix)
- **outreach-pilot**: Extended set (actions, api, commit, finalize, mdcleaner, misc, setup, supabase, webapp)
- **algarve-ltd/analyticsaway**: misc.instructions.md
- **algarve-ltd/quoteaway**: widgets.instructions.md
- **algarve-ltd/billingaway**: webhooks.instructions.md
- **motorway/mobilize-improvements**: general.instructions.md
- **galea-gaming**: misc, finalize

## Maintenance

These instruction files should be updated when:

- Development practices change across projects
- New tools or frameworks are adopted
- Patterns emerge that should be standardized
- Team feedback suggests improvements

Last updated: February 15, 2026
