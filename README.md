# Agent Planexe

> Persist repository and feature reasoning once, then let AI agents execute from compact, inspectable state.

Agent Planexe is a host-independent workflow for AI-assisted software development. It separates repository discovery, feature planning, implementation, progress, and execution state.

The purpose is not to remove reasoning. It is to avoid paying the same repository-understanding cost on every implementation step.

## The Token Model

Planexe uses a two-phase model:

| Phase | Pays for | Reuses |
| --- | --- | --- |
| Bootstrap and plan | Repository discovery, architecture decisions, affected files, and validation design | `repository-context.md`, `PLAN.md`, `DECISIONS.md` |
| Execute | The current task, its relevant code, and validation | `STATE.json` plus the current task and recent progress |

The intended loop is:

```text
repository
    -> bootstrap -> repository-context.md
    -> plan      -> PLAN.md + DECISIONS.md + PROGRESS.md + STATE.json
    -> execute   -> one task + focused validation
    -> status    -> read-only inspection
```

This saves tokens when the plan is accurate and execution stays scoped. It does not guarantee fewer tokens for every feature: a large plan, stale context, repeated validation failures, or an oversized progress log can erase the benefit.

## How Token Usage Is Controlled

Planexe reduces repeated context by design:

* Bootstrap creates durable repository context once.
* Planning investigates only the feature-relevant parts of the repository.
* Execution starts from `STATE.json.currentTask` instead of replaying the whole feature.
* The executor reads only the repository context needed for that task.
* `STATE.json` stores compact machine-readable state; verbose history belongs in `PROGRESS.md`.
* Stable task IDs make resumption possible without reconstructing task order.
* Status is read-only, so checking progress does not rewrite artifacts or trigger new reasoning.

Good artifacts are decision-dense: they name real files, symbols, constraints, commands, and acceptance conditions. A long artifact that repeats generic instructions is a token cost, not a saving.

## The Four Commands

### `/planexe-bootstrap`

Resolves the workspace and creates or refreshes `repository-context.md`. It discovers the repository; it does not implement features.

### `/planexe-plan <feature-name>`

Investigates the relevant code and creates an implementation contract in `features/<feature-name>/`:

```text
PLAN.md        requirements, design, tasks, validation, risks
DECISIONS.md   material decisions and rationale
PROGRESS.md    execution record, initially empty of fabricated results
STATE.json     compact resume state
```

The plan is designed to be handed to a lower-cost execution model. Each task should identify the exact files and symbols involved, required context and decisions, implementation steps, expected behavior, edge cases, validation, acceptance criteria, and out-of-scope work. A stronger planning model resolves architecture; the executor performs the scoped implementation.

### `/planexe-execute <feature-name>`

Reads `STATE.json` first, then loads the current task and only its referenced context, implements and validates it, and updates progress and state. It should follow the plan rather than redesigning the feature. If the handoff is incomplete, it should report the gap instead of inventing architecture or rediscovering the whole repository.

### `/planexe-status <feature-name>`

Reports workspace, task, validation, progress, and artifact inconsistencies without modifying anything.

## Workspace

Artifacts use one resolved workspace. The built-in default is repository-local and Git-ignored:

```text
<repository>/.planexe/
```

The supported modes are:

* `repository-local-gitignored` - local working state, normally excluded from Git.
* `repository-local-committed` - shared artifacts tracked in the repository.
* `external` - artifacts stored at `~/agent-planexe/<repository-identity>/`.

Configuration is resolved in this order:

1. `<repository>/.planexe/config.json`
2. `~/agent-planexe/config.json` repository-specific setting
3. `~/agent-planexe/config.json` global workspace setting
4. built-in default

The installation itself is always `~/agent-planexe/`. Workspace mode does not move or copy existing artifacts. See [docs/configuration.md](docs/configuration.md) for the full contract.

## Getting Started

```bash
git clone <repository-url>
cd agent-planexe
./scripts/install.sh
```

Then make the adapter available to the AI host and run:

```text
/planexe-bootstrap
/planexe-plan <feature-name>
/planexe-execute <feature-name>
/planexe-status <feature-name>
```

### VS Code Chat Prompts

To make the `/planexe-*` prompts available in VS Code Chat, add the installed prompt directory to `chat.promptFilesLocations`:

1. Open VS Code Settings and search for **Prompt Files Locations**.
2. Add this to `settings.json`:

```json
{
    "chat.promptFilesLocations": {
        "~/agent-planexe/adapters/vscode/prompts": true
    }
}
```


For a complete walkthrough, see [docs/workflow.md](docs/workflow.md).

## Safety and Control

Planexe agents must preserve unrelated user changes and must not:

* reset, clean, commit, or push Git changes automatically;
* silently modify `.gitignore`;
* create duplicate workspaces or migrate artifacts;
* move or delete feature artifacts;
* silently repair inconsistencies between plan, progress, and state.

Artifacts remain inspectable and editable by developers. If `.planexe/` needs to be added to `.gitignore`, the agent must ask first.

## Repository Layout

```text
core/                   canonical host-independent specifications
adapters/vscode/        VS Code prompt adapters
adapters/agent-host/    Agent Host adapters
templates/              feature artifact templates
docs/                   architecture, workflow, configuration, and format contracts
scripts/install.sh      installer
scripts/audit.sh        consistency and structure checks
```

Adapters are intentionally thin: the canonical behavior belongs in `core/`. The detailed contracts are documented in:

* [docs/architecture.md](docs/architecture.md)
* [docs/workflow.md](docs/workflow.md)
* [docs/configuration.md](docs/configuration.md)
* [docs/plan-format.md](docs/plan-format.md)

## Design Boundary

Planexe is a persistence and execution contract around an AI coding agent. It does not replace the agent, IDE, Git, CI/CD, code review, or project management tools.

Its efficiency depends on disciplined artifact maintenance:

* keep `STATE.json` small;
* keep `PROGRESS.md` factual and summarized;
* update `repository-context.md` when durable repository assumptions change;
* add only material decisions to `DECISIONS.md`;
* keep tasks independently understandable and narrowly scoped.

When those rules hold, execution can resume with a small, targeted context instead of rediscovering the repository for every task.
