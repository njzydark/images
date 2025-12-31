FROM njzy/dev-image:full

ARG USERNAME=coder
ARG USER_UID=1000
ARG USER_GID=1000

RUN nix profile install \
nixpkgs#docker \
nixpkgs#docker-compose \
nixpkgs#docker-buildx \
&& nix store gc