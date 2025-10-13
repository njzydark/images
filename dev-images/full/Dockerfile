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