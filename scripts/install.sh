#!/bin/bash
# Cursor Automation Skill Installation Script

set -e

echo "=========================================="
echo "Cursor Automation Skill Installer"
echo "=========================================="

# 检查是否以 root 运行
if [ "$EUID" -eq 0 ]; then 
    echo "ERROR: Please do not run as root/sudo"
    echo "Run this script as your normal user"
    exit 1
fi

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
SKILL_NAME="cursor-automation"

echo "Skill directory: $SKILL_DIR"
echo ""

# 1. 检查依赖
echo "1. Checking dependencies..."
echo "--------------------------"

# 检查 Python
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python3 is not installed"
    echo "Please install Python3: sudo apt install python3"
    exit 1
fi
echo "✓ Python3: $(python3 --version)"

# 检查 xdotool
if ! command -v xdotool &> /dev/null; then
    echo "Installing xdotool..."
    sudo apt update && sudo apt install -y xdotool
    echo "✓ xdotool installed"
else
    echo "✓ xdotool: $(xdotool --version 2>/dev/null || echo 'installed')"
fi

# 检查 xclip
if ! command -v xclip &> /dev/null; then
    echo "Installing xclip..."
    sudo apt install -y xclip
    echo "✓ xclip installed"
else
    echo "✓ xclip: installed"
fi

echo ""

# 2. 确定 OpenClaw 安装目录
echo "2. Finding OpenClaw installation..."
echo "-----------------------------------"

OPENCLAW_DIR=""
POSSIBLE_DIRS=(
    "$HOME/.npm-global/lib/node_modules/openclaw"
    "/usr/local/lib/node_modules/openclaw"
    "/usr/lib/node_modules/openclaw"
    "$(npm root -g)/openclaw"
)

for dir in "${POSSIBLE_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        OPENCLAW_DIR="$dir"
        echo "✓ Found OpenClaw at: $OPENCLAW_DIR"
        break
    fi
done

if [ -z "$OPENCLAW_DIR" ]; then
    echo "ERROR: Could not find OpenClaw installation"
    echo "Please make sure OpenClaw is installed globally: npm install -g openclaw"
    exit 1
fi

# 3. 复制技能文件
echo ""
echo "3. Installing skill files..."
echo "----------------------------"

SKILLS_DIR="$OPENCLAW_DIR/skills"
TARGET_DIR="$SKILLS_DIR/$SKILL_NAME"

if [ -d "$TARGET_DIR" ]; then
    echo "⚠ Skill already exists at: $TARGET_DIR"
    read -p "Overwrite? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled"
        exit 0
    fi
    echo "Removing existing skill..."
    rm -rf "$TARGET_DIR"
fi

echo "Copying skill files..."
mkdir -p "$TARGET_DIR"
cp -r "$SKILL_DIR/SKILL.md" "$TARGET_DIR/"
mkdir -p "$TARGET_DIR/scripts"
cp -r "$SKILL_DIR/scripts/"* "$TARGET_DIR/scripts/"
cp -r "$SKILL_DIR/README.md" "$TARGET_DIR/" 2>/dev/null || true

# 设置执行权限
chmod +x "$TARGET_DIR/scripts/cursor_handler.py"
chmod +x "$TARGET_DIR/scripts/install.sh" 2>/dev/null || true
chmod +x "$TARGET_DIR/scripts/start_service.sh" 2>/dev/null || true

echo "✓ Skill files copied to: $TARGET_DIR"

# 4. 配置 OpenClaw
echo ""
echo "4. Configuring OpenClaw..."
echo "--------------------------"

OPENCLAW_CONFIG="$HOME/.openclaw/openclaw.json"
CONFIG_BACKUP="$OPENCLAW_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"

# 备份现有配置
if [ -f "$OPENCLAW_CONFIG" ]; then
    cp "$OPENCLAW_CONFIG" "$CONFIG_BACKUP"
    echo "✓ Backup created: $CONFIG_BACKUP"
fi

# 创建或更新配置
if [ ! -f "$OPENCLAW_CONFIG" ]; then
    echo "Creating new OpenClaw configuration..."
    cat > "$OPENCLAW_CONFIG" << EOF
{
  "skills": {
    "load": {
      "extraDirs": []
    }
  }
}
EOF
fi

# 检查是否已经配置了 extraDirs
if grep -q "extraDirs" "$OPENCLAW_CONFIG"; then
    # 检查是否已经包含了我们的技能目录
    if ! grep -q "$TARGET_DIR" "$OPENCLAW_CONFIG"; then
        echo "Adding skill directory to OpenClaw configuration..."
        # 使用 sed 添加目录
        sed -i "s|\"extraDirs\": \[|\"extraDirs\": \[ \"$TARGET_DIR\",|" "$OPENCLAW_CONFIG"
        echo "✓ Skill directory added to configuration"
    else
        echo "✓ Skill directory already in configuration"
    fi
else
    echo "Adding skills configuration..."
    # 插入 skills 配置
    sed -i '1s|{|{\n  "skills": {\n    "load": {\n      "extraDirs": ["'"$TARGET_DIR"'"]\n    }\n  },|' "$OPENCLAW_CONFIG"
    echo "✓ Skills configuration added"
fi

# 5. 启动服务
echo ""
echo "5. Starting automation service..."
echo "--------------------------------"

# 检查服务是否已经在运行
if pgrep -f "cursor_handler.py" > /dev/null; then
    echo "⚠ Service is already running"
    read -p "Restart service? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        pkill -f "cursor_handler.py"
        sleep 1
        echo "Starting service..."
        python3 "$TARGET_DIR/scripts/cursor_handler.py" > /tmp/cursor_service.log 2>&1 &
        sleep 2
    fi
else
    echo "Starting service..."
    python3 "$TARGET_DIR/scripts/cursor_handler.py" > /tmp/cursor_service.log 2>&1 &
    sleep 2
fi

# 检查服务是否启动成功
if curl -s http://127.0.0.1:8000/ > /dev/null; then
    echo "✓ Service started successfully"
    echo "  Log file: /tmp/cursor_service.log"
    echo "  Status:   http://127.0.0.1:8000/"
else
    echo "⚠ Service may not have started properly"
    echo "  Check logs: /tmp/cursor_service.log"
fi

# 6. 重启 OpenClaw Gateway
echo ""
echo "6. Restarting OpenClaw Gateway..."
echo "---------------------------------"

if command -v openclaw &> /dev/null; then
    echo "Restarting gateway..."
    openclaw gateway restart
    sleep 3
    echo "✓ Gateway restarted"
else
    echo "⚠ Could not find 'openclaw' command"
    echo "  Please restart OpenClaw manually: openclaw gateway restart"
fi

echo ""
echo "=========================================="
echo "Installation Complete!"
echo "=========================================="
echo ""
echo "What's next:"
echo "1. Make sure Cursor editor is installed and running"
echo "2. Maximize Cursor window for best results"
echo "3. Test the skill by asking OpenClaw to write code"
echo ""
echo "Usage examples:"
echo "  • '帮我写一个 Python 函数'"
echo "  • 'Create an HTML page'"
echo "  • 'Debug this JavaScript code'"
echo ""
echo "Troubleshooting:"
echo "  • Check service status: curl http://127.0.0.1:8000/"
echo "  • View logs: tail -f /tmp/cursor_service.log"
echo "  • Restart service: pkill -f cursor_handler.py && python3 $TARGET_DIR/scripts/cursor_handler.py"
echo ""
echo "Skill directory: $TARGET_DIR"
echo "=========================================="