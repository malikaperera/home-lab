# Codex Server Setup

This sets up Codex CLI on the ORION mini PC/server so Codex can work there in the same practical role as Claude: an interactive coding agent inside the server environment.

Codex on the server is for development, maintenance, migration work, and audits. It is not a replacement for the ORION runtime agents. Roderick, Forge, Zuko, Sentinel, Langfuse, and the dashboard still run as normal services.

## One-Time SSH Access

From the server console, add the desktop public key so Codex on the desktop can SSH into the server:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
printf '%s\n' 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOztzNeS/1n5G4dEnigCl2UdE48YgdXX8KvWpKEYaqto amali@DESKTOP-N54LKD6' >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

Then test from the desktop:

```powershell
ssh <server-user>@100.101.76.104 "uname -a && whoami"
```

Use the real Linux username on the server.

## Install Codex CLI

On the server:

```bash
mkdir -p ~/src
cd ~/src
git clone https://github.com/malikaperera/homelab.git
cd homelab
bash scripts/install-codex-cli.sh
```

The installer:

- installs base build tools
- installs Node.js 22 if the server Node version is missing or too old
- installs the official `@openai/codex` CLI globally
- writes server-specific ORION guidance into `~/.codex/AGENTS.md`

## Sign In

Run:

```bash
codex
```

Complete the sign-in flow.

After sign-in, run Codex from the repo you want to work on:

```bash
cd ~/src/telegram-claude-agent
codex
```

## Operating Rules

- Use Codex interactively over SSH or from a terminal on the server.
- Do not run Codex as a background daemon.
- Do not let Codex start duplicate desktop/server stacks.
- For ORION migration work, read `docs/server-desktop-split.md` first.
- For runtime service changes, prefer Git commits and Docker Compose changes over manual drift.

## Verification

```bash
codex --version
node --version
npm --version
git --version
docker compose version
```

Codex is ready when it opens from `~/src/telegram-claude-agent` and can see the repo, Git status, Docker Compose files, and homelab docs.

