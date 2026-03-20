# 🚀 Quick Start Guide

Get started with Cursor Automation Skill in under 5 minutes!

## One-Line Installation

```bash
# Clone and install with one command
git clone https://github.com/nice010/openclaw-cursor-automation.git && cd openclaw-cursor-automation && bash scripts/install.sh
```

Or use the direct install script:

```bash
# Direct install (requires curl)
curl -s https://raw.githubusercontent.com/nice010/openclaw-cursor-automation/main/scripts/install.sh | bash
```

## Step-by-Step Installation

### 1. Install System Dependencies
```bash
sudo apt update
sudo apt install xdotool xclip
```

### 2. Clone the Repository
```bash
git clone https://github.com/nice010/openclaw-cursor-automation.git
cd openclaw-cursor-automation
```

### 3. Run Installation Script
```bash
bash scripts/install.sh
```

### 4. Verify Installation
```bash
# Check service status
curl http://127.0.0.1:8000/

# Test the skill
curl -X POST http://127.0.0.1:8000/operate_cursor \
  -H "Content-Type: application/json" \
  -d '{"content": "Hello Cursor!", "mode": "composer"}'
```

## 🎯 First Use

1. **Open Cursor Editor** and maximize the window
2. **Test with OpenClaw**:
   ```
   User: 帮我写一个简单的Python函数
   Assistant: 好的，我来帮你写一个Python函数。
   ```
3. **Watch Cursor** automatically open composer and generate code

## 📋 Common Commands

### Service Management
```bash
# Start service
bash scripts/start_service.sh

# Stop service
pkill -f cursor_handler.py

# Check status
curl http://127.0.0.1:8000/

# View logs
tail -f /tmp/cursor_service.log
```

### Skill Testing
```bash
# Test with curl
curl -X POST http://127.0.0.1:8000/operate_cursor \
  -H "Content-Type: application/json" \
  -d '{"content": "Write a function to calculate factorial in Python", "mode": "composer"}'
```

## 🐛 Quick Troubleshooting

### Issue: "Service not responding"
```bash
# Restart service
pkill -f cursor_handler.py
bash scripts/start_service.sh
```

### Issue: "Cursor not opening"
- Make sure Cursor is the active, maximized window
- Test manually: `xdotool key ctrl+i`

### Issue: "Clipboard not working"
```bash
# Test clipboard
echo "test" | xclip -selection clipboard
xclip -selection clipboard -o
```

## 🔗 Useful Links

- **Full Documentation**: [README.md](README.md)
- **Examples**: [EXAMPLES.md](EXAMPLES.md)
- **Install Script**: [scripts/install.sh](scripts/install.sh)
- **GitHub Repository**: https://github.com/nice010/openclaw-cursor-automation

## ⚡ Pro Tips

1. **Keep Cursor maximized** for best results
2. **Use composer mode** for code generation
3. **Use chat mode** for explanations and debugging
4. **Check logs** if something doesn't work: `tail -f /tmp/cursor_service.log`

## 🆘 Need Help?

- **GitHub Issues**: https://github.com/nice010/openclaw-cursor-automation/issues
- **Test Installation**: `bash test_installation.sh`

---

**Enjoy automated coding with Cursor! 🎉**