# Infisical local test image

> **Local development and testing only.** This derivative image is not a production Infisical distribution. For production, use the official Infisical image and obtain a valid official license for paid features.

This folder builds a local test image from the official `infisical/infisical:v0.165.16` image. It changes the compiled self-hosted entitlement defaults in the derivative image. The base image and upstream source are not modified. The GitHub workflow builds and checks this image on amd64 and arm64, without publishing it.

## Start

```bash
cd /Users/bytedance/Developer/images/infisical-local-test
./start.sh
```

The script generates `.env.local` with random local secrets on first run. Open <http://localhost:18080/admin/signup> to create the administrator account. Only port `127.0.0.1:18080` is exposed; PostgreSQL and Redis stay inside the Compose network.

## Check

```bash
docker compose --env-file .env.local ps
curl -I http://127.0.0.1:18080/admin/signup
```

## Stop

```bash
docker compose --env-file .env.local down
```

The named PostgreSQL volume persists across restarts. Features that require external services, devices, or credentials still need those dependencies to be configured before they can be exercised.

The derivative image disables outbound product analytics, signup tracking, license usage reporting, optional metrics/traces, and the GitHub version check in code. The Compose file does not depend on telemetry environment switches. This does not block network calls made by integrations you explicitly configure and use.
