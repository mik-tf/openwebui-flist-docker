#!/bin/bash

# Wait for Docker daemon
while ! docker info >/dev/null 2>&1; do
    echo "Waiting for Docker..."
    sleep 2
done

IMAGE_NAME="ghcr.io/open-webui/open-webui:ollama"

# Remove existing container if it exists
docker rm -f open-webui || true

# Load and tag image if not already loaded
if ! docker images | grep -q "$IMAGE_NAME"; then
    docker load -i /mnt/data/docker/images/open-webui.tar
    # Get the loaded image ID
    IMAGE_ID=$(docker images --format "{{.ID}}" | head -n 1)
    # Tag the loaded image with the correct name
    docker tag $IMAGE_ID $IMAGE_NAME
fi

# Start OpenWebUI container
docker run -d -p 8080:8080 -v ollama:/root/.ollama -v open-webui:/app/backend/data --name open-webui --restart always $IMAGE_NAME