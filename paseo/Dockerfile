FROM ghcr.io/getpaseo/paseo:latest

# Keep the base entrypoint's first-run volume setup and privilege drop.
USER root

# The build argument invalidates this layer for scheduled rebuilds so npm
# resolves the current Codex release even when the Docker cache is warm.
ARG CODEX_REFRESH
RUN echo "Codex refresh: ${CODEX_REFRESH}" && \
    npm install -g @openai/codex@latest && \
    codex --version
