FROM njzy/dev-image:base

ARG USERNAME=coder
ARG USER_UID=1000
ARG USER_GID=1000

RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
  build-essential \
  && sudo rm -rf /var/lib/apt/lists/* \
  && sudo apt-get clean \
  && sudo apt-get autoremove -y

# 只安装 mise (统一版本管理工具)
RUN curl https://mise.run | sh

# 设置环境变量
ENV PATH="/home/$USERNAME/.local/bin:$PATH"

# 更新 shell 配置
RUN echo '' >> ~/.zshrc \
    && echo '# === Mise Configuration ===' >> ~/.zshrc \
    && echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc \
    && echo '' >> ~/.zshrc