# Azure DevOps Self-Hosted Agent (Docker)

Agente self-hosted de Azure DevOps ejecutado en un contenedor Docker basado en Alpine Linux (ARM64).

## Requisitos

- Docker y Docker Compose
- Un token de acceso personal (PAT) de Azure DevOps con permisos de **Agent Pools (Read & Manage)**
- Acceso a una organización de Azure DevOps

## Configuración

1. Copia el archivo de ejemplo de variables de entorno:

   ```bash
   cp .env-example .env
   ```

2. Edita `.env` con tus valores:

   | Variable    | Descripción                                      | Valor por defecto |
   |-------------|--------------------------------------------------|-------------------|
   | `AZP_URL`   | URL de tu organización (`https://dev.azure.com/TU_ORG`) | —                 |
   | `AZP_TOKEN` | Personal Access Token (PAT)                      | —                 |
   | `AZP_POOL`  | Nombre del Agent Pool                            | `Default`         |

## Uso

Inicia el agente:

```bash
docker compose up -d --build
```

Revisa los logs:

```bash
docker compose logs -f
```

Detén el agente:

```bash
docker compose down
```

## Arquitectura

- **Base image:** Alpine Linux (ligera, ~5 MB)
- **Plataforma:** `linux/arm64` (musl)
- **Docker-in-Docker:** El socket de Docker del host se monta en el contenedor (`/var/run/docker.sock`), lo que permite al agente ejecutar comandos Docker desde los pipelines.
- **Restart policy:** `unless-stopped` — el contenedor se reinicia automáticamente salvo que se detenga manualmente.

## Estructura del proyecto

```
.
├── .env-example   # Variables de entorno de ejemplo
├── compose.yaml   # Docker Compose
├── dockerfile     # Imagen del agente
└── start.sh       # Script de inicio: descarga, configura y ejecuta el agente
```
