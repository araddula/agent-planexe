# Planexe Architecture

## Overview

Planexe separates repository reasoning from feature execution.

The system consists of:

```text
AI Host
   │
   ├── Bootstrap
   ├── Plan
   ├── Execute
   └── Status
          │
          ▼
   Canonical Core Specifications
          │
          ▼
   Workspace
          │
          ├── repository-context.md
          │
          └── features/
              └── <feature>/
                  ├── PLAN.md
                  ├── PROGRESS.md
                  ├── DECISIONS.md
                  └── STATE.json
```

---

# Fixed Planexe Home

Planexe is installed at:

```text
~/agent-planexe/
```

This location is fixed.

It contains:

```text
~/agent-planexe/
├── core/
├── adapters/
├── templates/
├── docs/
├── config.json
└── <repository-identity>/
```

`config.json` and external repository workspaces are optional.

The installer must preserve both when they exist.

---

# Core

The core specifications are host-independent:

```text
core/
├── planexe-bootstrap.md
├── planexe-plan.md
├── planexe-execute.md
└── planexe-status.md
```

They define Planexe behavior without depending on a particular AI host.

---

# Adapters

Adapters translate host-specific invocation into the core specifications.

```text
adapters/
├── vscode/
│   └── prompts/
└── agent-host/
    └── agents/
```

Adapters should remain thin.

They should not contain independent workspace or execution logic.

The canonical behavior belongs in `core/`.

---

# Configuration

Configuration determines where Planexe artifacts live.

Sources:

```text
<repository>/.planexe/config.json
~/agent-planexe/config.json
built-in defaults
```

Global repository-specific configuration is evaluated before the global workspace default.

---

# Workspace

Planexe supports exactly three workspace modes.

## Repository-local-gitignored

```text
<repository>/.planexe/
```

The entire directory is intended to be ignored.

## Repository-local-committed

```text
<repository>/.planexe/
```

The directory may be intentionally tracked.

## External

```text
~/agent-planexe/<repository-identity>/
```

External workspaces are outside the repository.

---

# Workspace Resolution

Every agent that accesses Planexe artifacts must:

1. locate repository root
2. inspect repository-local configuration without creating `.planexe`
3. inspect global configuration
4. resolve repository identity
5. apply configuration precedence
6. resolve physical workspace
7. create only the resolved workspace when necessary

This prevents accidental creation of competing workspaces.

---

# Repository Context

Bootstrap creates:

```text
<workspace>/repository-context.md
```

It captures durable repository understanding such as:

* technology
* structure
* architecture
* APIs
* UI
* state management
* testing
* commands
* conventions

It is the primary context source for later planning.

---

# Feature Artifacts

Each feature has:

```text
<workspace>/features/<feature-name>/
├── PLAN.md
├── PROGRESS.md
├── DECISIONS.md
└── STATE.json
```

### PLAN.md

Implementation contract.

### PROGRESS.md

Actual execution history.

### DECISIONS.md

Important reasoning and decisions.

### STATE.json

Compact machine-readable execution state.

---

# Execution Model

The intended flow is:

```text
Bootstrap
    ↓
repository-context.md
    ↓
Plan
    ↓
PLAN.md + DECISIONS.md + PROGRESS.md + STATE.json
    ↓
Execute
    ↓
incremental implementation
    ↓
validation
    ↓
updated state
```

Execution should consume persisted reasoning instead of repeatedly rediscovering the repository.

---

# Safety

Planexe does not own Git history.

Agents must:

* preserve unrelated changes
* avoid destructive Git commands
* never commit automatically
* never push automatically
* never silently edit `.gitignore`
* never migrate workspaces automatically
* never delete feature artifacts automatically

---

# Design Principle

The central architectural principle is:

> Perform expensive repository and feature reasoning once, persist it as inspectable artifacts, and let execution agents consume that reasoning incrementally.
