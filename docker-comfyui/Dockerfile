# Base with CUDA 12.6; cudnn is not required if you use torch wheels
FROM nvidia/cuda:12.6.2-base-ubuntu22.04 AS base

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Minimal packages (without pulling system CUDA libraries)
RUN apt-get update && apt-get install -y --no-install-recommends \
      python3 python3-venv python3-pip git wget ffmpeg \
      libgl1-mesa-dev libglib2.0-0 libsm6 libxrender1 libxext6 \
    && rm -rf /var/lib/apt/lists/*

# Non-privileged user
RUN groupadd -g 1000 comfyui && \
    useradd -m -s /bin/bash -u 1000 -g 1000 --home /app comfyui

# App
USER comfyui
WORKDIR /app

# Clone ComfyUI
RUN git clone --depth=1 https://github.com/comfyanonymous/ComfyUI.git /app/comfyui

# Python environment + dependencies
WORKDIR /app/comfyui
RUN python3 -m venv /app/venv && \
    . /app/venv/bin/activate && \
    pip install --upgrade pip && \
    # Stable PyTorch/cu124
    pip install --index-url https://download.pytorch.org/whl/cu124 \
        torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 && \
    # Remaining ComfyUI requirements
    pip install -r requirements.txt && \
    # Optional useful extras
    pip install timm simpleeval accelerate

# Create folders and set permissions (fixes Load3D PermissionError)
RUN mkdir -p /app/comfyui/input/3d /app/comfyui/output /app/comfyui/models && \
    chown -R 1000:1000 /app

# Entrypoint
COPY --chown=comfyui:comfyui entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 8188
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=5 \
  CMD wget -qO- http://127.0.0.1:8188 || exit 1

ENTRYPOINT ["/app/entrypoint.sh"]
