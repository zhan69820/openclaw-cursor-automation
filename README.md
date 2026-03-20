# OpenClaw Cursor Automation Skill

![Cursor Automation](https://img.shields.io/badge/OpenClaw-Skill-blue)
![Python](https://img.shields.io/badge/Python-3.6+-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

An OpenClaw skill that allows AI assistants to control Cursor editor via a local Python automation service. Send code instructions directly to Cursor for programming tasks like coding, refactoring, debugging, and more.

## ✨ Features

- **Direct Cursor Control**: Send code/instructions directly to Cursor editor
- **Dual Mode Support**: 
  - `composer` mode (Ctrl+I) - For inline code generation
  - `chat` mode (Ctrl+L) - For conversational programming help
- **Automatic Service Management**: Python service starts automatically
- **Cross-Platform**: Works on Linux with X11 (Ubuntu, Debian, etc.)
- **Easy Installation**: One-command installation script
- **Production Ready**: Error handling, logging, and health checks

## 📋 Prerequisites

### System Requirements
- **Linux** with X11 window system
- **Cursor Editor** installed and running
- **Python 3.6+** installed
- **OpenClaw** installed globally

### Required System Packages
```bash
sudo apt update
sudo apt install xdotool xclip
```

## 🚀 Quick Installation

### Method 1: One-Command Install (Recommended)
```bash
# Clone the repository
git clone https://github.com/nice010/openclaw-cursor-automation.git
cd openclaw-cursor-automation

# Run the installation script
bash scripts/install.sh
```

### Method 2: Manual Installation
```bash
# 1. Install system dependencies
sudo apt install xdotool xclip

# 2. Clone the skill
git clone https://github.com/nice010/openclaw-cursor-automation.git
cd openclaw-cursor-automation

# 3. Copy skill to OpenClaw skills directory
OPENCLAW_DIR=$(npm root -g)/openclaw
mkdir -p $OPENCLAW_DIR/skills/cursor-automation
cp -r . $OPENCLAW_DIR/skills/cursor-automation/

# 4. Configure OpenClaw
echo 'Add to ~/.openclaw/openclaw.json:
{
  "skills": {
    "load": {
      "extraDirs": ["'$OPENCLAW_DIR'/skills/cursor-automation"]
    }
  }
}'

# 5. Restart OpenClaw
openclaw gateway restart
```

## 🎯 Usage

Once installed, you can use the skill through OpenClaw:

### Basic Examples
```
User: 帮我写一个Python函数计算阶乘
Assistant: 好的，我来帮你写一个阶乘函数。

User: Create a responsive HTML page
Assistant: I'll create a modern responsive HTML page for you.

User: Debug this JavaScript code
Assistant: Let me help you debug that JavaScript code.
```

### Advanced Usage
The skill supports two modes:

1. **Composer Mode** (Ctrl+I): Best for code generation and editing
   ```json
   {
     "content": "Write a Flask web application with user authentication",
     "mode": "composer"
   }
   ```

2. **Chat Mode** (Ctrl+L): Best for explanations and debugging
   ```json
   {
     "content": "Explain how React hooks work with examples",
     "mode": "chat"
   }
   ```

## 🛠️ API Reference

### HTTP Endpoints
- `POST /operate_cursor` - Send instructions to Cursor
- `GET /` - Service status
- `GET /health` - Health check

### Request Format
```json
{
  "content": "string (required) - The prompt or code to send",
  "mode": "string (optional) - 'composer' or 'chat', defaults to 'composer'"
}
```

### Response Format
```json
{
  "status": "success",
  "message": "Cursor action queued: composer",
  "content_length": 42
}
```

## 📁 Project Structure

```
openclaw-cursor-automation/
├── SKILL.md                    # OpenClaw skill definition
├── README.md                   # This file
├── EXAMPLES.md                 # Detailed usage examples
├── scripts/
│   ├── cursor_handler.py       # Python automation service
│   ├── install.sh             # Installation script
│   ├── start_service.sh       # Service startup script
│   └── uninstall.sh           # Uninstallation script
└── LICENSE                    # MIT License
```

## 🔧 Service Management

### Start Service
```bash
bash scripts/start_service.sh
```

### Stop Service
```bash
pkill -f cursor_handler.py
```

### Check Status
```bash
curl http://127.0.0.1:8000/
```

### View Logs
```bash
tail -f /tmp/cursor_service.log
```

## 🐛 Troubleshooting

### Common Issues

1. **"Service not responding"**
   ```bash
   # Check if service is running
   ps aux | grep cursor_handler
   
   # Start service manually
   bash scripts/start_service.sh
   ```

2. **"Cursor not responding"**
   - Ensure Cursor is open and maximized
   - Test xdotool manually: `xdotool key ctrl+i`
   - Check window focus

3. **"Clipboard not working"**
   ```bash
   # Test xclip
   echo "test" | xclip -selection clipboard
   xclip -selection clipboard -o
   ```

4. **"Permission denied"**
   ```bash
   # Make scripts executable
   chmod +x scripts/*.sh
   chmod +x scripts/cursor_handler.py
   ```

### Debug Mode
```bash
# Run service with debug output
python3 scripts/cursor_handler.py --debug
```

## 📝 Examples

See [EXAMPLES.md](EXAMPLES.md) for detailed usage examples including:
- Code generation for various languages
- Debugging and code review
- Architecture design
- Database queries
- Integration with OpenClaw workflows

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Report Bugs**: Open an issue with detailed reproduction steps
2. **Suggest Features**: Share your ideas for new features
3. **Submit Pull Requests**: 
   - Fork the repository
   - Create a feature branch
   - Make your changes
   - Submit a pull request

### Development Setup
```bash
# Clone the repository
git clone https://github.com/nice010/openclaw-cursor-automation.git
cd openclaw-cursor-automation

# Install development dependencies
pip install -r requirements-dev.txt  # If available

# Run tests
python -m pytest tests/
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [OpenClaw](https://openclaw.ai) - For the amazing AI assistant platform
- [Cursor](https://cursor.sh) - The AI-powered code editor
- [xdotool](https://github.com/jordansissel/xdotool) - X11 automation tool
- [xclip](https://github.com/astrand/xclip) - Command line clipboard tool

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/nice010/openclaw-cursor-automation/issues)
- **Discussions**: [GitHub Discussions](https://github.com/nice010/openclaw-cursor-automation/discussions)

## 🔗 Links

- [OpenClaw Documentation](https://docs.openclaw.ai)
- [Cursor Documentation](https://docs.cursor.sh)
- [Skill Examples](EXAMPLES.md)
- [Installation Script](scripts/install.sh)

---

**⭐ If you find this project useful, please give it a star on GitHub!**