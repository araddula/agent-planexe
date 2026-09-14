#!/usr/bin/env bash

set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_DIR="${HOME}/agent-planexe"
AGENT_HOST_DIR="${HOME}/.copilot/agents"

if [ "${PLANEXE_INSTALL_TEST:-0}" = "1" ]; then
INSTALL_DIR="${PLANEXE_TEST_DIR:-${TMPDIR:-/tmp}/agent-planexe-test}"
fi

echo "Installing Planexe..."
echo
echo "Source:      ${SOURCE_DIR}"
echo "Destination: ${INSTALL_DIR}"
echo

mkdir -p "${INSTALL_DIR}"

echo "Copying Planexe files..."

cp -R "${SOURCE_DIR}/core" "${INSTALL_DIR}/"
cp -R "${SOURCE_DIR}/adapters" "${INSTALL_DIR}/"
cp -R "${SOURCE_DIR}/templates" "${INSTALL_DIR}/"
cp -R "${SOURCE_DIR}/docs" "${INSTALL_DIR}/"

if [ -f "${SOURCE_DIR}/README.md" ]; then
cp "${SOURCE_DIR}/README.md" "${INSTALL_DIR}/"
fi

if [ -f "${SOURCE_DIR}/LICENSE" ]; then
cp "${SOURCE_DIR}/LICENSE" "${INSTALL_DIR}/"
fi

echo
echo "Planexe installed at:"
echo "  ${INSTALL_DIR}"

echo
echo "Available core agents:"
echo "  ${INSTALL_DIR}/core/planexe-bootstrap.md"
echo "  ${INSTALL_DIR}/core/planexe-plan.md"
echo "  ${INSTALL_DIR}/core/planexe-execute.md"
echo "  ${INSTALL_DIR}/core/planexe-status.md"

echo
echo "VS Code prompt adapters:"
echo "  ${INSTALL_DIR}/adapters/vscode/prompts/"

echo
echo "Agent Host adapters:"
echo "  ${INSTALL_DIR}/adapters/agent-host/agents/"

if [ "${PLANEXE_INSTALL_TEST:-0}" = "1" ]; then
echo
echo "Skipping Agent Host user-level installation during installer test."
else
echo
echo "Installing Agent Host adapters..."

mkdir -p "${AGENT_HOST_DIR}"
cp "${SOURCE_DIR}/adapters/agent-host/agents/"*.agent.md "${AGENT_HOST_DIR}/"

echo
echo "Agent Host agents installed at:"
echo "  ${AGENT_HOST_DIR}"

fi

echo
if [ -f "${INSTALL_DIR}/config.json" ]; then
echo "Global configuration:"
echo "  ${INSTALL_DIR}/config.json"
else
echo "Global configuration:"
echo "  Not configured"
fi

echo
echo "Existing configuration and external workspaces were preserved."
echo "Installation completed."
