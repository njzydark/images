# images

Centralized Docker image build repository for personal images and forked projects.

## Layout

- `dev-images/*` and `hapi/`: local image sources managed in this repo.
- `.github/workflows/reusable-docker-image.yaml`: shared multi-arch Docker build workflow.
- `.github/workflows/docker-*.yaml`: thin entry workflows that keep image names, push triggers, and `workflow_run` chains stable.

## External Repositories

Forked repositories can be built here without adding GitHub Actions files to the fork itself.

Current example:

- `njzydark/docker-chromium` via `.github/workflows/docker-chromium.yaml`

The reusable workflow supports:

- building from the current repository or an external repository checkout
- using the source repository's own Dockerfile
- overriding the Dockerfile from this repository
- per-platform Dockerfile overrides such as `Dockerfile` for `amd64` and `Dockerfile.aarch64` for `arm64`
