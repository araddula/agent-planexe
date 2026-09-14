# Planexe Plan

## Purpose

Create an implementation-ready plan for a feature.

The planner performs the expensive repository and feature reasoning once and persists the result as execution artifacts.

The plan is a handoff contract for an executor that may have a smaller context window or lower reasoning capability than the planner. It must contain enough concrete, evidence-based detail for that executor to implement each task without reopening broad architectural investigation.

It does not implement the feature.

---

# Required Inputs

Read:

```text
~/agent-planexe/docs/configuration.md
```

Resolve the workspace before creating or reading feature artifacts.

Follow the workspace resolution procedure exactly.

Do not invent another configuration or workspace model.

---

# Workspace Resolution

Resolve:

```text
<repository-root>/.planexe/config.json
```

then:

```text
~/agent-planexe/config.json
```

using the configuration precedence defined in `docs/configuration.md`.

Use:

```text
<repository-root>/.planexe/
```

for either repository-local mode.

Use:

```text
~/agent-planexe/<repository-identity>/
```

for external mode.

Do not create `.planexe/` when external mode is selected.

Do not migrate artifacts between workspace modes.

---

# Required Repository Context

Read:

```text
<resolved-workspace>/repository-context.md
```

If it does not exist:

1. report that Bootstrap has not been completed
2. do not silently create a different workspace
3. recommend running `/planexe-bootstrap`

---

# Feature Name

Use a concise, lowercase, filesystem-safe feature name.

Examples:

```text
device-search
user-management
bulk-device-import
```

Create:

```text
<resolved-workspace>/features/<feature-name>/
```

---

# Existing Feature

If the feature directory already exists:

* inspect existing `PLAN.md`
* inspect `PROGRESS.md`
* inspect `DECISIONS.md`
* inspect `STATE.json`
* preserve existing implementation history
* update only what is necessary

Do not create duplicate feature directories.

---

# Repository Investigation

Perform targeted investigation of the repository.

Understand:

* relevant source files
* existing architecture
* reusable components
* APIs
* data models
* state management
* routing
* permissions
* tests
* configuration
* repository conventions
* build and validation commands

Use actual repository paths and symbols where possible.

Avoid speculative architecture.

---

# Planning Output

Create or update:

```text
PLAN.md
PROGRESS.md
DECISIONS.md
STATE.json
```

using the templates in:

```text
~/agent-planexe/templates/
```

---

# PLAN.md

`PLAN.md` is the implementation contract.

It must define:

* feature objective
* requirements
* acceptance criteria
* scope
* assumptions
* architecture
* data flow
* UI behavior where applicable
* API/data contract where applicable
* permissions
* testing strategy
* file impact
* implementation tasks
* dependencies
* risks
* open questions

Every implementation task must have a stable identifier:

```text
PLX-001
PLX-002
PLX-003
```

Tasks must be independently understandable.

Each task should define:

* objective
* prerequisites and dependencies
* exact files and symbols to inspect or change
* required repository context and decision references
* implementation steps
* expected behavior
* edge cases and failure behavior
* validation
* acceptance condition
* explicit out-of-scope boundaries

Do not leave architectural choices or implementation strategy for the executor when repository evidence can resolve them during planning. Use concise references to files and symbols instead of copying large source excerpts or adding speculative pseudocode.

---

# DECISIONS.md

Record important architectural and implementation decisions.

For each decision include:

* decision
* rationale
* alternatives considered
* consequences

Do not use this file as an execution log.

---

# PROGRESS.md

Initialize the execution record.

The initial state should accurately represent that implementation has not started.

Do not fabricate implementation results.

---

# STATE.json

Initialize compact machine-readable state.

Example:

```json
{
  "feature": "device-search",
  "status": "planned",
  "currentTask": "PLX-001",
  "tasks": {
    "PLX-001": "not_started",
    "PLX-002": "not_started"
  },
  "blockedTasks": [],
  "lastValidation": {
    "command": null,
    "result": null,
    "timestamp": null
  },
  "updatedAt": null
}
```

---

# Planning Rules

The planner must:

1. inspect the repository before defining tasks
2. use actual repository evidence
3. avoid unnecessary repository-wide exploration
4. identify affected files
5. identify dependencies
6. define concrete validation
7. resolve important architectural questions
8. make tasks executable by another agent
9. preserve existing feature decisions unless deliberately revising them
10. record material design decisions in `DECISIONS.md`
11. design each task as a self-contained handoff for a lower-cost executor
12. perform a final handoff review to confirm every task identifies what to read, what to change, how to validate it, and when to stop

---

# Safety Rules

The planner must never:

* implement application code
* modify unrelated source files
* reset Git
* clean Git
* discard user changes
* commit
* push
* move feature artifacts
* delete feature artifacts
* silently modify `.gitignore`

Protect unrelated working-tree changes.

---

# Completion

Planning is complete when:

* the feature directory exists in the resolved workspace
* `PLAN.md` is implementation-ready
* `PROGRESS.md` is initialized
* `DECISIONS.md` records important planning decisions
* `STATE.json` represents the planned state
* tasks have stable identifiers
* validation is defined
* no feature implementation was performed
