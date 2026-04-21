# Mini PC Bootstrap Runbook

This runbook is for the first day the mini PC arrives.

## 1. Install Ubuntu Server

Use Ubuntu Server 24.04 LTS. Enable OpenSSH during install.

Recommended hostname:

```text
orion-mini
```

## 2. Base Packages

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl htop neovim build-essential ca-certificates gnupg ufw
```

## 3. SSH Check

From laptop/desktop:

```bash
ssh <user>@<mini-pc-ip>
```

## 4. Firewall

Keep this conservative until Tailscale is working.

```bash
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status
```

## 5. Docker

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker "$USER"
```

Log out and back in, then:

```bash
docker run hello-world
docker compose version
```

## 6. Tailscale

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
tailscale ip -4
```

## 7. Clone This Repo

```bash
mkdir -p ~/src
cd ~/src
git clone https://github.com/malikaperera/homelab.git
cd homelab
cp .env.example .env
```

## 8. Start Monitoring

```bash
docker compose -f infra/docker-compose.monitoring.yml up -d
docker compose -f infra/docker-compose.monitoring.yml ps
```

Open Grafana through Tailscale or LAN:

```text
http://<mini-pc-ip>:3000
```

## Success Criteria

- SSH works from laptop/desktop.
- Docker runs `hello-world`.
- Tailscale shows the mini PC online.
- Prometheus opens on port 9090.
- Grafana opens on port 3000.
- Node Exporter and cAdvisor targets are up in Prometheus.
