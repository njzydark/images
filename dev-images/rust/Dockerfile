FROM njzy/dev-image:nix

ARG USERNAME=coder
ARG USER_UID=1000
ARG USER_GID=1000

RUN nix profile install nixpkgs#rustup \
&& rustup default stable \
&& nix store gc