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
    zsh -c 'source ~/.zshrc && npm install -g pnpm @anthropic-ai/claude-code @musistudio/claude-code-router opencode-ai @openai/codex @twsxtd/hapi'

RUN mkdir -p ~/.claude
RUN mkdir -p ~/.claude-code-router
COPY --chown=$USERNAME:$USERNAME claude-code-router.json /home/$USERNAME/.claude-code-router/config.json
COPY --chown=$USERNAME:$USERNAME claude-code-settings.json /home/$USERNAME/.claude/settings.json
COPY --chown=$USERNAME:$USERNAME claude.json /home/$USERNAME/.claude.json

RUN mkdir -p ~/.codex
COPY --chown=$USERNAME:$USERNAME codex-config.toml /home/$USERNAME/.codex/config.toml

RUN echo 'ccr restart' >> ~/.zshrc
