# images

Centralized Docker image builds for personal images and forked projects.

This repository keeps image publishing in one place instead of enabling GitHub Actions across every fork. Thin workflow files under `.github/workflows/docker-*.yaml` call the shared build workflow and keep image names, tags, schedules, and dependency chains stable.

Some images are built from Dockerfiles in this repository. Others check out a forked source repository during the workflow run and build from that source, with optional Dockerfile overrides kept here when needed.

## Publishing

Images are pushed to Docker Hub:

- Docker Hub: `docker.io/<DOCKER_USERNAME>/<image_name>:<image_tag>`

## Docker Hub README

Docker Hub README synchronization is enabled by default when a README can be found. Explicit `dockerhub_readme_path` values win first; otherwise external-source builds prefer the source README, while local Dockerfile overrides can provide a local README beside the override.

Every synced Docker Hub README is prefixed with:

```md
Source repository: https://github.com/<source-or-build-repository>
Build repository: https://github.com/njzydark/images

---
```

Local images skip README sync when no image-specific README exists, so multi-tag repositories such as `dev-image` do not overwrite the Docker Hub description with the root repository README.
