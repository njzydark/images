FROM njzy/dev-image:nix

ARG USERNAME=coder
ARG USER_UID=1000
ARG USER_GID=1000

RUN nix profile install nixpkgs#python313 nixpkgs#uv nixpkgs#python313Packages.pip \
&& nix store gc