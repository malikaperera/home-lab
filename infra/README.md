# Infrastructure

Compose files and server-level configuration live here.

Current files:

- `docker-compose.monitoring.yml`: Prometheus, Grafana, Node Exporter, and cAdvisor.

Future files:

- `docker-compose.automation.yml`: n8n, Redis, Postgres.
- `docker-compose.agents.yml`: ORION/Roderick migrated services.
- `docker-compose.llm.yml`: Ollama or llama.cpp services if hosted on the mini PC.
