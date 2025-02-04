#!/bin/bash

# Wait for Docker daemon
while ! docker info >/dev/null 2>&1; do
    echo "Waiting for Docker..."
    sleep 2
done

# Start OpenWebUI container
docker run \
  -d \
  -p 8080:8080 \
  -v ollama:/root/.ollama \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:ollama