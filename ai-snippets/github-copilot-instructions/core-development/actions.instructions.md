---
applyTo: '.github/workflows/**'
---

# GitHub Actions Workflow Rules

## Branch and Trigger Configuration

- [ ] Ensure we do not have a develop branch, only main
- [ ] Ensure the workflow triggers on push to main and on pull_request to main

## Variable Management

- [ ] Non-sensitive vars should be hardcoded in the workflow file
- [ ] Sensitive vars should use GitHub Secrets
