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

echo "Downloading Azure DevOps agent..."

curl -L --retry 5 --fail \
https://download.agent.dev.azure.com/agent/4.269.0/vsts-agent-linux-musl-arm64-4.269.0.tar.gz \
-o agent.tar.gz

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