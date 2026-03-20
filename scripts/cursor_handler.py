#!/usr/bin/env python3
"""
Cursor Automation Service for OpenClaw
This service allows OpenClaw to control Cursor editor via xdotool automation.
"""

import os
import time
import json
import subprocess
import threading
from http.server import HTTPServer, BaseHTTPRequestHandler
import sys

def check_dependencies():
    """Check if required system tools are installed"""
    required_tools = ['xdotool', 'xclip']
    missing = []
    
    for tool in required_tools:
        try:
            subprocess.run(['which', tool], check=True, capture_output=True)
        except subprocess.CalledProcessError:
            missing.append(tool)
    
    if missing:
        print(f"ERROR: Missing required tools: {', '.join(missing)}")
        print(f"Please install with: sudo apt install {' '.join(missing)}")
        return False
    
    return True

def copy_to_clipboard(text):
    """使用 xclip 复制文本到剪贴板"""
    try:
        process = subprocess.Popen(['xclip', '-selection', 'clipboard'], 
                                  stdin=subprocess.PIPE,
                                  stdout=subprocess.DEVNULL,
                                  stderr=subprocess.DEVNULL)
        process.communicate(input=text.encode('utf-8'), timeout=2)
        return True
    except Exception as e:
        print(f"Error copying to clipboard: {e}")
        return False

def ubuntu_automation_logic(content: str, mode: str):
    """
    具体的本地执行逻辑：
    1. 写入剪贴板
    2. 触发快捷键
    3. 粘贴并回车
    """
    print(f"[Cursor Automation] Processing: {mode} mode")
    print(f"[Cursor Automation] Content length: {len(content)} characters")
    
    # 1. 写入剪贴板
    if not copy_to_clipboard(content):
        print("[Cursor Automation] Failed to copy to clipboard")
        return False
    
    # 2. 触发快捷键
    shortcut = "ctrl+i" if mode == "composer" else "ctrl+l"
    print(f"[Cursor Automation] Triggering shortcut: {shortcut}")
    
    try:
        subprocess.run(['xdotool', 'key', shortcut], check=True, timeout=2)
    except subprocess.CalledProcessError as e:
        print(f"[Cursor Automation] Error triggering shortcut: {e}")
        return False
    except subprocess.TimeoutExpired:
        print("[Cursor Automation] Timeout triggering shortcut")
        return False
    
    time.sleep(0.5)  # 等待窗口打开
    
    # 3. 粘贴并回车
    print("[Cursor Automation] Pasting content...")
    try:
        subprocess.run(['xdotool', 'key', 'ctrl+v'], check=True, timeout=2)
        time.sleep(0.2)
        subprocess.run(['xdotool', 'key', 'Return'], check=True, timeout=2)
    except subprocess.CalledProcessError as e:
        print(f"[Cursor Automation] Error pasting/entering: {e}")
        return False
    
    print("[Cursor Automation] Action completed successfully")
    return True

class CursorHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        if self.path == '/operate_cursor':
            content_length = int(self.headers.get('Content-Length', 0))
            
            if content_length == 0:
                self.send_error_response(400, "Empty request body")
                return
            
            post_data = self.rfile.read(content_length)
            
            try:
                data = json.loads(post_data.decode('utf-8'))
                content = data.get('content', '')
                mode = data.get('mode', 'composer')
                
                if not content:
                    self.send_error_response(400, "Content is required")
                    return
                
                if mode not in ['composer', 'chat']:
                    self.send_error_response(400, "Mode must be 'composer' or 'chat'")
                    return
                
                # 在后台执行自动化逻辑
                thread = threading.Thread(target=ubuntu_automation_logic, args=(content, mode))
                thread.daemon = True
                thread.start()
                
                self.send_success_response({
                    "status": "success", 
                    "message": f"Cursor action queued: {mode}",
                    "content_length": len(content)
                })
                
            except json.JSONDecodeError:
                self.send_error_response(400, "Invalid JSON")
            except Exception as e:
                self.send_error_response(500, f"Internal error: {str(e)}")
        else:
            self.send_error_response(404, "Not found")
    
    def do_GET(self):
        if self.path == '/':
            self.send_success_response({
                "message": "Cursor automation service is running",
                "version": "1.0.0",
                "endpoints": {
                    "POST /operate_cursor": "Send instructions to Cursor",
                    "GET /": "Service status"
                }
            })
        elif self.path == '/health':
            self.send_success_response({"status": "healthy"})
        else:
            self.send_error_response(404, "Not found")
    
    def send_success_response(self, data):
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode('utf-8'))
    
    def send_error_response(self, code, message):
        self.send_response(code)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps({"status": "error", "message": message}).encode('utf-8'))
    
    def log_message(self, format, *args):
        # 减少日志输出，只记录重要信息
        if self.path != '/health':  # 不记录健康检查
            print(f"[HTTP] {self.address_string()} - {format % args}")

def run_server(port=8000):
    """启动 HTTP 服务器"""
    if not check_dependencies():
        print("Exiting due to missing dependencies")
        sys.exit(1)
    
    server_address = ('127.0.0.1', port)
    
    try:
        httpd = HTTPServer(server_address, CursorHandler)
        print(f"==========================================")
        print(f"Cursor Automation Service")
        print(f"==========================================")
        print(f"Server running on http://{server_address[0]}:{server_address[1]}")
        print(f"Endpoints:")
        print(f"  POST /operate_cursor - Send instructions to Cursor")
        print(f"  GET /               - Service status")
        print(f"  GET /health         - Health check")
        print(f"==========================================")
        print(f"Press Ctrl+C to stop the server")
        print(f"==========================================")
        
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n[INFO] Server stopped by user")
    except Exception as e:
        print(f"[ERROR] Failed to start server: {e}")
        sys.exit(1)

if __name__ == '__main__':
    # 检查是否指定了端口
    port = 8000
    if len(sys.argv) > 1:
        try:
            port = int(sys.argv[1])
        except ValueError:
            print(f"Invalid port: {sys.argv[1]}, using default port 8000")
    
    run_server(port)