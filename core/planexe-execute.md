# Planexe Execute

## Purpose

Implement a planned feature incrementally using the persisted Planexe artifacts.

Execution should minimize repository rediscovery by consuming the existing plan and state.

---

# Required Inputs

Read:

```text
~/agent-planexe/docs/configuration.md
```

Resolve the workspace before reading feature artifacts.

Do not invent another workspace or configuration model.

---

# Workspace Resolution

Resolve configuration in this order:

```text
<repository-root>/.planexe/config.json
~/agent-planexe/config.json
built-in default
```

Within the global configuration, repository-specific settings take precedence over the global workspace setting.

Use:

```text
<repository-root>/.planexe/
```

for repository-local modes.

Use:

```text
~/agent-planexe/<repository-identity>/
```

for external mode.

Do not create `.planexe/` when external mode is selected.

Do not move or copy artifacts between workspaces.

---

# Required Feature Artifacts

Locate:

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

If the feature does not exist, report that planning must happen first.

---

# Resume From STATE.json

Use `STATE.json` as the compact execution state.

Determine:

* feature status
* current task
* completed tasks
* blocked tasks
* last validation

Do not assume that the first task is the current task.

If `STATE.json` conflicts with `PROGRESS.md` or `PLAN.md`, report the inconsistency before making changes.

Do not silently rewrite history to make artifacts agree.

---

# Current Task

Identify the current task from:

```text
STATE.json.currentTask
```

Read the corresponding task in:

```text
PLAN.md
```

Read only the additional repository context required to execute that task.

Avoid unnecessary repository-wide rediscovery.

---

# Implementation

Implement the current task according to the plan.

Protect unrelated user changes.

Reuse existing repository patterns where the plan identifies them.

Do not redesign the architecture unless implementation evidence makes the planned approach invalid.

---

# Validation

Run the validation defined by the current task.

Where appropriate, validate:

* formatting
* linting
* type checking
* unit tests
* integration tests
* component tests
* E2E tests
* build
* manual behavior

Record meaningful validation results.

---

# Progress Update

After meaningful work:

1. update `PROGRESS.md`
2. update `STATE.json`
3. record validation
4. record blockers
5. record material deviations

Do not erase previous execution history.

---

# Task Completion

A task may be marked:

```text
completed
```

only when its acceptance condition has been satisfied.

If validation fails:

```text
STATE.json.tasks.<task> = "in_progress"
```

or:

```text
blocked
```

as appropriate.

Do not mark failed work as completed.

When the current task completes, advance `currentTask` to the next eligible task.

When all tasks are complete:

```text
STATE.json.status = "completed"
```

and update `PROGRESS.md`.

---

# Deviations

If implementation differs materially from `PLAN.md`:

1. record the actual behavior in `PROGRESS.md`
2. record the architectural decision in `DECISIONS.md` when appropriate
3. continue only when the implementation remains consistent with the feature objective

Do not silently redesign the feature.

---

# Blockers

If execution cannot safely continue:

1. mark the task as `blocked`
2. add it to `blockedTasks`
3. document the reason in `PROGRESS.md`
4. describe the required action

Do not modify unrelated code to work around an unresolved blocker.

---

# Safety Rules

Execute must never:

* reset Git
* clean Git
* discard user changes
* commit automatically
* push automatically
* modify unrelated features
* move Planexe artifacts
* delete Planexe artifacts
* silently modify `.gitignore`
* silently migrate workspace artifacts

---

# Completion

Execution is complete when:

* all planned tasks are completed
* validation passes
* `PROGRESS.md` reflects actual implementation
* `STATE.json` reports `completed`
* material decisions are recorded
* no unrelated user changes were disturbed
