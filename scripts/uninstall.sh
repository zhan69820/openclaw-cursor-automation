#!/bin/bash
# Cursor Automation Skill Uninstaller

set -e

echo "=========================================="
echo "Cursor Automation Skill Uninstaller"
echo "=========================================="

SKILL_NAME="cursor-automation"

# 1. 停止服务
echo "1. Stopping automation service..."
echo "---------------------------------"

if pgrep -f "cursor_handler.py" > /dev/null; then
    echo "Stopping service..."
    pkill -f "cursor_handler.py"
    sleep 2
    echo "✓ Service stopped"
else
    echo "✓ Service not running"
fi

# 2. 查找 OpenClaw 安装目录
echo ""
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
    echo "⚠ Could not find OpenClaw installation"
    echo "Proceeding with manual cleanup..."
fi

# 3. 删除技能文件
echo ""
echo "3. Removing skill files..."
echo "--------------------------"

if [ -n "$OPENCLAW_DIR" ]; then
    SKILLS_DIR="$OPENCLAW_DIR/skills"
    TARGET_DIR="$SKILLS_DIR/$SKILL_NAME"
    
    if [ -d "$TARGET_DIR" ]; then
        echo "Removing skill directory: $TARGET_DIR"
        rm -rf "$TARGET_DIR"
        echo "✓ Skill files removed"
    else
        echo "✓ Skill directory not found"
    fi
else
    echo "⚠ Skipping skill file removal (OpenClaw not found)"
fi

# 4. 清理配置
echo ""
echo "4. Cleaning up configuration..."
echo "-------------------------------"

OPENCLAW_CONFIG="$HOME/.openclaw/openclaw.json"

if [ -f "$OPENCLAW_CONFIG" ]; then
    # 备份配置
    CONFIG_BACKUP="$OPENCLAW_CONFIG.backup.uninstall.$(date +%Y%m%d_%H%M%S)"
    cp "$OPENCLAW_CONFIG" "$CONFIG_BACKUP"
    echo "✓ Configuration backed up to: $CONFIG_BACKUP"
    
    # 如果 skill 目录在配置中，移除它
    if [ -n "$OPENCLAW_DIR" ] && [ -d "$OPENCLAW_DIR/skills/$SKILL_NAME" ]; then
        SKILL_PATH="$OPENCLAW_DIR/skills/$SKILL_NAME"
        if grep -q "$SKILL_PATH" "$OPENCLAW_CONFIG"; then
            echo "Removing skill path from configuration..."
            # 使用 sed 移除目录
            sed -i "s|\"$SKILL_PATH\",\?||g" "$OPENCLAW_CONFIG"
            sed -i "s|, ,|,|g" "$OPENCLAW_CONFIG"
            sed -i "s|, ]|]|g" "$OPENCLAW_CONFIG"
            sed -i "s|\[ ,|\[|g" "$OPENCLAW_CONFIG"
            sed -i "s|\[ \]|\[\]|g" "$OPENCLAW_CONFIG"
            echo "✓ Skill path removed from configuration"
        fi
    fi
else
    echo "✓ OpenClaw configuration not found"
fi

# 5. 清理日志文件
echo ""
echo "5. Cleaning up log files..."
echo "---------------------------"

LOG_FILE="/tmp/cursor_service.log"
if [ -f "$LOG_FILE" ]; then
    echo "Removing log file: $LOG_FILE"
    rm -f "$LOG_FILE"
    echo "✓ Log file removed"
else
    echo "✓ Log file not found"
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
    echo "  Please restart OpenClaw manually if needed"
fi

echo ""
echo "=========================================="
echo "Uninstallation Complete!"
echo "=========================================="
echo ""
echo "The Cursor Automation skill has been removed."
echo ""
echo "Note: System packages (xdotool, xclip) were not removed"
echo "If you want to remove them:"
echo "  sudo apt remove xdotool xclip"
echo ""
echo "To reinstall, run the install.sh script again."
echo "=========================================="