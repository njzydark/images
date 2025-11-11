FROM njzy/dev-image:nix

ARG USERNAME=coder
ARG USER_UID=1000
ARG USER_GID=1000

RUN nix profile install \
nixpkgs#nodejs_22 \
nixpkgs#pnpm \
nixpkgs#python313 \
nixpkgs#python313Packages.pip \
nixpkgs#uv \
nixpkgs#ruff \
nixpkgs#rustup \
nixpkgs#go \
&& pnpm setup \
&& rustup default stable \
&& nix store gc

ENV PNPM_HOME="/home/$USERNAME/.local/share/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN pnpm add -g @anthropic-ai/claude-code @musistudio/claude-code-router

RUN mkdir -p ~/.claude
RUN mkdir -p ~/.claude-code-router
COPY --chown=$USERNAME:$USERNAME claude-code-router.json /home/$USERNAME/.claude-code-router/config.json
COPY --chown=$USERNAME:$USERNAME claude-code-settings.json /home/$USERNAME/.claude/settings.json