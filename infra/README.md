# Infrastructure

Compose files and server-level configuration live here.

Current files:

- `docker-compose.monitoring.yml`: Prometheus, Grafana, Node Exporter, and cAdvisor.
- `docker-compose.plex.yml`: Plex, qBittorrent, Radarr, Sonarr, and Jellyseerr. Runtime config/data paths intentionally remain under `/home/malika/docker/plex`, `/mnt/plex`, and `/home/malika/orion-media` so migration into this repo does not reset service state.

Future files:

- `docker-compose.automation.yml`: n8n, Redis, Postgres.
- `docker-compose.agents.yml`: ORION/Roderick migrated services.
- `docker-compose.llm.yml`: Ollama or llama.cpp services if hosted on the mini PC.
