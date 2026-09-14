# Feature Plan

## Feature

`<feature-name>`

## Objective

Describe the problem this feature solves and the expected outcome.

## Requirements

### Functional Requirements

* `<requirement>`

### Non-Functional Requirements

* `<requirement>`

## Acceptance Criteria

* `<criterion>`

## Scope

### In Scope

* `<item>`

### Out of Scope

* `<item>`

## Assumptions

* `<assumption>`

## Architecture

Describe the implementation architecture relevant to this feature.

Include:

* affected components
* responsibilities
* integration points
* important constraints

## Data Flow

Describe how information moves through the system.

```text
Input
  ↓
Component
  ↓
Service / API
  ↓
State / Storage
  ↓
Output
```

## UI Behavior

If applicable, describe:

* screens
* states
* interactions
* loading behavior
* error behavior
* empty states
* permissions
* navigation

## API / Data Contract

If applicable, describe:

* endpoints
* request parameters
* request body
* response shape
* errors
* validation
* pagination
* filtering
* sorting

## Permissions

Describe required authorization or access rules.

## Testing Strategy

Describe how the implementation will be validated.

Include:

* unit tests
* integration tests
* component tests
* E2E tests
* manual validation

Only include applicable test types.

## File Impact

### Files To Modify

* `<path>`

### Files To Create

* `<path>`

### Files To Delete

* `<path>` or `None`

## Implementation Tasks

Tasks must have stable identifiers.

### PLX-001 — `<task name>`

**Status:** `not_started`

**Objective**

Describe exactly what this task must accomplish.

**Implementation**

* `<step>`
* `<step>`

**Files**

* `<path>`

**Validation**

* `<command or validation method>`

**Acceptance**

* `<condition that proves completion>`

### PLX-002 — `<task name>`

**Status:** `not_started`

**Objective**

Describe exactly what this task must accomplish.

**Implementation**

* `<step>`
* `<step>`

**Files**

* `<path>`

**Validation**

* `<command or validation method>`

**Acceptance**

* `<condition that proves completion>`

## Dependencies

Describe task dependencies.

Example:

```text
PLX-001
   ↓
PLX-002
   ↓
PLX-003
```

## Risks

### Risk

`<risk>`

**Impact:** `<impact>`

**Mitigation:** `<mitigation>`

## Open Questions

Only include unresolved questions that materially affect implementation.

If there are none:

```text
None.
```

---

## Planning Rules

This document is the implementation contract.

The planner should:

1. inspect the repository before creating tasks
2. use actual repository paths and symbols where possible
3. avoid speculative implementation details
4. identify dependencies explicitly
5. make validation concrete
6. resolve architectural decisions before execution when possible
7. keep tasks independently understandable
8. give every task a stable `PLX-*` identifier

The executor should follow this document unless an implementation reality requires deviation.

Material deviations must be recorded in `PROGRESS.md` and, when they change the intended design, `DECISIONS.md`.
