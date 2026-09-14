# Agent Planexe

> Turn expensive repository understanding and feature reasoning into persistent execution artifacts that AI agents can consume incrementally.

Agent Planexe is a lightweight, host-independent workflow for AI-assisted software development.

It separates:

* repository understanding
* feature planning
* implementation
* progress tracking
* execution state

The goal is simple:

**reason deeply once, persist the result, then execute incrementally without repeatedly rediscovering the repository.**

---

## How It Works

```text
Repository
    │
    ▼
/planexe-bootstrap
    │
    ├── repository-context.md
    │
    ▼
/planexe-plan
    │
    ├── PLAN.md
    ├── DECISIONS.md
    ├── PROGRESS.md
    └── STATE.json
    │
    ▼
/planexe-execute
    │
    ├── implement current task
    ├── validate
    ├── update progress
    └── update state
    │
    ▼
/planexe-status
    │
    └── inspect current state
```

The expensive reasoning happens during planning.

Execution agents then work from the persisted plan instead of repeatedly reconstructing the feature from scratch.

---

## The Four Agents

### `/planexe-bootstrap`

Initializes Planexe for a repository.

It:

* resolves the configured workspace
* discovers the repository structure
* identifies important technologies and conventions
* creates or refreshes `repository-context.md`

It does **not** implement features.

---

### `/planexe-plan`

Creates an implementation-ready feature plan.

It:

* reads repository context
* investigates the relevant code
* identifies affected files and systems
* resolves architectural questions
* defines implementation tasks
* defines validation strategy
* records important decisions

It produces:

```text
features/<feature-name>/
├── PLAN.md
├── PROGRESS.md
├── DECISIONS.md
└── STATE.json
```

---

### `/planexe-execute`

Implements the plan incrementally.

It:

1. reads the current feature state
2. identifies the current task
3. reads only the context required for that task
4. implements the task
5. validates the result
6. updates `PROGRESS.md`
7. updates `STATE.json`

Execution should follow the plan rather than redesigning the feature.

---

### `/planexe-status`

Provides a read-only view of Planexe state.

It reports:

* current feature
* current task
* completed tasks
* blocked tasks
* validation status
* inconsistencies between artifacts

It does not modify repository or Planexe state.

---

# Workspace

Planexe stores its working artifacts in a configurable workspace.

The default is:

```text
.planexe/
```

Three workspace modes are supported.

### 1. `repository-local-gitignored`

Default.

```text
repository/
└── .planexe/
```

The entire `.planexe/` directory is ignored by Git.

Use this when Planexe artifacts are primarily local working state.

---

### 2. `repository-local-committed`

```text
repository/
└── .planexe/
```

The entire `.planexe/` directory is tracked by Git.

Use this when the team intentionally wants to share Planexe artifacts through the repository.

---

### 3. `external`

Planexe stores artifacts outside the repository:

```text
~/agent-planexe/<repository-identity>/
```

This keeps Planexe artifacts separate from the repository.

The Planexe installation itself also lives at:

```text
~/agent-planexe/
```

For example:

```text
~/agent-planexe/
├── core/
├── adapters/
├── templates/
├── docs/
├── config.json
└── <repository-identity>/
    ├── repository-context.md
    └── features/
```

The external workspace uses the same internal structure as `.planexe/`.

---

# Configuration

Configuration can exist at two levels.

### Repository configuration

```text
.planexe/config.json
```

### Global configuration

```text
~/agent-planexe/config.json
```

Precedence:

```text
repository-local configuration
        ↓
global configuration
        ↓
built-in defaults
```

The repository configuration therefore has the highest priority.

The default workspace mode is:

```text
repository-local-gitignored
```

See:

```text
docs/configuration.md
```

for the complete configuration contract.

---

# Feature Artifacts

Each feature gets its own directory:

```text
<workspace>/
└── features/
    └── <feature-name>/
        ├── PLAN.md
        ├── PROGRESS.md
        ├── DECISIONS.md
        └── STATE.json
```

### PLAN.md

The implementation contract.

Contains:

* requirements
* acceptance criteria
* architecture
* data flow
* API behavior
* UI behavior
* affected files
* implementation tasks
* testing strategy
* risks

---

### PROGRESS.md

The actual execution record.

Contains:

* completed work
* files changed
* validation results
* blockers
* deviations
* implementation notes

---

### DECISIONS.md

The reasoning record.

Contains important decisions and their rationale.

---

### STATE.json

Compact machine-readable state.

It allows an execution agent to resume without reading the entire history.

---

# Getting Started

Clone the repository:

```bash
git clone <repository-url>
cd agent-planexe
```

Install Planexe:

```bash
./scripts/install.sh
```

The installation is placed at:

```text
~/agent-planexe/
```

Then make the desired adapter available to your AI host.

Initialize a repository:

```text
/planexe-bootstrap
```

Create a feature plan:

```text
/planexe-plan <feature-name>
```

Execute the plan:

```text
/planexe-execute <feature-name>
```

Inspect progress:

```text
/planexe-status <feature-name>
```

---

# Important Safety Behavior

Planexe agents should:

* preserve unrelated user changes
* avoid destructive Git operations
* never reset or clean the repository
* never silently change `.gitignore`
* never commit changes automatically
* never push changes automatically
* never move or delete feature artifacts automatically
* never create duplicate workspaces
* keep execution scoped to the active feature
* report inconsistencies rather than silently correcting them

If `.planexe/` needs to be added to `.gitignore`, Planexe must ask for permission first.

---

# Repository Structure

```text
agent-planexe/
├── README.md
├── LICENSE
├── .gitignore
│
├── core/
│   ├── planexe-bootstrap.md
│   ├── planexe-plan.md
│   ├── planexe-execute.md
│   └── planexe-status.md
│
├── adapters/
│   ├── vscode/
│   │   └── prompts/
│   │       ├── planexe-bootstrap.prompt.md
│   │       ├── planexe-plan.prompt.md
│   │       ├── planexe-execute.prompt.md
│   │       └── planexe-status.prompt.md
│   │
│   └── agent-host/
│       └── agents/
│           ├── planexe-bootstrap.agent.md
│           ├── planexe-plan.agent.md
│           ├── planexe-execute.agent.md
│           └── planexe-status.agent.md
│
├── templates/
│   ├── PLAN.md
│   ├── PROGRESS.md
│   ├── DECISIONS.md
│   └── STATE.json
│
├── docs/
│   ├── architecture.md
│   ├── workflow.md
│   ├── configuration.md
│   └── plan-format.md
│
└── scripts/
    ├── install.sh
    └── audit.sh
```

---

# Design Philosophy

Planexe is intentionally small.

It does not attempt to replace:

* AI coding agents
* IDEs
* Git
* CI/CD
* code review systems
* project management systems

Instead, it provides a persistent reasoning and execution contract around them.

The central idea is:

> **Do the expensive repository and feature reasoning once. Persist it in inspectable artifacts. Let execution agents consume that reasoning incrementally.**

This makes AI-assisted implementation more resumable, inspectable, and efficient.
