#!/bin/bash

echo "CHCK VOLUME MOUNT\n"

if [ -z "$(ls -A /app)" ]; then
  cp -fra /app.org/* /app
    chmod +x /app/*.py
fi

exec "$@"
