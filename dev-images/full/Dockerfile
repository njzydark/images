FROM njzy/dev-image:nix

ARG USERNAME=coder
ARG USER_UID=1000
ARG USER_GID=1000

RUN nix profile install \
    nixpkgs#fnm \
    nixpkgs#python313 \
    nixpkgs#python313Packages.pip \
    nixpkgs#uv \
    nixpkgs#ruff \
    nixpkgs#go \
    nixpkgs#rustc \
    nixpkgs#cargo \
    nixpkgs#rust-analyzer \
    nixpkgs#clippy \
    nixpkgs#rustfmt \
    && nix store gc

ENV DENO_INSTALL=/home/$USERNAME/.deno
ENV PATH="$DENO_INSTALL/bin:$PATH"
RUN curl -fsSL https://deno.land/install.sh | sh

RUN echo "export DENO_INSTALL=\"\$HOME/.deno\"" >> ~/.zshrc && \
    echo 'export PATH="$DENO_INSTALL/bin:$HOME/.local/bin:$PATH"' >> ~/.zshrc && \
    zsh -c 'source ~/.zshrc'

RUN echo 'eval "$(fnm env --use-on-cd --shell zsh)"' >> ~/.zshrc && \
    zsh -c 'source ~/.zshrc && fnm install v22' && \
    zsh -c 'source ~/.zshrc && npm install -g pnpm @openai/codex @getpaseo/cli@latest'

RUN mkdir -p ~/.codex
COPY --chown=$USERNAME:$USERNAME codex-config.toml /home/$USERNAME/.codex/config.toml

RUN mkdir -p ~/.paseo
COPY --chown=$USERNAME:$USERNAME paseo-config.json /home/$USERNAME/.paseo/config.json
