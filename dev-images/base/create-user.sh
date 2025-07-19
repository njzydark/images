#!/bin/bash
# create-user.sh
set -e

USERNAME=${1:-coder}
USER_UID=${2:-1000}
USER_GID=${3:-1000}

echo "Creating user: $USERNAME (UID: $USER_UID, GID: $USER_GID)"

# 检查并处理 GID 冲突
if getent group $USER_GID >/dev/null 2>&1; then
    EXISTING_GROUP=$(getent group $USER_GID | cut -d: -f1)
    if [ "$EXISTING_GROUP" != "$USERNAME" ]; then
        echo "⚠️  GID $USER_GID already exists (group: $EXISTING_GROUP)"
        echo "🔄 Removing existing group: $EXISTING_GROUP"
        groupdel $EXISTING_GROUP 2>/dev/null || true
    fi
fi

# 检查并处理 UID 冲突
if getent passwd $USER_UID >/dev/null 2>&1; then
    EXISTING_USER=$(getent passwd $USER_UID | cut -d: -f1)
    if [ "$EXISTING_USER" != "$USERNAME" ]; then
        echo "⚠️  UID $USER_UID already exists (user: $EXISTING_USER)"
        echo "🔄 Removing existing user: $EXISTING_USER"
        userdel -r $EXISTING_USER 2>/dev/null || true
    fi
fi

# 检查用户名是否已存在（不同的UID）
if getent passwd $USERNAME >/dev/null 2>&1; then
    EXISTING_UID=$(getent passwd $USERNAME | cut -d: -f3)
    if [ "$EXISTING_UID" != "$USER_UID" ]; then
        echo "⚠️  Username $USERNAME already exists with UID: $EXISTING_UID"
        echo "🔄 Removing existing user: $USERNAME"
        userdel -r $USERNAME 2>/dev/null || true
    fi
fi

# 创建组（如果不存在）
if ! getent group $USERNAME >/dev/null 2>&1; then
    groupadd --gid $USER_GID $USERNAME
    echo "✅ Created group: $USERNAME (GID: $USER_GID)"
fi

# 创建用户（如果不存在）
if ! getent passwd $USERNAME >/dev/null 2>&1; then
    useradd --uid $USER_UID --gid $USER_GID -m -s /bin/zsh $USERNAME
    echo "✅ Created user: $USERNAME (UID: $USER_UID, GID: $USER_GID)"
fi

# 设置用户密码为空
passwd -d $USERNAME

# 设置 sudo 权限
echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME
chmod 0440 /etc/sudoers.d/$USERNAME
echo "✅ Configured sudo privileges for: $USERNAME"

# 设置工作目录权限
mkdir -p /workspace
chown -R $USERNAME:$USERNAME /workspace
echo "✅ Configured workspace permissions"

echo "🎉 User setup completed!"