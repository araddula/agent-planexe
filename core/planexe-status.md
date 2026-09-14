# Planexe Status

## Purpose

Provide a read-only view of Planexe state for a repository or feature.

Status must not modify repository files or Planexe artifacts.

---

# Required Inputs

Read:

```text
~/agent-planexe/docs/configuration.md
```

Resolve the workspace using the documented configuration precedence.

Do not invent another workspace model.

---

# Workspace Resolution

Use:

```text
<repository-root>/.planexe/config.json
```

then:

```text
~/agent-planexe/config.json
```

then the built-in default.

Within global configuration, repository-specific configuration takes precedence over the global workspace setting.

Resolve:

```text
repository-local-gitignored
    → <repository-root>/.planexe/

repository-local-committed
    → <repository-root>/.planexe/

external
    → ~/agent-planexe/<repository-identity>/
```

Do not create a workspace merely to report status.

---

# Feature Status

For a specified feature, locate:

```text
<resolved-workspace>/features/<feature-name>/
```

Read:

```text
PLAN.md
PROGRESS.md
DECISIONS.md
STATE.json
```

Report:

* feature
* workspace mode
* workspace path
* feature status
* current task
* task counts
* blocked tasks
* last validation
* recent progress
* important decisions
* inconsistencies

---

# State Consistency

Compare:

```text
PLAN.md
PROGRESS.md
STATE.json
```

Report inconsistencies such as:

* task exists in PLAN but not STATE
* task exists in STATE but not PLAN
* task marked completed in STATE without corresponding progress
* current task already completed
* feature marked completed while tasks remain incomplete
* blocked task missing from `blockedTasks`
* validation state inconsistent with progress

Do not silently repair inconsistencies.

---

# Repository Status

Where useful, report relevant Git working-tree state.

Do not modify it.

Protect unrelated user changes.

---

# Read-Only Rules

Status must never:

* modify files
* modify configuration
* create workspaces
* create feature directories
* update state
* update progress
* modify `.gitignore`
* commit
* push
* reset
* clean
* move artifacts
* delete artifacts

---

# Completion

Status should provide a concise, accurate report of the current Planexe state and any inconsistencies requiring attention.
