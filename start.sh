#!/bin/bash
set -e

AZP_POOL=${AZP_POOL:-Default}

if [ -z "$AZP_URL" ]; then
  echo "Missing AZP_URL"
  exit 1
fi

if [ -z "$AZP_TOKEN" ]; then
  echo "Missing AZP_TOKEN"
  exit 1
fi

export AGENT_ALLOW_RUNASROOT="1"

mkdir -p /azp/agent
cd /azp/agent

# Detect architecture for multi-arch support
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  AGENT_ARCH="x64" ;;
  aarch64) AGENT_ARCH="arm64" ;;
  armv7l)  AGENT_ARCH="arm" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# Get latest agent version from GitHub API
echo "Detecting latest Azure DevOps agent version..."
AGENT_VERSION=$(curl -s https://api.github.com/repos/microsoft/azure-pipelines-agent/releases/latest \
  | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

if [ -z "$AGENT_VERSION" ]; then
  echo "Failed to detect agent version, using fallback"
  AGENT_VERSION="4.269.0"
fi

AGENT_URL="https://download.agent.dev.azure.com/agent/${AGENT_VERSION}/vsts-agent-linux-musl-${AGENT_ARCH}-${AGENT_VERSION}.tar.gz"

echo "Downloading Azure DevOps agent v${AGENT_VERSION} (${AGENT_ARCH})..."

curl -L --retry 5 --fail "$AGENT_URL" -o agent.tar.gz

tar zxvf agent.tar.gz
rm agent.tar.gz

echo "Configuring agent..."

./config.sh --unattended \
  --url "$AZP_URL" \
  --auth pat \
  --token "$AZP_TOKEN" \
  --pool "$AZP_POOL" \
  --agent "$(hostname)" \
  --replace \
  --acceptTeeEula

echo "Starting agent..."

./run.sh
