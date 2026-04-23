.PHONY: monitoring-up monitoring-down monitoring-logs \
        adblock-up adblock-down \
        infra-up infra-down \
        up down ps logs

ENV_FILE := --env-file .env

## Monitoring stack (Prometheus, Grafana, Loki, Promtail, Alertmanager, cAdvisor, Node Exporter)
monitoring-up:
	docker compose $(ENV_FILE) -f infra/docker-compose.monitoring.yml up -d

monitoring-down:
	docker compose $(ENV_FILE) -f infra/docker-compose.monitoring.yml down

monitoring-logs:
	docker compose $(ENV_FILE) -f infra/docker-compose.monitoring.yml logs -f

## Ad blocker (Pi-hole)
adblock-up:
	docker compose $(ENV_FILE) -f adblock/docker-compose.yml up -d

adblock-down:
	docker compose $(ENV_FILE) -f adblock/docker-compose.yml down

## Infra services (Uptime Kuma)
infra-up:
	docker compose $(ENV_FILE) -f infra/docker-compose.infra.yml up -d

infra-down:
	docker compose $(ENV_FILE) -f infra/docker-compose.infra.yml down

## Bring everything up
up: monitoring-up adblock-up infra-up

## Bring everything down
down: monitoring-down adblock-down infra-down

## Status of all containers
ps:
	docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

## Tail logs for a specific container: make logs c=grafana
logs:
	docker logs -f $(c)
