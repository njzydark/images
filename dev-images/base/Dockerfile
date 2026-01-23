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
  tmux \
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

# 注入 Tmux 常用配置
RUN cat <<EOF > /home/$USERNAME/.tmux.conf
# 基础设置
set -g mouse on
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
set -g default-terminal "xterm-256color"

# 快捷键绑定
bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# Vim 风格面板切换
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# 快捷搜索：Prefix + f
bind-key f copy-mode \; command-prompt -p "Search Up:" "send -X search-backward \"%%%\""

# --- 状态栏样式 (High-Contrast Z) ---
set -g status-position bottom
set -g status-style 'fg=white,bg=black'
set -g status-left '#[fg=cyan,bold] #S '

# 右侧：Zen 模式开启时显示红底白字 [Z]
set -g status-right "#{?window_zoomed_flag,#[fg=white]#[bg=red]#[bold] [Z] ZOOMED #[default],} #[fg=brightblack]%H:%M "

# 当前窗口标签：绿底黑字
setw -g window-status-current-style 'fg=black,bg=green,bold'
setw -g window-status-current-format ' #I:#W#{?window_zoomed_flag, (Z),} '

# 其他窗口标签：灰底
setw -g window-status-style 'fg=brightblack,bg=black'
setw -g window-status-format ' #I:#W#{?window_zoomed_flag,(Z),} '
EOF

# 设置工作目录
USER root
WORKDIR /workspaces
RUN chown -R $USERNAME:$USERNAME /workspaces

USER $USERNAME
ENV SHELL=/bin/zsh

RUN echo '# === Development Environment ===' >> ~/.zshrc \
  && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

CMD ["/bin/zsh", "-c", "/usr/local/bin/welcome.sh && /bin/zsh"]