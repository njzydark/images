# Paseo with Codex

`njzy/paseo:latest` extends the [official Paseo Docker image](https://paseo.sh/docs/docker)
with the latest published `@openai/codex` CLI. It retains Paseo's default
entrypoint, web UI, and non-root runtime user. The image is rebuilt daily so
new Paseo and Codex releases are picked up.

Mount `/home/paseo` for Paseo state and Codex credentials, and `/workspace` for
projects. Set `PASEO_PASSWORD` when exposing the daemon over a network. To sign
in to Codex from a running container, use `docker exec -it --user paseo paseo
codex` (or configure provider credentials through a secret).

Codex version is reported by `codex --version` inside the image.
