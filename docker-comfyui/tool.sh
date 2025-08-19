#!/usr/bin/bash

# Create folders and set permissions
mkdir -p ./user-data/input ./user-data/output
mkdir -p ./user-data/models/checkpoints ./user-data/models/clip ./user-data/models/clip_vision ./user-data/models/configs ./user-data/models/controlnet ./user-data/models/diffusers ./user-data/models/diffusion_models ./user-data/models/embeddings ./user-data/models/gligen ./user-data/models/hypernetworks ./user-data/models/loras ./user-data/models/photomaker ./user-data/models/style_models ./user-data/models/text_encoders ./user-data/models/unet ./user-data/models/upscale_models ./user-data/models/vae ./user-data/models/vae_approx
chown -R 1000:1000 ./user-data
