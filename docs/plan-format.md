# Planexe Plan Format

## Overview

Each Planexe feature has a dedicated workspace:

```
<planexe-workspace>/features/<feature-name>/
```

The feature workspace contains:

```
PLAN.md
PROGRESS.md
DECISIONS.md
STATE.json
```

Each file has a distinct responsibility.

---

## PLAN.md

`PLAN.md` is the implementation contract.

It describes:

* objective
* requirements
* acceptance criteria
* scope
* non-goals
* assumptions
* architecture
* data flow
* UI behavior
* API/data contracts
* permissions
* testing strategy
* file impact
* implementation tasks
* task dependencies
* risks
* open questions

The plan describes what should be implemented and how.

It should contain enough detail for the executor to implement tasks without repeatedly rediscovering the repository.

---

## DECISIONS.md

`DECISIONS.md` records important decisions and their rationale.

Use it for decisions that materially affect implementation.

Each decision should capture:

* decision
* rationale
* alternatives considered
* consequences

Do not use `DECISIONS.md` as an implementation log.

---

## PROGRESS.md

`PROGRESS.md` records what actually happened during execution.

It may contain:

* implementation summaries
* files changed
* validation results
* blockers
* deviations
* meaningful checkpoints
* final implementation summary

Progress must describe actual execution rather than repeat the original plan.

---

## STATE.json

`STATE.json` contains the compact machine-readable execution state.

It identifies:

* feature
* overall status
* current task
* task statuses
* blocked tasks
* latest validation
* last update

Keep the file small.

Do not store verbose history in `STATE.json`.

---

## Task IDs

Tasks use stable IDs:

```
PLX-001
PLX-002
PLX-003
```

Task IDs must remain stable throughout feature execution.

Do not renumber completed tasks.

If a new task is required, append a new task ID.

---

## Task Structure

Each task should define:

### Objective

What the task accomplishes.

### Dependencies

Tasks that must be completed first.

### Files

Files to:

* create
* modify
* reference

### Implementation

Concrete instructions for the executor.

### Behavior

Expected user or system behavior.

### Edge Cases

Relevant boundary and failure conditions.

### Validation

How completion should be verified.

### Acceptance Criteria

Observable conditions that establish task completion.

---

## Task Independence

Tasks should be independently understandable where practical.

An executor should be able to read:

1. repository context
2. current task
3. relevant decisions
4. recent progress

and understand what to do without reading the entire feature history.

---

## Feature Status

Feature status values are:

```
planned
in_progress
blocked
completed
```

A feature should be marked `completed` only when:

* all required tasks are complete
* acceptance criteria are satisfied
* required validation has passed
* the final result is recorded in `PROGRESS.md`

---

## Task Status

Task status values are:

```
not_started
in_progress
completed
blocked
```

A blocked task should include the reason in `PROGRESS.md`.

---

## State Consistency

The following should remain consistent:

```
PLAN.md
   ↓
defines tasks

STATE.json
   ↓
identifies current task and status

PROGRESS.md
   ↓
records actual execution

DECISIONS.md
   ↓
records meaningful decisions
```

If the artifacts become inconsistent, the executor should report the discrepancy rather than silently rewriting history.
