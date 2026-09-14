#!/usr/bin/env bash

set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "=== Repository structure ==="

find . -type f | grep -v '/.git/' | grep -v 'scripts/audit.sh' | sort

echo
echo "=== Stale architecture references ==="

STALE_FOUND=0

grep -RniF "PLANEXE_HOME" README.md core adapters templates docs 2>/dev/null && STALE_FOUND=1 || true
grep -RniF "runtime.md" README.md core adapters templates docs 2>/dev/null && STALE_FOUND=1 || true
grep -RniF "/prototype" README.md core adapters templates docs 2>/dev/null && STALE_FOUND=1 || true
grep -RniF "~/agent-planexe/workspaces" README.md core adapters templates docs 2>/dev/null && STALE_FOUND=1 || true
grep -RniF "~/agent-planexe/config/" README.md core adapters templates docs 2>/dev/null && STALE_FOUND=1 || true

if [ "$STALE_FOUND" -eq 1 ]; then
echo
echo "ERROR: stale architecture references found."
exit 1
fi

echo "OK: no known stale architecture references found."

echo
echo "=== Workspace model ==="

echo "--- .planexe ---"
grep -RniF ".planexe" README.md core adapters templates docs 2>/dev/null || true

echo "--- repository-local-gitignored ---"
grep -RniF "repository-local-gitignored" README.md core adapters templates docs 2>/dev/null || true

echo "--- repository-local-committed ---"
grep -RniF "repository-local-committed" README.md core adapters templates docs 2>/dev/null || true

echo "--- external ---"
grep -RniF "external" README.md core adapters templates docs 2>/dev/null || true

echo "--- ~/agent-planexe ---"
grep -RniF "~/agent-planexe" README.md core adapters templates docs 2>/dev/null || true

echo
echo "=== Configuration schema ==="

grep -qF "workspace.mode" docs/configuration.md
grep -qF "repositories" docs/configuration.md
grep -qF "Configuration Precedence" docs/configuration.md

echo "OK: expected configuration schema references found."

echo
echo "=== Adapter structure ==="

test -f adapters/vscode/prompts/planexe-bootstrap.prompt.md
test -f adapters/vscode/prompts/planexe-plan.prompt.md
test -f adapters/vscode/prompts/planexe-execute.prompt.md
test -f adapters/vscode/prompts/planexe-status.prompt.md

test -f adapters/agent-host/agents/planexe-bootstrap.agent.md
test -f adapters/agent-host/agents/planexe-plan.agent.md
test -f adapters/agent-host/agents/planexe-execute.agent.md
test -f adapters/agent-host/agents/planexe-status.agent.md

echo "OK: all expected adapters exist."

echo
echo "=== Core specifications ==="

test -f core/planexe-bootstrap.md
test -f core/planexe-plan.md
test -f core/planexe-execute.md
test -f core/planexe-status.md

echo "OK: all core specifications exist."

echo
echo "=== Templates ==="

test -f templates/PLAN.md
test -f templates/PROGRESS.md
test -f templates/DECISIONS.md
test -f templates/STATE.json

echo "OK: all templates exist."

echo
echo "=== Documentation ==="

test -f docs/architecture.md
test -f docs/workflow.md
test -f docs/configuration.md
test -f docs/plan-format.md

echo "OK: all documentation files exist."

echo
echo "=== Installer syntax ==="

bash -n scripts/install.sh
echo "OK: scripts/install.sh syntax is valid."

echo
echo "=== Audit script syntax ==="

bash -n scripts/audit.sh
echo "OK: scripts/audit.sh syntax is valid."

echo
echo "=== Configuration examples ==="

grep -qF '"workspace"' docs/configuration.md
grep -qF '"mode"' docs/configuration.md
grep -qF '"repositories"' docs/configuration.md

echo "OK: configuration examples use the expected schema."

echo
echo "=== Audit completed successfully ==="
