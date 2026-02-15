---
applyTo: 'iac/**'
---

# Infrastructure as Code (IAC) Rules

## IAC Framework

- [ ] Use SST v3 for all infrastructure definitions
- [ ] Define infrastructure in TypeScript for type safety
- [ ] Use Pulumi under the hood (managed by SST)

## Project Structure

- [ ] Keep `iac/` folder at repository root separate from application code
- [ ] Organize infrastructure by application in `iac/apps/` subdirectories
- [ ] Store all secrets definitions in `iac/apps/api/secrets.ts`
- [ ] Never commit secrets values - use `npx sst secret set` command

## Secrets Management

### Distinguish Secrets from Environment Variables

- [ ] **Secrets** = Sensitive data that should never be exposed (API keys, client secrets, private keys)
- [ ] **Environment Variables** = Non-sensitive configuration (URLs, public keys, feature flags)

### Secrets Definition

- [ ] Define all secrets using `new sst.Secret()` in `secrets.ts`
- [ ] Link secrets to resources using the `link` property
- [ ] Access secrets at runtime via `Resource.<SecretName>.value`
- [ ] Document each secret's purpose and example value format

### Setting Secrets

```bash
# Format
npx sst secret set <SecretName> "<value>" --stage <stage>

# Examples
npx sst secret set SupabaseUrl "https://project.supabase.co" --stage production
npx sst secret set RevolutClientSecret "secret_abc123" --stage production
```

## Remix Application Deployment

- [ ] Use `sst.aws.Remix` component for Remix applications
- [ ] Set `path` to the Remix app directory (e.g., `../apps/desktop-app`)
- [ ] Link all required secrets using the `link` array
- [ ] Define custom domains using `domain` property with `dns: sst.aws.dns()`
- [ ] Always include www redirect in domain config

### Example Remix Setup

```typescript
export const webapp = new sst.aws.Remix("DesktopApp", {
  path: "../apps/desktop-app",
  link: [SupabaseUrl, SupabaseAnonKey, RevolutClientSecret],
  environment: {
    NODE_ENV: "production",
  },
  domain: {
    name: "app.example.com",
    dns: sst.aws.dns(),
    redirects: ["www.app.example.com"],
  },
});
```

## Domain Configuration

- [ ] Use Route 53 for DNS management (`sst.aws.dns()`)
- [ ] SSL certificates are auto-provisioned by SST
- [ ] Use subdomain pattern: `app.domain.com` for applications
- [ ] Always redirect www to non-www (or vice versa)

## Deployment Stages

- [ ] Use stages to separate environments: `development`, `staging`, `production`
- [ ] Production stage should use `removal: "retain"` to prevent accidental deletion
- [ ] Stage names affect resource naming and DNS (e.g., `staging-app.domain.com`)

## AWS Configuration

- [ ] Use `eu-west-1` region for European data residency (or appropriate region)
- [ ] Configure AWS provider in `sst.config.ts`
- [ ] Use IAM roles with least privilege access
- [ ] Enable CloudWatch logging for all Lambda functions

## Best Practices

### Before Deploying

- [ ] Run `npx sst diff --stage <stage>` to preview changes
- [ ] Verify all secrets are set: `npx sst secret list --stage <stage>`
- [ ] Review cost estimates for new resources
- [ ] Test in staging before deploying to production

### During Deployment

- [ ] Deploy to staging first, then production
- [ ] Monitor CloudWatch Logs during deployment
- [ ] Verify health checks pass after deployment
- [ ] Update OAuth callback URLs if domains changed

### After Deployment

- [ ] Test the deployed application thoroughly
- [ ] Verify environment variables are accessible
- [ ] Check CloudFront distribution is serving correctly
- [ ] Monitor costs in AWS Cost Explorer

## Local Development

- [ ] Use `.env.local` files for local development secrets
- [ ] Never commit `.env.local` or `.env` files
- [ ] Use `npx sst dev` to connect local dev to AWS resources (optional)
- [ ] Document all required local environment variables

## Troubleshooting

- [ ] Check CloudWatch Logs for Lambda errors
- [ ] Use `npx sst shell` to access AWS environment
- [ ] Verify secrets: `npx sst secret list`
- [ ] Check DNS propagation with `dig` or `nslookup`

## Cost Optimization

- [ ] Monitor Lambda cold starts and optimize bundle size
- [ ] Use CloudFront caching aggressively for static assets
- [ ] Review AWS Cost Explorer monthly
- [ ] Consider Lambda reserved concurrency for predictable workloads
- [ ] Clean up unused stages and resources

## Security

- [ ] Never log secret values in application code
- [ ] Use Systems Manager Parameter Store for secrets (handled by SST)
- [ ] Enable AWS CloudTrail for audit logs
- [ ] Regularly rotate secrets (banking API keys, etc.)
- [ ] Use IAM roles instead of access keys where possible

## Documentation

- [ ] Keep `iac/README.md` updated with setup instructions
- [ ] Document all secrets and their purpose
- [ ] Maintain deployment runbook for common tasks
- [ ] Update technical requirements docs when infrastructure changes
