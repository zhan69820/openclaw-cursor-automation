#!/bin/bash
# Start Cursor Automation Service

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="$SCRIPT_DIR/cursor_handler.py"
LOG_FILE="/tmp/cursor_service.log"

echo "Starting Cursor Automation Service..."

# 检查是否已经在运行
if pgrep -f "cursor_handler.py" > /dev/null; then
    echo "Service is already running"
    echo "PID: $(pgrep -f "cursor_handler.py")"
    exit 0
fi

# 检查依赖
echo "Checking dependencies..."
if ! command -v xdotool &> /dev/null; then
    echo "ERROR: xdotool is not installed"
    echo "Install with: sudo apt install xdotool"
    exit 1
fi

if ! command -v xclip &> /dev/null; then
    echo "ERROR: xclip is not installed"
    echo "Install with: sudo apt install xclip"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo "ERROR: python3 is not installed"
    exit 1
fi

# 启动服务
echo "Starting service on port 8000..."
nohup python3 "$PYTHON_SCRIPT" > "$LOG_FILE" 2>&1 &

# 等待服务启动
sleep 3

# 检查服务是否启动成功
if curl -s http://127.0.0.1:8000/ > /dev/null; then
    echo "✓ Service started successfully"
    echo "PID: $(pgrep -f "cursor_handler.py")"
    echo "Log file: $LOG_FILE"
    echo "Status:   http://127.0.0.1:8000/"
else
    echo "⚠ Service may not have started properly"
    echo "Check log file: $LOG_FILE"
    exit 1
fi