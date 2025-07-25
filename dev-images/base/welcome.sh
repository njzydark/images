#!/bin/zsh
# welcome.sh - NJZY Development Environment Welcome Script

# 颜色定义
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# 清空终端并显示欢迎信息
clear

echo -e "${GREEN}🏠 Welcome to NJZY's Private Development Environment!${RESET}"
echo ""

# 显示环境信息
echo -e "${YELLOW}📋 Environment Information:${RESET}"
echo -e "   • ${CYAN}Current User:${RESET}    $(whoami) (UID: $(id -u), GID: $(id -g))"
echo -e "   • ${CYAN}Home Directory:${RESET} $HOME"
echo -e "   • ${CYAN}Working Dir:${RESET}    $(pwd)"
echo -e "   • ${CYAN}Shell:${RESET}          $SHELL"
echo ""

# 检查并显示 Mise 信息
if command -v mise >/dev/null 2>&1; then
    echo -e "${PURPLE}🎯 Mise Version Manager:${RESET}"
    MISE_VERSION=$(mise --version 2>/dev/null || echo "unknown")
    echo -e "   • ${GREEN}✅ Mise installed:${RESET} v$MISE_VERSION"
    
    # 显示已安装的语言
    if mise ls 2>/dev/null | grep -q .; then
        echo -e "   • ${CYAN}🔧 Installed languages:${RESET}"
        mise ls 2>/dev/null | sed 's/^/     /'
    else
        echo -e "   • ${YELLOW}📦 No languages installed yet${RESET}"
    fi
    
    # 显示当前激活的版本
    if mise current 2>/dev/null | grep -q .; then
        echo -e "   • ${CYAN}⚡ Active versions:${RESET}"
        mise current 2>/dev/null | sed 's/^/     /'
    fi

    echo ""
fi

# 显示项目相关信息
if [ -f ".mise.toml" ]; then
    echo -e "${GREEN}📁 Project Configuration Found:${RESET}"
    echo -e "   • ${CYAN}.mise.toml exists${RESET} - Run ${GREEN}mise install${RESET} to setup project tools"
    echo ""
elif [ -f "package.json" ] || [ -f "requirements.txt" ] || [ -f "go.mod" ] || [ -f "Cargo.toml" ]; then
    echo -e "${YELLOW}📁 Project Files Detected:${RESET}"
    [ -f "package.json" ] && echo -e "   • ${CYAN}Node.js project${RESET} (package.json)"
    [ -f "requirements.txt" ] && echo -e "   • ${CYAN}Python project${RESET} (requirements.txt)"
    [ -f "pyproject.toml" ] && echo -e "   • ${CYAN}Python project${RESET} (pyproject.toml)"
    [ -f "go.mod" ] && echo -e "   • ${CYAN}Go project${RESET} (go.mod)"
    [ -f "Cargo.toml" ] && echo -e "   • ${CYAN}Rust project${RESET} (Cargo.toml)"
    echo -e "   • ${GREEN}Tip:${RESET} Create a .mise.toml file to manage project versions"
    echo ""
fi

# 显示帮助脚本信息
echo -e "${CYAN}📖 Available Help Scripts:${RESET}"
if [ -f "$HOME/show-mise.sh" ]; then
    echo -e "   • ${GREEN}~/show-mise.sh${RESET}         Detailed Mise usage guide"
fi
if [ -f "$HOME/install-dev-stack.sh" ]; then
    echo -e "   • ${GREEN}~/install-dev-stack.sh${RESET} Install common development stack"
fi

# 检查网络工具
NETWORK_TOOLS=("dig" "ping" "nmap" "nc" "curl")
AVAILABLE_NETWORK=()
for tool in "${NETWORK_TOOLS[@]}"; do
    if command -v $tool >/dev/null 2>&1; then
        AVAILABLE_NETWORK+=($tool)
    fi
done

if [ ${#AVAILABLE_NETWORK[@]} -gt 0 ]; then
    echo -e "   • ${GREEN}🌐 Network tools:${RESET}      ${AVAILABLE_NETWORK[*]}"
fi

echo ""

# 显示系统资源信息
echo -e "${PURPLE}💻 System Resources:${RESET}"
if command -v free >/dev/null 2>&1; then
    MEMORY_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
    MEMORY_USED=$(free -h | awk '/^Mem:/ {print $3}')
    echo -e "   • ${CYAN}Memory:${RESET} $MEMORY_USED / $MEMORY_TOTAL"
fi

if command -v df >/dev/null 2>&1; then
    DISK_INFO=$(df -h /workspaces 2>/dev/null | tail -1 | awk '{print $3 " / " $2}')
    [ -n "$DISK_INFO" ] && echo -e "   • ${CYAN}Disk:${RESET}   $DISK_INFO"
fi

if command -v nproc >/dev/null 2>&1; then
    CPU_CORES=$(nproc)
    echo -e "   • ${CYAN}CPU Cores:${RESET} $CPU_CORES"
fi

echo ""
echo -e "${GREEN}🎉 Happy Coding! 🎉${RESET}"
echo ""

# 可选：显示 MOTD 或公告
if [ -f "/etc/motd.njzy" ]; then
    echo -e "${CYAN}📢 Announcements:${RESET}"
    cat /etc/motd.njzy
    echo ""
fi