# Planexe Configuration

## Overview

Planexe is installed at:

```text
~/agent-planexe/
```

This is the fixed Planexe home.

The same directory contains:

* Planexe installation files
* optional global configuration
* external repository workspaces

Planexe supports exactly three workspace modes:

1. `repository-local-gitignored`
2. `repository-local-committed`
3. `external`

The built-in default is:

```text
repository-local-gitignored
```

---

# Planexe Home

The fixed Planexe home is:

```text
~/agent-planexe/
```

Installation files include:

```text
~/agent-planexe/
├── core/
├── adapters/
├── templates/
├── docs/
├── config.json
└── <repository-identity>/
```

`config.json` is optional.

Do not provide a configuration option for changing the Planexe installation location.

---

# Global Configuration

Global configuration is optional:

```text
~/agent-planexe/config.json
```

The global configuration can define a default workspace mode:

```json
{
  "workspace": {
    "mode": "external"
  }
}
```

It can also define repository-specific configuration:

```json
{
  "workspace": {
    "mode": "external"
  },
  "repositories": {
    "git@github.com:example/device-app.git": {
      "workspace": {
        "mode": "repository-local-committed"
      }
    }
  }
}
```

The global configuration file must not be created automatically by the installer or Bootstrap.

The installer must preserve this file when reinstalling Planexe.

The installer must also preserve external repository workspaces.

---

# Repository-Local Configuration

Repository-local configuration is:

```text
<repository-root>/.planexe/config.json
```

Example:

```json
{
  "workspace": {
    "mode": "repository-local-gitignored"
  }
}
```

Committed mode:

```json
{
  "workspace": {
    "mode": "repository-local-committed"
  }
}
```

External mode:

```json
{
  "workspace": {
    "mode": "external"
  }
}
```

Repository-local configuration has the highest configuration precedence.

---

# Configuration Precedence

Workspace configuration must be resolved in this order:

```text
1. repository-local configuration
2. global repository-specific configuration
3. global workspace configuration
4. built-in default
```

More precisely:

### 1. Repository-local configuration

Read:

```text
<repository-root>/.planexe/config.json
```

If it exists and contains a valid:

```text
workspace.mode
```

value, use it.

### 2. Global repository-specific configuration

Read:

```text
~/agent-planexe/config.json
```

Determine the repository identity.

Look for:

```text
repositories[<repository-identity>].workspace.mode
```

If present and valid, use it.

### 3. Global workspace configuration

If no repository-specific configuration applies, look for:

```text
workspace.mode
```

in:

```text
~/agent-planexe/config.json
```

If present and valid, use it.

### 4. Built-in default

If no configuration specifies a valid workspace mode, use:

```text
repository-local-gitignored
```

---

# Valid Workspace Modes

Only these values are valid:

```text
repository-local-gitignored
repository-local-committed
external
```

If an explicitly configured mode is invalid, report the configuration error.

Do not silently replace an invalid explicit value with another configured value.

If the configuration cannot be used, the agent should not create a workspace until the issue is resolved or the user explicitly chooses to proceed with the built-in default.

---

# Repository Identity

External workspaces require a stable repository identity.

Resolve identity in this order:

1. canonical Git remote URL
2. normalized repository name
3. absolute repository path

Prefer the canonical Git remote URL when available.

The identity must be converted into a filesystem-safe representation.

Examples:

```text
git@github.com:example/device-app.git
```

may become:

```text
github.com-example-device-app
```

The exact normalization algorithm should be deterministic.

The same repository must resolve to the same identity across sessions.

Do not create duplicate external workspace directories for the same repository.

---

# Workspace Modes

## repository-local-gitignored

Workspace:

```text
<repository-root>/.planexe/
```

This is the built-in default.

The entire `.planexe/` directory is intended to be ignored by Git.

If the required `.gitignore` rule is missing, Planexe must ask for permission before modifying `.gitignore`.

Planexe must never modify `.gitignore` silently.

---

## repository-local-committed

Workspace:

```text
<repository-root>/.planexe/
```

The directory is intentionally available for Git tracking.

Planexe must not automatically add or remove `.gitignore` rules.

---

## external

Workspace:

```text
~/agent-planexe/<repository-identity>/
```

The external workspace must not be created inside the repository.

Its internal structure is the same as a repository-local workspace:

```text
~/agent-planexe/<repository-identity>/
├── repository-context.md
└── features/
    └── <feature-name>/
        ├── PLAN.md
        ├── PROGRESS.md
        ├── DECISIONS.md
        └── STATE.json
```

---

# Workspace Resolution Procedure

Every Planexe agent that works with artifacts must resolve the workspace using the following procedure.

### Step 1 — Locate repository root

Determine the current repository root using Git.

### Step 2 — Inspect repository-local configuration

Check:

```text
<repository-root>/.planexe/config.json
```

Do not create `.planexe/` merely to look for configuration.

### Step 3 — Inspect global configuration

Check:

```text
~/agent-planexe/config.json
```

If it exists, determine repository-specific configuration before global defaults.

### Step 4 — Determine repository identity

Resolve the identity using the repository identity rules.

### Step 5 — Resolve workspace mode

Apply the configuration precedence rules.

### Step 6 — Resolve physical workspace

Map the selected mode to its physical location.

### Step 7 — Only then create the workspace

Create the resolved workspace if it does not exist.

Never create a different workspace first and migrate artifacts later.

---

# Workspace Migration

Changing workspace configuration does not automatically migrate artifacts.

For example, changing from:

```text
repository-local-gitignored
```

to:

```text
external
```

must not automatically move:

```text
<repository>/.planexe/
```

to:

```text
~/agent-planexe/<repository-identity>/
```

Instead:

* resolve the newly configured workspace
* report existing artifacts in another workspace if relevant
* do not copy them automatically
* do not delete the old workspace
* do not create duplicate feature artifacts

Migration, if ever required, must be an explicit user action.

---

# Configuration Safety

Planexe must:

* preserve existing configuration
* preserve unrelated files
* preserve existing feature artifacts
* never silently modify `.gitignore`
* never delete configuration
* never move workspaces automatically
* never create duplicate workspaces
* never commit configuration automatically
* never push configuration automatically

---

# Example Configurations

## Default behavior

No configuration is required.

Built-in behavior:

```text
repository-local-gitignored
```

---

## Global external workspaces

```json
{
  "workspace": {
    "mode": "external"
  }
}
```

All repositories without a more specific configuration use:

```text
~/agent-planexe/<repository-identity>/
```

---

## Global committed workspace

```json
{
  "workspace": {
    "mode": "repository-local-committed"
  }
}
```

All repositories without a more specific configuration use:

```text
<repository-root>/.planexe/
```

---

## Repository-specific override

```json
{
  "workspace": {
    "mode": "external"
  },
  "repositories": {
    "git@github.com:example/device-app.git": {
      "workspace": {
        "mode": "repository-local-committed"
      }
    }
  }
}
```

The example repository uses:

```text
<repository-root>/.planexe/
```

while other repositories use the global external mode.

---

# Configuration Does Not Define Feature State

Workspace configuration only determines where Planexe artifacts live.

It does not define:

* feature status
* task status
* implementation decisions
* validation results

Those belong to the feature artifacts:

```text
PLAN.md
PROGRESS.md
DECISIONS.md
STATE.json
```
