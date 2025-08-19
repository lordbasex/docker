# ComfyUI (Dockerized)

This repository provides a Dockerized setup for [ComfyUI](https://github.com/comfyanonymous/ComfyUI), the most powerful and modular Stable Diffusion GUI and backend.
This build is intended for **NVIDIA GPUs only**.

---

## Image

Custom build:
```
docker build -t cnsoluciones/comfyui:latest .
```

---

## Prerequisites

- Docker Engine 20.10+
- Docker Compose v2+
- NVIDIA drivers installed on host
- NVIDIA Container Toolkit installed

---

## Quick Start

### Using Docker Compose

1. Clone this repository and move into the directory:
   ```bash
   git clone https://github.com/cnsoluciones/docker-comfyui.git
   cd docker-comfyui
   ```

2. Prepare data directories (models, input, output) and set correct permissions:
   ```bash
   ./tool.sh
   ```

   `tool.sh` creates the folders under `./user-data` and assigns UID/GID `1000:1000`.

3. Start the container:
   ```bash
   docker compose up -d
   ```

4. Open ComfyUI in your browser:
   [http://localhost:8188](http://localhost:8188)

---

## Data Persistence

The following host folders are mounted into the container:

- `./user-data/models` → `/app/comfyui/models`
- `./user-data/input` → `/app/comfyui/input`
- `./user-data/output` → `/app/comfyui/output`

All your checkpoints, inputs, and outputs will remain on the host system, even if the container is removed.

---

## Example: Run


```bash
docker run --gpus all --restart unless-stopped -p 8188:8188   -v ./user-data/models:/app/comfyui/models   -v ./user-data/input:/app/comfyui/input   -v ./user-data/output:/app/comfyui/output   -v /path/to/key.pem:/app/key.pem   -v /path/to/cert.pem:/app/cert.pem   --name comfyui -d cnsoluciones/comfyui:latest
```

---

## Logs & Debugging

Check container logs:
```bash
docker logs -f comfyui
```

Restart container after changes:
```bash
docker compose restart comfyui
```

---

## Notes

- Default port: **8188**
- Default user inside the container: **UID 1000 / GID 1000** (adjust in `docker-compose.yml` if needed).
- GPUs are passed with `gpus: all` (Compose v2 syntax).
- If your Compose version does not support `gpus: all`, switch to `device_requests` syntax.

---

## License

This repository builds on [ComfyUI](https://github.com/comfyanonymous/ComfyUI).
All rights belong to the original authors. This project only provides a containerized setup.
