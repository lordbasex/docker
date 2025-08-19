#!/usr/bin/env bash
set -euo pipefail

# Config por entorno con defaults
HOST_BIND="${HOST_BIND:-0.0.0.0}"
PORT="${PORT:-8188}"
CORS="${CORS:-*}"

# Activar venv (ajustá si tu venv vive en /app/comfyui/venv)
if [ -d "/app/venv" ]; then
  . /app/venv/bin/activate
else
  . /app/comfyui/venv/bin/activate
fi

# Asegurar directorios (evita PermissionError del nodo Load3D)
mkdir -p /app/comfyui/input/3d /app/comfyui/output /app/comfyui/models
mkdir -p /app/comfyui/models/checkpoints /app/comfyui/models/clip /app/comfyui/models/clip_vision /app/comfyui/models/configs /app/comfyui/models/controlnet /app/comfyui/models/diffusers /app/comfyui/models/diffusion_models /app/comfyui/models/embeddings /app/comfyui/models/gligen /app/comfyui/models/hypernetworks /app/comfyui/models/loras /app/comfyui/models/photomaker /app/comfyui/models/style_models /app/comfyui/models/text_encoders /app/comfyui/models/unet /app/comfyui/models/upscale_models /app/comfyui/models/vae /app/comfyui/models/vae_approx

# (Opcional) forzar permisos si el volumen viene como root
chown -R 1000:1000 /app/comfyui || true

cd /app/comfyui

# Armar flags por defecto si no te pasaron --listen/--port
EXTRA_ARGS=()
case " $* " in
  *" --listen "* ) : ;;  # ya viene
  * ) EXTRA_ARGS+=("--listen" "$HOST_BIND") ;;
esac
case " $* " in
  *" --port "* ) : ;;
  * ) EXTRA_ARGS+=("--port" "$PORT") ;;
esac
case " $* " in
  *"--enable-cors-header"* ) : ;;
  * ) EXTRA_ARGS+=("--enable-cors-header" "$CORS") ;;
esac

# Ejecutar respetando tus "$@" + defaults
exec python main.py "${EXTRA_ARGS[@]}" "$@"
