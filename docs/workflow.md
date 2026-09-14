# Planexe Workflow

## Overview

Planexe uses four stages:

```text
Bootstrap → Plan → Execute → Status
```

Each stage has a specific responsibility.

---

# 1. Bootstrap

Run:

```text
/planexe-bootstrap
```

Bootstrap:

1. locates the repository
2. resolves configuration
3. resolves the workspace
4. discovers repository structure
5. creates or refreshes `repository-context.md`

The workspace is resolved **before** any Planexe directory is created.

If the workspace is external, Bootstrap does not create `.planexe/`.

---

# 2. Plan

Run:

```text
/planexe-plan <feature-name>
```

The planner reads:

```text
<workspace>/repository-context.md
```

and investigates the repository areas relevant to the feature.

It creates:

```text
<workspace>/features/<feature-name>/
├── PLAN.md
├── PROGRESS.md
├── DECISIONS.md
└── STATE.json
```

Planning should resolve important architectural questions before implementation.

---

# 3. Execute

Run:

```text
/planexe-execute <feature-name>
```

Execution reads:

```text
PLAN.md
PROGRESS.md
DECISIONS.md
STATE.json
```

It determines the current task from `STATE.json`.

The agent:

1. reads the current task
2. investigates only required repository context
3. implements the task
4. validates it
5. records progress
6. updates state
7. advances to the next task

Execution should not repeatedly rediscover the whole repository.

---

# 4. Status

Run:

```text
/planexe-status <feature-name>
```

Status is read-only.

It reports:

* workspace
* feature status
* current task
* completed tasks
* blocked tasks
* validation
* progress
* inconsistencies

It does not repair state automatically.

---

# Workspace Resolution

All stages use the same workspace resolution rules.

Configuration precedence:

```text
repository-local configuration
        ↓
global repository-specific configuration
        ↓
global workspace configuration
        ↓
built-in default
```

Repository-local configuration:

```text
<repository>/.planexe/config.json
```

Global configuration:

```text
~/agent-planexe/config.json
```

Default:

```text
repository-local-gitignored
```

---

# Workspace Paths

```text
repository-local-gitignored
    → <repository>/.planexe/

repository-local-committed
    → <repository>/.planexe/

external
    → ~/agent-planexe/<repository-identity>/
```

The selected workspace is created only after configuration has been resolved.

---

# Changing Workspace Mode

Changing configuration does not migrate existing artifacts.

For example:

```text
<repository>/.planexe/
```

is not automatically copied to:

```text
~/agent-planexe/<repository-identity>/
```

The old workspace remains untouched.

If artifacts exist in another workspace, the agent should report that fact when relevant.

---

# Feature Lifecycle

A typical feature moves through:

```text
planned
   ↓
in_progress
   ↓
completed
```

A feature may become:

```text
blocked
```

when execution cannot safely continue.

Task states are:

```text
not_started
in_progress
completed
blocked
```

---

# Resuming Work

Execution can resume after interruption.

`STATE.json` identifies:

```text
currentTask
```

while:

```text
PROGRESS.md
```

contains execution history.

This allows an agent to continue without reconstructing the entire feature from scratch.

---

# Human Control

Planexe artifacts remain inspectable and editable by developers.

Agents must not:

* commit automatically
* push automatically
* delete artifacts automatically
* migrate artifacts automatically
* silently modify `.gitignore`
* discard unrelated changes

The developer remains in control of repository history and workspace migration.
