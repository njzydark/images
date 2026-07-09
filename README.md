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
- `njzydark/warpgate` via `.github/workflows/docker-warpgate.yaml`

The reusable workflow supports:

- building from the current repository or an external repository checkout
- using the source repository's own Dockerfile
- overriding the Dockerfile from this repository
- per-platform Dockerfile overrides such as `Dockerfile` for `amd64` and `Dockerfile.aarch64` for `arm64`

## Registries and Metadata

Images are pushed to Docker Hub and GitHub Container Registry by default:

- Docker Hub: `docker.io/<DOCKER_USERNAME>/<image_name>:<image_tag>`
- GHCR: `ghcr.io/njzydark/<image_name>:<image_tag>`

For external repositories, the workflow labels images with `org.opencontainers.image.source=https://github.com/<source_repository>` and `org.opencontainers.image.revision=<source commit>`.

Docker Hub README synchronization is enabled by default when a README can be found:

- If `dockerhub_readme_path` is set, that file is used first.
- If the Dockerfile comes from the source repository, the source context README is used, then the source root README.
- If the Dockerfile comes from this repository for an external source build, the local Dockerfile directory README is used first, then the build context README, then the source root README.
- Local images skip README sync when no README exists in their image context, so multi-tag repositories such as `dev-image` do not overwrite the Docker Hub description with the root repository README.

## GHCR First Publish Checklist

GHCR package-to-repository linking is not fully guaranteed by a central workflow. After the first successful publish for an external source image:

1. Open `https://github.com/users/njzydark/packages/container/package/<image_name>`.
2. Confirm the package is connected to the fork repository shown by the `org.opencontainers.image.source` label.
3. If it is not connected, use package settings to connect the repository manually.
4. In package settings, grant `njzydark/images` Actions access with write permission so this central workflow can keep pushing future versions.
5. Set the package visibility to Public if the image should be anonymously pullable.
