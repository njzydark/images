FROM njzy/dev-image:nix

ARG USERNAME=coder
ARG USER_UID=1000
ARG USER_GID=1000

RUN nix profile install nixpkgs#fnm \
&& nix store gc

RUN echo 'eval "$(fnm env --use-on-cd --shell zsh)"' >> ~/.zshrc && \
    zsh -c 'source ~/.zshrc && fnm install v22'