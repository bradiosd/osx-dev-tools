# Development Environment Setup

This document outlines the tools installed on this macOS system and how to use them.

## Contents

- [Installed Tools](#installed-tools)
  - [Core Development Tools](#core-development-tools)
    - [Xcode Command Line Tools](#xcode-command-line-tools)
    - [Homebrew](#homebrew)
  - [Shell & Terminal](#shell--terminal)
    - [Oh My Zsh](#oh-my-zsh)
  - [Version Managers](#version-managers)
    - [nvm (Node Version Manager)](#nvm-node-version-manager)
    - [pyenv (Python Version Manager)](#pyenv-python-version-manager)
  - [Containers & Infrastructure](#containers--infrastructure)
    - [Docker Desktop](#docker-desktop)
    - [Terraform](#terraform)
    - [tflocal](#tflocal)
    - [AWS CLI](#aws-cli)
    - [Supabase CLI](#supabase-cli)
    - [SST Dev](#sst-dev)
  - [Command-line Utilities](#command-line-utilities)
    - [jq](#jq)
  - [Version Control & Authentication](#version-control--authentication)
    - [SSH Configuration](#ssh-configuration)
- [Getting Started](#getting-started)
- [Additional Resources](#additional-resources)
- [Notes](#notes)

## Installed Tools

### Core Development Tools

#### Xcode Command Line Tools
**Location:** System-wide installation  
**Purpose:** Provides essential development tools including git, make, and compilers.

**Verification:**
```bash
xcode-select -p
```

### 2. Homebrew
**Location:** `/opt/homebrew/`

**Purpose:** Package manager for macOS that simplifies installing and managing software.

**Configuration:**
- Added to PATH via `~/.zprofile`
- Shell environment initialized with: `eval "$(/opt/homebrew/bin/brew shellenv)"`

**Documentation:** https://docs.brew.sh/

### Shell & Terminal

#### Oh My Zsh
**Status:** Previously installed  
**Location:** `~/.oh-my-zsh`  
**Purpose:** Framework for managing zsh configuration with themes and plugins.

**Configuration File:** `~/.zshrc`

**Common Tasks:**
```bash
# Update Oh My Zsh
omz update

# List available themes
ls ~/.oh-my-zsh/themes/

# List available plugins
ls ~/.oh-my-zsh/plugins/

# Edit configuration
code ~/.zshrc
```

**Popular Plugins to Enable:**
- `git` - Git aliases and completions
- `docker` - Docker completions
- `npm` - npm completions
- `zsh-autosuggestions` - Command suggestions (requires separate installation)
- `zsh-syntax-highlighting` - Command syntax highlighting (requires separate installation)

**Documentation:** https://github.com/ohmyzsh/ohmyzsh

### Version Managers

#### nvm (Node Version Manager)
**Location:** `/Applications/Docker.app`  
**Binaries:** `/usr/local/bin/docker`, `/usr/local/bin/docker-compose`

**Purpose:** Platform for building, running, and managing containerized applications.

**Getting Started:**
1. Launch Docker Desktop from Applications or Spotlight
2. Wait for Docker to start (whale icon in menu bar should be steady)
3. Verify installation:
   ```bash
   docker --version
   docker-compose --version
   ```

**Documentation:** https://docs.docker.com/

#### nvm (Node Version Manager)
**Location:** `~/.nvm`

**Purpose:** Manage multiple Node.js versions on a single machine.

**Configuration:**
- Auto-configured in `~/.zshrc`
- Loads automatically in new terminal sessions

**Getting Started:**
```bash
# Install the latest LTS version of Node.js
nvm install --lts

# Install a specific version
nvm install 18.19.0

# List installed versions
nvm ls

# List available versions
nvm ls-remote

# Use a specific version
nvm use 18

# Set default version
nvm alias default 18

# Check current version
node --version
```

**Documentation:** https://github.com/nvm-sh/nvm

#### pyenv (Python Version Manager)
**Location:** `~/.pyenv`

**Purpose:** Manage multiple Python versions on a single machine (similar to nvm for Node.js).

**Configuration:**
- Auto-configured in `~/.zshrc`
- Loads automatically in new terminal sessions

**Getting Started:**
```bash
# Install the latest stable version
pyenv install 3.12.0

# Install a specific version
pyenv install 3.11.5

# List installed versions
pyenv versions

# List available versions
pyenv install --list

# Set global Python version
pyenv global 3.12.0

# Set local version for current directory
pyenv local 3.11.5

# Check current version
python --version
```

**Documentation:** https://github.com/pyenv/pyenv

### Containers & Infrastructure

#### Docker Desktop
**Location:** `/Applications/Docker.app`  
**Binaries:** `/usr/local/bin/docker`, `/usr/local/bin/docker-compose`

**Purpose:** Platform for building, running, and managing containerized applications.

**Getting Started:**
1. Launch Docker Desktop from Applications or Spotlight
2. Wait for Docker to start (whale icon in menu bar should be steady)
3. Verify installation:
   ```bash
   docker --version
   docker-compose --version
   ```

**Documentation:** https://docs.docker.com/

#### Terraform
**Purpose:** Infrastructure as Code tool for building, changing, and versioning infrastructure.

**Note:** Homebrew installs the last open-source version before HashiCorp changed to BUSL license. For newer versions, consider OpenTofu (open-source fork).

**Usage:**
```bash
# Initialize Terraform
terraform init

# Plan infrastructure changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy
```

**Documentation:** https://www.terraform.io/docs

#### tflocal
**Purpose:** Wrapper script for Terraform to use with LocalStack for local AWS cloud development and testing.

**Installation:**
```bash
brew install terraform-local
```

**Usage:**
```bash
# Use tflocal instead of terraform when working with LocalStack
tflocal init
tflocal plan
tflocal apply
```

**Note:** Requires LocalStack to be running locally. Automatically configures Terraform to use LocalStack endpoints.

**Documentation:** https://docs.localstack.cloud/user-guide/integrations/terraform/

#### AWS CLI
**Purpose:** Command-line interface for Amazon Web Services.

**Configuration:**
```bash
# Configure AWS credentials
aws configure

# Or set specific profile
aws configure --profile myprofile
```

**Usage:**
```bash
# List S3 buckets
aws s3 ls

# Get EC2 instances
aws ec2 describe-instances

# Use specific profile
aws s3 ls --profile myprofile
```

**Examples Location:** `/opt/homebrew/share/awscli/examples`

**Documentation:** https://docs.aws.amazon.com/cli/

#### Supabase CLI
**Purpose:** Command-line interface for Supabase - open-source Firebase alternative for database, authentication, storage, and realtime functionality.

**Getting Started:**
```bash
# Login to Supabase
supabase login

# Initialize a new project
supabase init

# Start local development
supabase start

# Stop local development
supabase stop

# Check service status
supabase status

# Generate TypeScript types from database
supabase gen types typescript --local > types/supabase.ts
```

**Documentation:** https://supabase.com/docs/guides/cli

#### SST Dev
**Purpose:** Development environment and deployment tool for serverless applications on AWS. SST makes it easy to build full-stack applications with infrastructure as code.

**Installation:**
```bash
curl -fsSL https://sst.dev/install | bash
```

**Getting Started:**
```bash
# Initialize a new SST project
sst init

# Start local development (Live Lambda Development)
sst dev

# Deploy to AWS
sst deploy

# Deploy to a specific stage
sst deploy --stage production

# Remove all resources
sst remove

# Open the SST Console
sst console
```

**Features:**
- Live Lambda Development - Test Lambda functions locally with real AWS resources
- Infrastructure as Code using TypeScript
- Built-in support for common patterns (APIs, databases, auth, etc.)
- SST Console for debugging and monitoring

**Documentation:** https://sst.dev/docs

### Command-line Utilities

#### jq
**Purpose:** Command-line JSON processor for parsing, filtering, and manipulating JSON data.

**Usage Examples:**
```bash
# Pretty print JSON
echo '{"name":"value"}' | jq '.'

# Extract specific field
curl api.example.com/data | jq '.results[]'

# Filter arrays
cat data.json | jq '.items[] | select(.active == true)'
```

**Documentation:** https://jqlang.github.io/jq/

### Version Control & Authentication

#### SSH Configuration
**Location:** `~/.ssh/config`  
**Keys:** `~/.ssh/id_ed25519_github` (private), `~/.ssh/id_ed25519_github.pub` (public)

**Purpose:** Secure authentication with Git repositories using SSH keys.

**Configuration:**
- SSH key added to macOS Keychain for automatic passphrase management
- Custom host alias configured for GitHub access
- Keys automatically loaded via SSH agent

**SSH Config Structure:**
```
Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_github
    IdentitiesOnly yes
    UseKeychain yes
    AddKeysToAgent yes
```

**Usage:**
```bash
# Clone using the configured host alias
git clone git@github-work:organization/repository.git

# Instead of the standard format
git clone git@github.com:organization/repository.git
```

**Benefits:**
- Use different SSH keys for different accounts/organizations
- Passphrase stored securely in macOS Keychain (no repeated prompts)
- Clear identification of which key is used for which repository

**Organization-Based Repository Structure:**
Organize repositories by creating folders for each organization:
```
~/Code/
├── organization-name/
│   ├── repo1/
│   ├── repo2/
│   └── repo3/
└── another-org/
    ├── project1/
    └── project2/
```

**SAML SSO Organizations:**
Some organizations enforce SAML Single Sign-On. If you encounter authentication errors:
1. Visit https://github.com/settings/keys
2. Find your SSH key in the list
3. Click "Configure SSO" next to the key
4. Authorize it for the required organization(s)

**Documentation:** https://docs.github.com/en/authentication/connecting-to-github-with-ssh

## Getting Started

1. **Verify installations:**
   ```bash
   brew --version
   git --version
   docker --version
   nvm --version
   pyenv --version
   jq --version
   terraform --version
   aws --version
   echo $ZSH
   ```

2. **Customize your shell:**
   - Edit `~/.zshrc` to change themes and enable plugins
   - Current theme can be changed by modifying the `ZSH_THEME` variable

3. **Install useful packages with Homebrew:**
   ```bash
   brew install wget curl
   ```

## Additional Resources

- **Homebrew Package Search:** https://formulae.brew.sh/
- **Oh My Zsh Themes:** https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
- **Oh My Zsh Plugins:** https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins

## Notes

- Homebrew is configured for Apple Silicon (ARM64) architecture
- Shell configuration is stored in `~/.zprofile` and `~/.zshrc`
- To reload your shell configuration: `source ~/.zshrc`
