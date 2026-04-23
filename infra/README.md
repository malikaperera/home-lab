# Infrastructure

Compose files and server-level configuration live here.

Current files:

- `docker-compose.monitoring.yml`: Prometheus, Grafana, Node Exporter, and cAdvisor.

Future files:

- `docker-compose.automation.yml`: n8n, Redis, Postgres.
- `docker-compose.agents.yml`: primary agent services.
- `docker-compose.llm.yml`: Ollama or llama.cpp services if hosted on the mini PC.
- `docker-compose.media.yml`: generic media services, if needed later.
