# Azure DevOps Self-Hosted Agent – Project Instructions

This project runs a self-hosted Azure DevOps pipeline agent inside a Docker container (Alpine Linux, ARM64 musl).

## Stack

- **Runtime:** Alpine Linux (musl libc, ARM64 architecture)
- **Agent binary:** `vsts-agent-linux-musl-arm64` (pinned version in `start.sh`)
- **Orchestration:** Docker Compose with project name `work_agent`
- **Docker socket:** mounted from host (`/var/run/docker.sock`) so pipelines can run Docker commands

## Key files

| File | Purpose |
|------|---------|
| `dockerfile` | Builds the Alpine-based agent image |
| `start.sh` | Downloads, configures and starts the Azure DevOps agent at container start |
| `compose.yaml` | Docker Compose definition (project name: `work_agent`) |
| `.env` | Runtime secrets/config (not committed) — see `.env-example` |

## Environment variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `AZP_URL` | Yes | — | Azure DevOps org URL (`https://dev.azure.com/<ORG>`) |
| `AZP_TOKEN` | Yes | — | Personal Access Token with Agent Pools read/manage |
| `AZP_POOL` | No | `Default` | Agent pool name |

## Common commands

```bash
# Build and start
docker compose up -d --build

# View logs
docker compose logs -f

# Stop
docker compose down
```

## Conventions and constraints

- The base image must stay Alpine (`apk` for packages, not `apt`). Prefer `apk add --no-cache`.
- The agent binary URL and version in `start.sh` targets `linux-musl-arm64`. When upgrading, update only this URL/version line.
- Do NOT embed secrets in `dockerfile` or `compose.yaml`. All secrets go in `.env`.
- The container runs as root (`AGENT_ALLOW_RUNASROOT=1`) — required for Docker socket access.
- `restart: unless-stopped` is intentional; do not change it without good reason.
- When adding new tools to the agent (e.g., Node.js, Python), install them in the `dockerfile` via `apk add`, not in `start.sh`.
