#!/bin/bash

# Ensure the required environment variables are set
if [ -z "$AZP_URL" ]; then
  echo 1>&2 "error: missing AZP_URL environment variable"
  exit 1
fi

if [ -z "$AZP_TOKEN" ]; then
  echo 1>&2 "error: missing AZP_TOKEN environment variable"
  exit 1
fi

if [ -z "$AZP_AGENT_NAME" ]; then
  AZP_AGENT_NAME=$(hostname)
fi

# Configure the Azure DevOps agent
./config.sh --unattended \
  --url "$AZP_URL" \
  --auth pat \
  --token "$AZP_TOKEN" \
  --pool 'Default' \
  --agent "$AZP_AGENT_NAME" \
  --acceptTeeEula

# Run the Azure DevOps agent
./svc.sh install
./svc.sh start

# Keep the container running
tail -f /dev/null
