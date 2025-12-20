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
nixpkgs#rustup \
nixpkgs#go \
nixpkgs#docker \
nixpkgs#docker-compose \
nixpkgs#docker-buildx \
&& rustup default stable \
&& nix store gc

RUN echo 'eval "$(fnm env --use-on-cd --shell zsh)"' >> ~/.zshrc && \
    zsh -c 'source ~/.zshrc && fnm install v22' && \
    zsh -c 'source ~/.zshrc && npm install -g @anthropic-ai/claude-code @musistudio/claude-code-router pnpm'

RUN mkdir -p ~/.claude
RUN mkdir -p ~/.claude-code-router
COPY --chown=$USERNAME:$USERNAME claude-code-router.json /home/$USERNAME/.claude-code-router/config.json
COPY --chown=$USERNAME:$USERNAME claude-code-settings.json /home/$USERNAME/.claude/settings.json
COPY --chown=$USERNAME:$USERNAME claude.json /home/$USERNAME/.claude.json

RUN echo 'ccr restart' >> ~/.zshrc
