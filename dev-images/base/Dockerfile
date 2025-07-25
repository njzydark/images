FROM ubuntu:24.04

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV TZ=Asia/Shanghai

# 安装基础工具和依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
  # 基础工具
  curl \
  wget \
  git \
  neovim \
  sudo \
  ca-certificates \
  unzip \
  jq \
  tree \
  htop \
  zsh \
  ssh \
  # 网络排查工具
  dnsutils \
  iputils-ping \
  iputils-tracepath \
  traceroute \
  net-tools \
  telnet \
  netcat-openbsd \
  tcpdump \
  nmap \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean \
  && apt-get autoremove -y

# 创建开发用户
ARG USERNAME=coder
ARG USER_UID=1000
ARG USER_GID=1000

# 拷贝用户创建脚本
COPY create-user.sh /usr/local/bin/create-user.sh
RUN chmod +x /usr/local/bin/create-user.sh
# 创建用户
RUN /usr/local/bin/create-user.sh $USERNAME $USER_UID $USER_GID

# 拷贝欢迎脚本
COPY welcome.sh /usr/local/bin/welcome.sh
RUN chmod +x /usr/local/bin/welcome.sh

# 切换到开发用户
USER $USERNAME
WORKDIR /home/$USERNAME

# 安装 Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 设置工作目录
USER root
WORKDIR /workspaces
RUN chown -R $USERNAME:$USERNAME /workspaces

USER $USERNAME
ENV SHELL=/bin/zsh

# 基础 shell 配置
RUN echo '# === Development Environment ===' >> ~/.zshrc \
  && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

CMD ["/bin/zsh", "-c", "/usr/local/bin/welcome.sh && /bin/zsh"]