# 🚀 快速开始指南

5 分钟内快速上手 Cursor 自动化技能！

## 一键安装

```bash
# 克隆并安装
git clone https://github.com/zhan69820/openclaw-cursor-automation.git && cd openclaw-cursor-automation && bash scripts/install.sh
```

或使用直接安装脚本：

```bash
# 直接安装（需要 curl）
curl -s https://raw.githubusercontent.com/zhan69820/openclaw-cursor-automation/main/scripts/install.sh | bash
```

## 分步安装

### 1. 安装系统依赖
```bash
sudo apt update
sudo apt install xdotool xclip
```

### 2. 克隆仓库
```bash
git clone https://github.com/zhan69820/openclaw-cursor-automation.git
cd openclaw-cursor-automation
```

### 3. 运行安装脚本
```bash
bash scripts/install.sh
```

### 4. 验证安装
```bash
# 检查服务状态
curl http://127.0.0.1:8000/

# 测试技能
curl -X POST http://127.0.0.1:8000/operate_cursor \
  -H "Content-Type: application/json" \
  -d '{"content": "Hello Cursor!", "mode": "composer"}'
```

## 🎯 首次使用

1. **打开 Cursor 编辑器** 并最大化窗口
2. **通过 OpenClaw 测试**：
   ```
   用户: 帮我写一个简单的Python函数
   助手: 好的，我来帮你写一个Python函数。
   ```
3. **观察 Cursor** 自动打开 composer 并生成代码

## 📋 常用命令

### 服务管理
```bash
# 启动服务
bash scripts/start_service.sh

# 停止服务
pkill -f cursor_handler.py

# 检查状态
curl http://127.0.0.1:8000/

# 查看日志
tail -f /tmp/cursor_service.log
```

### 技能测试
```bash
# 使用 curl 测试
curl -X POST http://127.0.0.1:8000/operate_cursor \
  -H "Content-Type: application/json" \
  -d '{"content": "写一个计算阶乘的Python函数", "mode": "composer"}'
```

## 🐛 快速排错

### 问题：服务无响应
```bash
# 重启服务
pkill -f cursor_handler.py
bash scripts/start_service.sh
```

### 问题：Cursor 无响应
- 确保 Cursor 是活动窗口且已最大化
- 手动测试：`xdotool key ctrl+i`

### 问题：剪贴板不工作
```bash
# 测试剪贴板
echo "test" | xclip -selection clipboard
xclip -selection clipboard -o
```

## 🔗 常用链接

- **完整文档**: [README.md](README.md)
- **使用示例**: [EXAMPLES.md](EXAMPLES.md)
- **安装脚本**: [scripts/install.sh](scripts/install.sh)
- **GitHub 仓库**: https://github.com/zhan69820/openclaw-cursor-automation

## ⚡ 使用技巧

1. **保持 Cursor 最大化** 以获得最佳效果
2. **使用 composer 模式** 进行代码生成
3. **使用 chat 模式** 进行解释和调试
4. **查看日志** 如果出现问题：`tail -f /tmp/cursor_service.log`

## 🆘 需要帮助？

- **GitHub Issues**: https://github.com/zhan69820/openclaw-cursor-automation/issues
- **测试安装**: `bash test_installation.sh`

---

**享受 Cursor 自动化编程的乐趣！🎉**
