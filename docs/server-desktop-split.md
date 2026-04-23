# ORION Server/Desktop Split

This is the source of truth for what runs on the always-on mini PC server versus what stays on the Windows desktop after migration.

The goal is simple: the server is the home of ORION. The desktop becomes an optional acceleration box and personal workstation, not a second copy of the system.

## Operating Principle

The mini PC server is optimized for availability, fast coordination, and continuous background progress. It should make Roderick, Orion, and Zuko feel responsive to Malika at all times.

The desktop PC is the heavy reasoning lane. When the desktop is online, large-model work should route there. When it is offline, heavyweight reasoning should be queued, summarized, delayed, or processed slowly in the background on the server without degrading user-facing responsiveness.

The server can spend time, but it cannot spend responsiveness. Background LLM work must be bounded by concurrency, prompt size, token budget, and timeout rules so direct Telegram/dashboard interactions remain quick.

## Absolute Rules

- Run only one production ORION/Roderick stack at a time.
- Run only one writer against `data/roderick.db`.
- Run only one Zuko automation instance, otherwise job scans and applications can duplicate.
- Run only one Forge worker, otherwise code patches and approval state can conflict.
- After server cutover, do not run the dashboard, API, Roderick, Forge, Zuko, Sentinel, Langfuse, or databases on the desktop except during an explicit rollback.
- Rebuild containers from Git on the server. Do not copy Windows Docker images, virtual environments, build outputs, logs, or temporary Forge artifacts.
- Preserve migrated state: `data/roderick.db`, `memory/`, `data/browser_profiles/` where usable, CV/resume files, and approved config.

## Mini PC Server: Runs Full Time

The mini PC is the always-on infrastructure node. It should run Ubuntu Server, Docker, Tailscale, and the long-lived ORION services.

Full-time services:

- Docker Engine and Docker Compose
- Tailscale
- `telegram-claude-agent` stack:
  - `roderick`
  - `forge`
  - `api`
  - `dashboard`
  - `zuko`
  - `langfuse`
  - `langfuse-db`
- Agent runtime state:
  - Roderick orchestration
  - Sentinel validation and monitoring
  - Merlin research scheduling
  - Atlas learning and explanations
  - Operator business operations
  - Venture business research
  - Zuko job search and application automation
  - Forge approved build/deploy work
- Monitoring:
  - Prometheus
  - Grafana
  - Node Exporter
  - cAdvisor
  - later: Loki, Promtail, Alertmanager, Uptime Kuma
- Optional always-on local model fallback:
  - Ollama on the mini PC for lightweight models such as `qwen3:4b`, `qwen3:8b`, `phi3:mini`, or another small CPU-friendly model.

Server-local LLM work should prefer:

- `qwen3:4b` for Roderick/Orion/Zuko user-facing coordination.
- `qwen3:8b` for bounded background research/planning when desktop GPU is unavailable.
- `qwen2.5-coder:7b` for local code/validation work.

Avoid making heavy desktop models required for server boot or normal operation.

Later server services can include Pi-hole or AdGuard Home, Portainer, n8n, media services, and the separate ORION astrology stack.

## Desktop PC: Optional Heavy Compute Only

The Windows desktop should not be required for the system to function.

Allowed desktop responsibilities:

- Ollama large model acceleration using the GPU.
- Large models such as `qwen3:14b`, `qwen3:30b`, and `qwen2.5-coder:14b`, if the hardware can run them reliably.
- Deep reasoning queues that are not urgent for direct user engagement.
- Music production and personal workstation use.
- Temporary Claude/Codex interactive development sessions.
- Emergency rollback only, after the server stack is stopped.

Not allowed on desktop after cutover:

- Long-running dashboard
- Long-running API
- Long-running Roderick stack
- Long-running Forge/Zuko/Sentinel workers
- Langfuse database
- A second `roderick.db` writer

## Control Devices

iPhone and laptop are control surfaces only.

They should access ORION through:

- Telegram bots
- Tailscale
- Dashboard URL through Tailscale, for example `http://<server-tailscale-ip>:3000`
- SSH into the server when needed

They should not host persistent ORION services.

## LLM Routing

The server should be able to continue operating even when the desktop is off.

Recommended server `.env` pattern:

```env
OLLAMA_HOST=http://host.docker.internal:11434
OLLAMA_PRIMARY_HOST=http://<desktop-tailscale-ip>:11434
OLLAMA_FALLBACK_HOST=http://host.docker.internal:11434
```

Meaning:

- Primary: desktop GPU Ollama, when the desktop is online.
- Fallback: mini PC Ollama, always available but slower.
- If the desktop is offline, agents must degrade gracefully instead of failing.
- Direct interaction agents must not wait indefinitely for desktop-heavy reasoning. They should acknowledge, queue, and continue.

On Linux Docker, `host.docker.internal` must be mapped through `extra_hosts` in Compose. The `telegram-claude-agent` compose file already supports this pattern.

## Migration Cutover

1. On the desktop, stop new agent work and wait for critical approvals or applications to finish.
2. Stop the desktop stack:

```bash
docker compose down
```

3. Copy only durable state to the server:

```text
data/roderick.db
memory/
data/browser_profiles/
CV/resume files
.env values, carefully recreated on Linux
```

4. Do not copy:

```text
.venv/
node_modules/
__pycache__/
.pytest_cache/
logs/
screenshots/
temporary Forge artifacts
Docker images
Windows-only browser cache if it fails on Linux
```

5. On the server, clone or pull the repos.
6. Configure `.env` from `.env.example`.
7. Set `DOCKER_GID` on Linux:

```bash
getent group docker
```

Use the numeric group id in `.env`.

8. Start the server stack:

```bash
docker compose up -d --build
```

9. Verify the server stack before using it as production.
10. Keep the desktop stack off.

## Verification Checklist

On the server:

```bash
docker compose ps
```

Expected:

- `roderick` is running.
- `forge` is running.
- `api` is running.
- `dashboard` is running.
- `zuko` is running.
- `langfuse-db` is healthy or starting.
- `langfuse` is reachable after its normal startup delay.

Health checks:

- API responds at `http://<server-tailscale-ip>:8000/health`.
- Dashboard opens from iPhone at `http://<server-tailscale-ip>:3000`.
- Roderick Telegram `/status` responds.
- Zuko dedicated Telegram bot responds to `/status` or `/scan`.
- Forge can access the Docker socket when approved work needs deployment.
- Sentinel can validate pending work without getting stuck on multiple validations.
- Existing task counts, approvals, memory files, and job records survived the migration.
- No dashboard/API/Roderick/Zuko/Forge containers are running on the desktop at the same time.

## Rollback

Rollback is allowed, but only one side may run the production stack.

To rollback:

1. Stop the server stack:

```bash
docker compose down
```

2. Only after the server is stopped, start the desktop stack.
3. Record why rollback happened and what needs to be fixed before the next cutover.

Never run server and desktop production stacks at the same time.
