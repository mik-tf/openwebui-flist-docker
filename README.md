<h1> OpenWebUI Deployment with Ollama Flist</h1>

<h2> Table of Contents </h2>

- [Introduction](#introduction)
- [Directory Structure](#directory-structure)
- [Create the Docker Image](#create-the-docker-image)
- [Convert the Docker Image to Zero-OS FList](#convert-the-docker-image-to-zero-os-flist)
- [TFGrid Deployment](#tfgrid-deployment)
  - [Playground Steps](#playground-steps)
- [Conclusion](#conclusion)

***

## Introduction

This project provides a self-contained deployment of **OpenWebUI** and **Ollama** on the ThreeFold Grid, using a micro VM. The deployment is managed via **zinit** for automatic service management and includes:

- Preconfigured firewall rules with **UFW**
- Secure SSH server configuration
- **Ollama** for local LLM serving
- **OpenWebUI** for a web-based interface
- Self-healing services via **zinit**

The deployment automatically provisions:
- Secure SSH access
- OpenWebUI on port `8080`
- Ollama on port `11434`
- Persistent storage for Ollama models and WebUI data

***

## Directory Structure

```
.
├── Dockerfile
├── README.md
├── scripts
│   ├── ollama.sh
│   ├── openwebui.sh
│   ├── sshd_init.sh
│   └── ufw_init.sh
└── zinit
    ├── ollama.yaml
    ├── openwebui.yaml
    ├── sshd.yaml
    ├── ssh-init.yaml
    ├── ufw-init.yaml
    └── ufw.yaml
```

- **`scripts/`**: Contains initialization and service scripts.
- **`zinit/`**: Contains **zinit** service configurations for managing services.
- **`Dockerfile`**: Defines the Docker image with all dependencies and configurations.

***

## Create the Docker Image

To create the Docker image:

1. Clone this repository:
   ```bash
   git clone https://github.com/mik-tf/openwebui-flist
   cd openwebui-flist
   ```

2. Pull and compressor the Ollama image
   ```
   docker pull ghcr.io/open-webui/open-webui:ollama
   docker save ghcr.io/open-webui/open-webui:ollama > open-webui.tar
   ```

3. Build the Docker image:
   ```bash
   docker build -t <your-dockerhub-username>/openwebui-ollama-tfgrid .
   ```

4. Push to Docker Hub:
   ```bash
   docker push <your-dockerhub-username>/openwebui-ollama-tfgrid
   ```

***

## Convert the Docker Image to Zero-OS FList

1. Use the [TF Hub Docker Converter](https://hub.grid.tf/docker-convert).
2. Enter your Docker image name:
   ```text
   <your-dockerhub-username>/openwebui-ollama-tfgrid:latest
   ```
3. Convert and get your FList URL (example):
   ```text
   https://hub.grid.tf/<your-3bot>/openwebui-ollama-tfgrid-latest.flist
   ```

***

## TFGrid Deployment

### Playground Steps

1. Go to [ThreeFold Playground](https://play.grid.tf).
2. Create a Micro VM:
   - **VM Image**: Paste your FList URL.
   - **Entry Point**: `/sbin/zinit init` (default).
   - **Resources**: Minimum 2 vCPU, 4GB RAM, 10GB disk.
3. Deploy.
4. Set a gateway domain with port 8080 and access OpenWeb UI with it

***

## Conclusion

This FList provides a self-contained deployment of **OpenWebUI** and **Ollama** on the ThreeFold Grid with:
- Automatic service management via **zinit**
- Secure firewall configuration with **UFW**
- SSH access for maintenance
- Persistent storage for models and data
- Easy deployment via Docker and TF Grid

Deploy and enjoy a fully functional OpenWebUI and Ollama setup on the decentralized ThreeFold Grid!