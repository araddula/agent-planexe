# Planexe Bootstrap

## Purpose

Initialize Planexe for the current repository.

Bootstrap establishes repository context and resolves the workspace that Planexe will use for its artifacts.

Bootstrap does not implement features.

---

## Required Inputs

Read the canonical configuration contract:

```text
~/agent-planexe/docs/configuration.md
```

Follow that configuration contract exactly.

Do not invent another workspace model or configuration schema.

---

# Phase 1 — Locate Repository

Determine the repository root using Git.

If the current directory is not inside a Git repository, report the problem and stop.

Determine:

* repository root
* repository name
* canonical Git remote URL, when available
* repository identity according to the configuration contract

---

# Phase 2 — Resolve Workspace

**Resolve the workspace before creating any Planexe directory.**

Follow this exact sequence.

### 1. Check repository-local configuration

Check:

```text
<repository-root>/.planexe/config.json
```

Do not create `.planexe/` merely to check whether the file exists.

If the file exists, read:

```text
workspace.mode
```

### 2. Check global configuration

Check:

```text
~/agent-planexe/config.json
```

If it exists:

1. determine repository identity
2. check:

```text
repositories[<repository-identity>].workspace.mode
```

3. if no repository-specific mode applies, check:

```text
workspace.mode
```

### 3. Apply built-in default

If no valid configuration specifies a workspace mode, use:

```text
repository-local-gitignored
```

### 4. Resolve physical location

Use:

```text
repository-local-gitignored
    → <repository-root>/.planexe/

repository-local-committed
    → <repository-root>/.planexe/

external
    → ~/agent-planexe/<repository-identity>/
```

### 5. Create only the resolved workspace

Create the selected workspace if necessary.

Do not create `.planexe/` if the resolved workspace is external.

---

# Phase 3 — Existing Workspace

Before creating the resolved workspace:

* inspect whether it already exists
* preserve all existing artifacts
* do not move artifacts
* do not copy artifacts
* do not delete artifacts
* do not create duplicates

If artifacts exist in another workspace because the configuration changed, report this.

Do not migrate them automatically.

---

# Phase 4 — Repository Discovery

Perform targeted repository discovery.

Identify, where applicable:

* project type
* language
* framework
* package manager
* build system
* test framework
* linting
* formatting
* type checking
* application entry points
* major source directories
* important configuration files
* API/data layer
* UI/application structure
* state management
* routing
* mock services
* generated code
* repository conventions
* development commands
* validation commands

Prefer repository evidence over assumptions.

Do not read the entire repository unnecessarily.

---

# Phase 5 — Repository Context

Create or refresh:

```text
<resolved-workspace>/repository-context.md
```

Use:

```markdown
# Repository Context

## Repository

<repository identity>

## Technology

- Language:
- Framework:
- Package manager:
- Build system:

## Project Structure

<important directories and their purpose>

## Application Architecture

<important architectural characteristics>

## Data / API Layer

<important API and data characteristics>

## UI / Client Architecture

<important UI characteristics>

## State Management

<state management approach>

## Testing

<test frameworks and important test locations>

## Development Commands

<important commands>

## Validation Commands

<important commands>

## Repository Conventions

<important coding and architectural conventions>

## Important Files

<important files and why they matter>

## Notes

<other durable context useful for feature planning>
```

Only include information supported by repository inspection.

---

# Existing Repository Context

If `repository-context.md` already exists:

1. read it
2. inspect relevant repository areas
3. refresh stale information
4. preserve useful existing context
5. avoid unnecessary rewriting

---

# Feature Artifacts

Bootstrap must not modify existing feature artifacts.

If:

```text
<resolved-workspace>/features/
```

already exists, leave it unchanged.

Do not modify:

```text
PLAN.md
PROGRESS.md
DECISIONS.md
STATE.json
```

Do not change feature or task statuses.

---

# Gitignore Safety

For:

```text
repository-local-gitignored
```

Planexe expects `.planexe/` to be ignored.

If the required `.gitignore` rule is missing:

1. report the issue
2. ask for permission to modify `.gitignore`
3. do not modify it without permission

For:

```text
repository-local-committed
```

do not modify `.gitignore`.

For:

```text
external
```

no repository `.gitignore` change is required for the workspace.

---

# Safety Rules

Bootstrap must never:

* implement application code
* redesign application architecture
* modify unrelated source files
* reset Git
* clean Git
* discard user changes
* commit changes
* push changes
* move Planexe artifacts
* copy Planexe artifacts between workspaces
* delete Planexe artifacts
* silently modify `.gitignore`
* create `.planexe/` when the resolved workspace is external

Protect unrelated working-tree changes.

---

# Completion

Bootstrap is complete when:

1. repository root is identified
2. repository identity is resolved
3. configuration is resolved
4. workspace mode is reported
5. workspace path is resolved
6. only the resolved workspace is created
7. repository discovery is performed
8. `repository-context.md` exists in the resolved workspace
9. existing feature artifacts remain unchanged
10. no destructive Git operations were performed

Report:

* repository root
* repository identity
* configuration source used
* resolved workspace mode
* resolved workspace path
* major technology findings
* context file path
* any configuration or safety issue requiring user attention
