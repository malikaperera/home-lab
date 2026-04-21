# Malika Homelab

Self-hosted infrastructure for the ORION/Roderick agent ecosystem on a dedicated Ubuntu Server mini PC.

This repo is the source of truth for the home server setup, monitoring stack, container layout, and learning notes. It is deliberately boring infrastructure: open-source first, local-first, observable, and easy to rebuild.

## Target Architecture

- Mini PC: always-on infrastructure node running Ubuntu Server, Docker, Tailscale, dashboards, monitoring, Telegram bots, and lightweight agents.
- Desktop PC: heavy local inference node for larger Ollama/llama.cpp models.
- iPhone/laptop: control surfaces through Tailscale, Telegram, and web dashboards.

## Core Services

- Docker and Docker Compose
- Tailscale for private remote access
- Prometheus, Node Exporter, cAdvisor, and Grafana for observability
- Langfuse for LLM traces where useful
- n8n for workflow automation
- ORION/Roderick agent services as they are migrated from the Windows workstation

## Agent Model

The personal AI ecosystem keeps clear role boundaries:

- Roderick: orchestrator and user-facing chief of staff
- Merlin: research
- Forge: implementation, gated by approvals
- Sentinel: monitoring, validation, and safety
- Zuko: job search and application automation
- Atlas: teacher and system explainer
- Operator: business operations execution
- Venture: business research and opportunity analysis
- Orion: astrology intelligence, separate from infrastructure work

See [docs/orion-system-context.md](docs/orion-system-context.md) for the full operating context.

See [docs/server-desktop-split.md](docs/server-desktop-split.md) for the authoritative boundary between the always-on mini PC server and the Windows desktop after migration.

## First Boot Checklist

1. Install Ubuntu Server 24.04 LTS.
2. Enable SSH during install.
3. Log in from another machine: `ssh <user>@<mini-pc-ip>`.
4. Update base packages:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl htop neovim build-essential ca-certificates gnupg
```

5. Install Docker:

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker "$USER"
```

6. Reboot or log out/in, then test:

```bash
docker run hello-world
docker compose version
```

7. Install Tailscale:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

8. Start monitoring:

```bash
cp .env.example .env
docker compose -f infra/docker-compose.monitoring.yml up -d
```

## Repository Layout

```text
adblock/        DNS/ad-blocking services such as Pi-hole or AdGuard Home
automation/     n8n and workflow automation notes
docs/           architecture, runbooks, learning notes
infra/          Docker Compose and server bootstrap config
media/          future media/NAS notes
monitoring/     Prometheus and Grafana config
secrets/        local-only secret placeholders, never committed
```

## Principles

- Prefer free and open-source tools.
- Prefer local models and self-hosted services over paid APIs.
- Keep every critical service observable.
- Preserve human approval gates for code, spending, and system changes.
- Make Atlas explain major changes so the system doubles as a DevOps learning lab.
