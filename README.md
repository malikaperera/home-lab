# Homelab

Self-hosted infrastructure and AI automation lab built around a dedicated Ubuntu Server mini PC, a separate compute desktop, and a modular container stack for observability, workflow automation, and agent coordination.

This repository documents the system design, service layout, and operational practices behind a rebuildable homelab. The focus is practical: open-source first, local-first, observable, and simple to recover.

## Project Summary

Built a self-hosted infrastructure platform for AI-assisted workflows, monitoring, and automation. The system separates always-on services from heavy compute, uses containerized services for repeatable deployment, and includes observability, remote access, and agent orchestration for day-to-day operations.

## Tech Stack

- Ubuntu Server
- Docker and Docker Compose
- Tailscale
- Prometheus, Grafana, Node Exporter, cAdvisor, Loki, Promtail, Alertmanager
- n8n
- Langfuse
- Ollama and llama.cpp
- Telegram bots and approval workflows

## Outcome

- Repeatable infrastructure layout with clear separation of concerns
- Centralized visibility through dashboards and alerts
- Remote administration over private networking and SSH
- Agent-based task routing for monitoring, research, and automation
- Documentation that supports recovery, onboarding, and future expansion

## Architecture

- Mini PC: always-on infrastructure node running Ubuntu Server, Docker, Tailscale, dashboards, monitoring, Telegram bots, and lightweight agents.
- Desktop PC: heavy local inference node for larger Ollama and llama.cpp workloads.
- iPhone and laptop: control surfaces through Tailscale, Telegram, SSH, and web dashboards.

## Core Services

- Docker and Docker Compose
- Tailscale for private remote access
- Prometheus, Node Exporter, cAdvisor, and Grafana for observability
- Langfuse for LLM traces where useful
- n8n for workflow automation
- Multi-agent orchestration services for task routing, monitoring, and approvals

## Showcase Highlights

- Self-hosted infrastructure with a clear separation between always-on services and heavy compute
- Observability stack with metrics, dashboards, and alerting
- Containerized services with repeatable bootstrap and recovery steps
- AI workflow plumbing for agent coordination, telemetry, and automation
- Documentation-first design that makes the system easier to operate and explain

## Agent Model

The AI ecosystem keeps clear role boundaries:

- Roderick: orchestrator and user-facing chief of staff
- Merlin: research
- Forge: implementation, gated by approvals
- Sentinel: monitoring, validation, and safety
- Zuko: job search and application automation
- Atlas: teacher and system explainer
- Operator: business operations execution
- Venture: business research and opportunity analysis

See [docs/agent-system-context.md](docs/agent-system-context.md) for the full operating context.

See [docs/server-desktop-split.md](docs/server-desktop-split.md) for the authoritative boundary between the always-on mini PC server and the Windows desktop after migration.

See [docs/codex-server-setup.md](docs/codex-server-setup.md) to install Codex CLI on the server for interactive maintenance and migration work.

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
