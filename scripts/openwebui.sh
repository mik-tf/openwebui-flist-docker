#!/bin/bash

echo "[$(date)] Starting OpenWebUI initialization..."

# Wait for Docker daemon
echo "[$(date)] Waiting for Docker daemon to be ready..."
while ! docker info >/dev/null 2>&1; do
    echo "[$(date)] Docker not ready yet, waiting..."
    sleep 2
done
echo "[$(date)] Docker daemon is ready"

IMAGE_NAME="ghcr.io/open-webui/open-webui:ollama"

# Check if image exists
echo "[$(date)] Checking for existing OpenWebUI image..."
if ! docker images | grep -q "$IMAGE_NAME"; then
    echo "[$(date)] Image not found, loading from tar.gz..."
    
    # Check if tar.gz file exists
    if [ -f "/mnt/data/docker/images/open-webui.tar.gz" ]; then
        echo "[$(date)] Loading image from /mnt/data/docker/images/open-webui.tar.gz"
        docker load -i /mnt/data/docker/images/open-webui.tar.gz
        
        # Get the loaded image ID
        IMAGE_ID=$(docker images --format "{{.ID}}" | head -n 1)
        echo "[$(date)] Image loaded with ID: $IMAGE_ID"
        
        # Tag the loaded image
        echo "[$(date)] Tagging image as $IMAGE_NAME"
        docker tag $IMAGE_ID $IMAGE_NAME
        
        if [ $? -eq 0 ]; then
            echo "[$(date)] Image successfully tagged"
        else
            echo "[$(date)] ERROR: Failed to tag image"
            exit 1
        fi
    else
        echo "[$(date)] ERROR: open-webui.tar.gz not found in expected location"
        exit 1
    fi
else
    echo "[$(date)] Image $IMAGE_NAME already exists"
fi

# Start OpenWebUI container
echo "[$(date)] Starting OpenWebUI container..."
docker run \
  -d \
  -p 8080:8080 \
  -v ollama:/root/.ollama \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  $IMAGE_NAME

if [ $? -eq 0 ]; then
    echo "[$(date)] OpenWebUI container started successfully"
    
    # Wait a few seconds and check container status
    sleep 5
    if docker ps | grep -q "open-webui"; then
        echo "[$(date)] Container is running properly"
        docker logs open-webui
    else
        echo "[$(date)] ERROR: Container failed to start properly"
        docker logs open-webui
        exit 1
    fi
else
    echo "[$(date)] ERROR: Failed to start OpenWebUI container"
    exit 1
fi

echo "[$(date)] OpenWebUI initialization completed"