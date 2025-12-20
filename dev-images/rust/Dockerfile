FROM njzy/dev-image:nix

ARG USERNAME=coder
ARG USER_UID=1000
ARG USER_GID=1000

RUN nix profile install \
nixpkgs#cargo \
nixpkgs#rust-analyzer \
nixpkgs#clippy \
nixpkgs#rustfmt \
&& nix store gc
