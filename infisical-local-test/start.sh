#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if [[ ! -f .env.local ]]; then
  umask 077
  cat > .env.local <<EOF
POSTGRES_PASSWORD=$(openssl rand -hex 24)
ENCRYPTION_KEY=$(openssl rand -hex 16)
AUTH_SECRET=$(openssl rand -base64 32)
EOF
fi
docker compose --env-file .env.local up -d --build
