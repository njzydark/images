FROM njzy/dev-image:base

ARG USERNAME=coder
ARG USER_UID=1000
ARG USER_GID=1000

RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
build-essential \
curl \
xz-utils \
&& sudo rm -rf /var/lib/apt/lists/* \
&& sudo apt-get clean \
&& sudo apt-get autoremove -y

# 安装 Nix (单用户模式)
RUN curl -L https://nixos.org/nix/install > /tmp/install-nix.sh \
&& chmod +x /tmp/install-nix.sh \
&& /tmp/install-nix.sh --no-daemon \
&& rm /tmp/install-nix.sh

# 设置环境变量
ENV PATH="/home/$USERNAME/.nix-profile/bin:$PATH"

# 更新 shell 配置
RUN echo '' >> ~/.zshrc \
&& echo '# === Nix Configuration ===' >> ~/.zshrc \
&& echo 'if [ -e /home/'"$USERNAME"'/.nix-profile/etc/profile.d/nix.sh ]; then . /home/'"$USERNAME"'/.nix-profile/etc/profile.d/nix.sh; fi' >> ~/.zshrc \
&& echo '' >> ~/.zshrc

# 创建默认的 Nix 配置目录（可选）
RUN mkdir -p ~/.config/nix \
&& echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# 确保 Nix 正确初始化
RUN . ~/.nix-profile/etc/profile.d/nix.sh && nix-env --version