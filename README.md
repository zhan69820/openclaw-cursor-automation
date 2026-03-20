# OpenClaw Cursor 自动化技能

![Cursor 自动化](https://img.shields.io/badge/OpenClaw-Skill-blue)
![Python](https://img.shields.io/badge/Python-3.6+-green)
![许可证](https://img.shields.io/badge/License-MIT-yellow)

一个允许 AI 助手通过本地 Python 自动化服务控制 Cursor 编辑器的 OpenClaw 技能。可以直接向 Cursor 发送代码指令，用于编程、代码重构、调试等任务。

## ✨ 功能特性

- **直接控制 Cursor**：向 Cursor 编辑器发送代码/指令
- **双模式支持**：
  - `composer` 模式 (Ctrl+I) - 内联代码生成
  - `chat` 模式 (Ctrl+L) - 对话式编程辅助
- **自动服务管理**：Python 服务自动启动
- **跨平台**：适用于 Linux + X11 (Ubuntu, Debian 等)
- **一键安装**：安装脚本全自动配置
- **生产就绪**：完善的错误处理、日志记录和健康检查

## 📋 前置要求

### 系统要求
- **Linux** 系统 + X11 窗口系统
- **Cursor 编辑器** 已安装并运行
- **Python 3.6+** 已安装
- **OpenClaw** 已全局安装

### 必需的系统包
```bash
sudo apt update
sudo apt install xdotool xclip
```

## 🚀 快速安装

### 方法一：一键安装（推荐）
```bash
# 克隆仓库
git clone https://github.com/zhan69820/openclaw-cursor-automation.git
cd openclaw-cursor-automation

# 运行安装脚本
bash scripts/install.sh
```

### 方法二：手动安装
```bash
# 1. 安装系统依赖
sudo apt install xdotool xclip

# 2. 克隆技能仓库
git clone https://github.com/zhan69820/openclaw-cursor-automation.git
cd openclaw-cursor-automation

# 3. 复制技能到 OpenClaw 技能目录
OPENCLAW_DIR=$(npm root -g)/openclaw
mkdir -p $OPENCLAW_DIR/skills/cursor-automation
cp -r . $OPENCLAW_DIR/skills/cursor-automation/

# 4. 配置 OpenClaw
# 在 ~/.openclaw/openclaw.json 中添加：
{
  "skills": {
    "load": {
      "extraDirs": ["'$OPENCLAW_DIR'/skills/cursor-automation"]
    }
  }
}

# 5. 重启 OpenClaw
openclaw gateway restart
```

## 🎯 使用方法

安装完成后，你可以通过 OpenClaw 使用这个技能：

### 基本示例
```
用户: 帮我写一个Python函数计算阶乘
助手: 好的，我来帮你写一个阶乘函数。

用户: 创建一个响应式HTML页面
助手: 我来帮你创建一个现代化的响应式HTML页面。

用户: 帮我调试这段JavaScript代码
助手: 让我帮你调试这段JavaScript代码。
```

### 高级用法

技能支持两种模式：

1. **Composer 模式** (Ctrl+I)：最适合代码生成和编辑
   ```json
   {
     "content": "写一个带用户认证的 Flask Web 应用",
     "mode": "composer"
   }
   ```

2. **Chat 模式** (Ctrl+L)：最适合解释和调试
   ```json
   {
     "content": "解释 React hooks 是如何工作的，并给出示例",
     "mode": "chat"
   }
   ```

## 🛠️ API 参考

### HTTP 端点
- `POST /operate_cursor` - 发送指令到 Cursor
- `GET /` - 服务状态
- `GET /health` - 健康检查

### 请求格式
```json
{
  "content": "字符串（必填）- 要发送的提示词或代码",
  "mode": "字符串（可选）- 'composer' 或 'chat'，默认为 'composer'"
}
```

### 响应格式
```json
{
  "status": "success",
  "message": "Cursor action queued: composer",
  "content_length": 42
}
```

## 📁 项目结构

```
openclaw-cursor-automation/
├── SKILL.md                    # OpenClaw 技能定义
├── README.md                   # 本文件
├── QUICKSTART.md               # 快速开始指南
├── EXAMPLES.md                 # 详细使用示例
├── LICENSE                     # MIT 许可证
├── scripts/
│   ├── cursor_handler.py       # Python 自动化服务
│   ├── install.sh             # 安装脚本
│   ├── start_service.sh       # 服务启动脚本
│   └── uninstall.sh           # 卸载脚本
└── test_installation.sh       # 安装测试脚本
```

## 🔧 服务管理

### 启动服务
```bash
bash scripts/start_service.sh
```

### 停止服务
```bash
pkill -f cursor_handler.py
```

### 检查状态
```bash
curl http://127.0.0.1:8000/
```

### 查看日志
```bash
tail -f /tmp/cursor_service.log
```

## 🐛 常见问题

### 1. 服务无响应
```bash
# 检查服务是否运行
ps aux | grep cursor_handler

# 手动启动服务
bash scripts/start_service.sh
```

### 2. Cursor 无响应
- 确保 Cursor 已打开并最大化
- 手动测试 xdotool：`xdotool key ctrl+i`
- 检查窗口焦点

### 3. 剪贴板不工作
```bash
# 测试 xclip
echo "test" | xclip -selection clipboard
xclip -selection clipboard -o
```

### 4. 权限错误
```bash
# 设置脚本可执行权限
chmod +x scripts/*.sh
chmod +x scripts/cursor_handler.py
```

## 📝 使用示例

更多详细示例请查看 [EXAMPLES.md](EXAMPLES.md)，包括：
- 各种编程语言的代码生成
- 调试和代码审查
- 架构设计
- 数据库查询
- 与 OpenClaw 工作流集成

## 🤝 贡献

欢迎贡献！以下是帮助方式：

1. **报告 Bug**：提交详细的复现步骤
2. **建议功能**：分享你的新功能想法
3. **提交 Pull Request**：
   - Fork 仓库
   - 创建功能分支
   - 修改代码
   - 提交 Pull Request

## 📄 许可证

本项目基于 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解更多。

## 🙏 致谢

- [OpenClaw](https://openclaw.ai) - 优秀的 AI 助手平台
- [Cursor](https://cursor.sh) - AI 驱动的代码编辑器
- [xdotool](https://github.com/jordansissel/xdotool) - X11 自动化工具
- [xclip](https://github.com/astrand/xclip) - 命令行剪贴板工具

## 📞 支持

- **问题反馈**： [GitHub Issues](https://github.com/zhan69820/openclaw-cursor-automation/issues)
- **讨论区**： [GitHub Discussions](https://github.com/zhan69820/openclaw-cursor-automation/discussions)

## 🔗 相关链接

- [OpenClaw 文档](https://docs.openclaw.ai)
- [Cursor 文档](https://docs.cursor.sh)
- [快速开始](QUICKSTART.md)
- [使用示例](EXAMPLES.md)

---

**⭐ 如果你觉得这个项目有用，请给个 Star！**
