#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing Codex CLI for this server"

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "This installer is intended for the Ubuntu/Linux server." >&2
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo is required for package installation." >&2
  exit 1
fi

sudo apt-get update
sudo apt-get install -y ca-certificates curl git build-essential

node_major=0
if command -v node >/dev/null 2>&1; then
  node_major="$(node -p "process.versions.node.split('.')[0]" 2>/dev/null || echo 0)"
fi

if [[ "${node_major}" -lt 20 ]]; then
  echo "==> Installing Node.js 22 LTS through NodeSource"
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi

echo "==> Node: $(node --version)"
echo "==> npm:  $(npm --version)"

echo "==> Installing official OpenAI Codex CLI"
sudo npm install -g @openai/codex@latest

mkdir -p "$HOME/.codex"

cat > "$HOME/.codex/AGENTS.md" <<'EOF'
# Server Codex Context

This machine is the always-on agent server.

Before changing services, read:

- the repository's `docs/server-desktop-split.md`
- the repository's `docs/agent-system-context.md`

Important boundaries:

- The server owns the dashboard, API, agents, Langfuse, and persistent databases.
- The desktop is optional GPU acceleration only after migration.
- Do not run duplicate service stacks on both machines.
- Preserve data/roderick.db, memory/, browser profiles, and CV files.
- Prefer safe, observable changes with clear rollback notes.
EOF

echo
echo "==> Codex installed:"
codex --version || true
echo
echo "Next steps:"
echo "1. Run: codex"
echo "2. Complete the ChatGPT/OpenAI sign-in flow."
echo "3. Then run Codex from the repo you want to work in, for example:"
echo "   cd \"\$(git rev-parse --show-toplevel)\" && codex"
