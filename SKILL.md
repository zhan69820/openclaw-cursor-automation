---
name: cursor-automation
description: "Control Cursor editor via local Python service using xdotool. Send code instructions directly to Cursor for programming tasks. Use when: writing code, refactoring, debugging, or any programming-related work. NOT for: general text editing or document writing."
metadata:
  {
    "openclaw":
      {
        "emoji": "💻",
        "requires": { "http": "http://127.0.0.1:8000/operate_cursor" },
        "tools":
          [
            {
              "name": "operate_cursor",
              "description": "Send code or instructions to Cursor editor for programming tasks",
              "parameters":
                {
                  "type": "object",
                  "required": ["content"],
                  "properties":
                    {
                      "content":
                        {
                          "type": "string",
                          "description": "The specific prompt or code content to send to Cursor AI",
                        },
                      "mode":
                        {
                          "type": "string",
                          "enum": ["composer", "chat"],
                          "description": "Cursor mode: composer (Ctrl+I) or chat (Ctrl+L). Default: composer",
                          "default": "composer",
                        },
                    },
                },
              "handler":
                {
                  "type": "http",
                  "method": "POST",
                  "url": "http://127.0.0.1:8000/operate_cursor",
                  "headers": { "Content-Type": "application/json" },
                  "body": { "content": "{{content}}", "mode": "{{mode}}" },
                },
            },
          ],
      },
  }
---

# Cursor Automation Skill

Control Cursor editor directly from OpenClaw through a local Python automation service.

## How It Works

1. **Python Service**: A background HTTP server runs on port 8000
2. **xdotool Automation**: Uses xdotool to simulate keyboard shortcuts
3. **Clipboard Integration**: Uses xclip to copy text to clipboard
4. **Cursor Control**: Automatically triggers Cursor shortcuts (Ctrl+I for composer, Ctrl+L for chat)

## Prerequisites

Before using this skill, ensure you have:

1. **Cursor Editor**: Installed and running on your system
2. **System Tools**:
   ```bash
   sudo apt install xdotool xclip
   ```
3. **Python 3**: Pre-installed on most Linux systems

## Installation

### Automatic Installation
Run the included installation script:
```bash
bash scripts/install.sh
```

### Manual Installation
1. Copy this skill folder to your OpenClaw skills directory
2. Add the directory to `openclaw.json`:
   ```json
   "skills": {
     "load": {
       "extraDirs": ["/path/to/cursor-skill"]
     }
   }
   ```
3. Install dependencies: `sudo apt install xdotool xclip`
4. Restart OpenClaw Gateway: `openclaw gateway restart`

## Usage Examples

### Basic Code Generation
```json
{
  "content": "Write a Python function to calculate factorial",
  "mode": "composer"
}
```

### Code Refactoring
```json
{
  "content": "Refactor this JavaScript code to use async/await",
  "mode": "chat"
}
```

### Debugging Help
```json
{
  "content": "Why is my React component not updating when state changes?",
  "mode": "chat"
}
```

## Modes

- **composer** (default): Opens Cursor's composer panel (Ctrl+I) for inline code generation
- **chat**: Opens Cursor's chat panel (Ctrl+L) for conversational programming assistance

## Service Management

The Python service starts automatically when the skill is first used. You can also manage it manually:

- **Start service**: `bash scripts/start_service.sh`
- **Stop service**: `pkill -f cursor_handler.py`
- **Check status**: `curl http://127.0.0.1:8000/`

## Troubleshooting

### Common Issues

1. **"Service not responding"**
   - Check if service is running: `ps aux | grep cursor_handler`
   - Start it manually: `bash scripts/start_service.sh`

2. **"Cursor not responding to shortcuts"**
   - Ensure Cursor is the active, maximized window
   - Check if xdotool is installed: `which xdotool`
   - Test manually: `xdotool key ctrl+i`

3. **"Clipboard not working"**
   - Check if xclip is installed: `which xclip`
   - Test manually: `echo "test" | xclip -selection clipboard`

### Logs
Service logs are written to `/tmp/cursor_service.log`

## Notes

- The service runs on port 8000 by default
- Cursor must be open and maximized for automation to work
- The service starts automatically on first use
- No external dependencies beyond system tools (xdotool, xclip)