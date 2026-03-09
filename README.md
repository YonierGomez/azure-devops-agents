# Azure DevOps Self-Hosted Agent (Docker)

[![GitHub release](https://img.shields.io/github/v/release/YonierGomez/azure-devops-agents?style=flat-square&logo=github)](https://github.com/YonierGomez/azure-devops-agents/releases/latest)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/neytor/azure-devops-agent?style=flat-square&logo=docker)](https://hub.docker.com/r/neytor/azure-devops-agent)
[![Docker Image Size](https://img.shields.io/docker/image-size/neytor/azure-devops-agent/latest?style=flat-square&logo=docker)](https://hub.docker.com/r/neytor/azure-devops-agent)
[![Alpine](https://img.shields.io/badge/Alpine-Linux-0D597F?style=flat-square&logo=alpine-linux&logoColor=white)](https://alpinelinux.org)
[![amd64](https://img.shields.io/badge/linux-amd64-blue?style=flat-square&logo=linux)](https://hub.docker.com/r/neytor/azure-devops-agent)
[![arm64](https://img.shields.io/badge/linux-arm64-blue?style=flat-square&logo=linux)](https://hub.docker.com/r/neytor/azure-devops-agent)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-☕-yellow?style=flat-square&logo=buy-me-a-coffee)](https://buymeacoffee.com/yoniergomez)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-❤️-ea4aaa?style=flat-square&logo=github-sponsors)](https://github.com/sponsors/YonierGomez)

Self-hosted Azure DevOps agent running in a Docker container based on Alpine Linux with multi-architecture support.

## Requirements

- Docker and Docker Compose
- An Azure DevOps Personal Access Token (PAT) with **Agent Pools (Read & Manage)** permissions

## Getting started

### 1. Create the environment file

```bash
cat > .env <<EOF
AZP_URL=https://dev.azure.com/YOUR_ORG
AZP_TOKEN=YOUR_PAT
AZP_POOL=Default
EOF
```

| Variable    | Required | Description                                             | Default   |
|-------------|----------|---------------------------------------------------------|-----------|
| `AZP_URL`   | Yes      | Your organization URL (`https://dev.azure.com/YOUR_ORG`)| —         |
| `AZP_TOKEN` | Yes      | Personal Access Token (PAT)                             | —         |
| `AZP_POOL`  | No       | Agent Pool name                                         | `Default` |

### 2. Create the `compose.yaml`

```yaml
name: work_agent

services:
  azure-agent:
    image: neytor/azure-devops-agent:latest
    restart: unless-stopped
    env_file:
      - .env
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

### 3. Start the agent

```bash
docker compose up -d
```

### 4. Verify it's running

```bash
docker compose logs -f
```

You should see `Starting agent...` followed by a successful connection to the Azure DevOps pool.

### Scale to multiple agents

```bash
# Spin up 3 agents in parallel
docker compose up -d --scale azure-agent=3
```

Each container registers with a unique name (its hostname) in the Azure DevOps pool.

### Useful commands

```bash
# Restart agents
docker compose restart

# Stop without removing
docker compose stop

# Stop and remove
docker compose down

# Rebuild image and start
docker compose up -d --build

# Check container status
docker compose ps
```

## Using docker run

If you prefer not to use Docker Compose:

```bash
docker run -d \
  --name azure-agent \
  --restart unless-stopped \
  -e AZP_URL=https://dev.azure.com/YOUR_ORG \
  -e AZP_TOKEN=YOUR_PAT \
  -e AZP_POOL=Default \
  -v /var/run/docker.sock:/var/run/docker.sock \
  neytor/azure-devops-agent:latest
```

View logs:

```bash
docker logs -f azure-agent
```

Stop and remove:

```bash
docker stop azure-agent && docker rm azure-agent
```

## Supported architectures

| Arch   | Platform       | Examples                                    |
|--------|----------------|---------------------------------------------|
| x86_64 | `linux/amd64`  | Servers, PCs, VMs                           |
| ARM64  | `linux/arm64`  | SBCs (Raspberry Pi, Orange Pi, etc.), Apple Silicon, AWS Graviton |

## Support

[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-☕-yellow?style=flat-square&logo=buy-me-a-coffee)](https://buymeacoffee.com/yoniergomez)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-❤️-ea4aaa?style=flat-square&logo=github-sponsors)](https://github.com/sponsors/YonierGomez)

## Docker Hub

```bash
docker pull neytor/azure-devops-agent:latest
```

Repository: [hub.docker.com/r/neytor/azure-devops-agent](https://hub.docker.com/r/neytor/azure-devops-agent)

## GitHub

Automatic releases with upstream changelog whenever Microsoft publishes a new agent version.

Repository: [github.com/YonierGomez/azure-devops-agents](https://github.com/YonierGomez/azure-devops-agents)

## Author

Made by [Yonier Gomez](https://yonier.com) · [GitHub](https://github.com/YonierGomez)

## License

[MIT](LICENSE)
