#!/bin/bash
# Test script for Cursor Automation Skill installation

echo "=========================================="
echo "Cursor Automation Skill - Installation Test"
echo "=========================================="

# Test 1: Check Python
echo "1. Testing Python..."
if command -v python3 &> /dev/null; then
    echo "✓ Python3: $(python3 --version)"
else
    echo "✗ Python3 not found"
    exit 1
fi

# Test 2: Check system tools
echo ""
echo "2. Testing system tools..."
for tool in xdotool xclip; do
    if command -v $tool &> /dev/null; then
        echo "✓ $tool: installed"
    else
        echo "✗ $tool not found"
        echo "  Install with: sudo apt install $tool"
    fi
done

# Test 3: Check OpenClaw
echo ""
echo "3. Testing OpenClaw..."
if command -v openclaw &> /dev/null; then
    echo "✓ OpenClaw: installed"
    echo "  Version: $(openclaw --version 2>/dev/null || echo 'unknown')"
else
    echo "✗ OpenClaw not found"
    echo "  Install with: npm install -g openclaw"
fi

# Test 4: Check skill files
echo ""
echo "4. Testing skill files..."
REQUIRED_FILES=("SKILL.md" "scripts/cursor_handler.py" "scripts/install.sh")
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✓ $file: exists"
    else
        echo "✗ $file: missing"
    fi
done

# Test 5: Check file permissions
echo ""
echo "5. Testing file permissions..."
EXECUTABLE_FILES=("scripts/cursor_handler.py" "scripts/install.sh" "scripts/start_service.sh")
for file in "${EXECUTABLE_FILES[@]}"; do
    if [ -f "$file" ] && [ -x "$file" ]; then
        echo "✓ $file: executable"
    elif [ -f "$file" ]; then
        echo "⚠ $file: not executable (run: chmod +x $file)"
    fi
done

# Test 6: Test Python script syntax
echo ""
echo "6. Testing Python script syntax..."
if [ -f "scripts/cursor_handler.py" ]; then
    if python3 -m py_compile scripts/cursor_handler.py 2>/dev/null; then
        echo "✓ Python script syntax: valid"
        rm -f scripts/cursor_handler.pyc 2>/dev/null
    else
        echo "✗ Python script syntax: invalid"
    fi
fi

# Test 7: Test installation script
echo ""
echo "7. Testing installation script..."
if [ -f "scripts/install.sh" ]; then
    if bash -n scripts/install.sh 2>/dev/null; then
        echo "✓ Installation script syntax: valid"
    else
        echo "✗ Installation script syntax: invalid"
    fi
fi

echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo ""
echo "If all tests pass, you can install with:"
echo "  bash scripts/install.sh"
echo ""
echo "Quick installation test:"
echo "  curl -s https://raw.githubusercontent.com/nice010/openclaw-cursor-automation/main/scripts/install.sh | bash"
echo ""
echo "Repository URL:"
echo "  https://github.com/nice010/openclaw-cursor-automation"
echo ""
echo "Issues and feedback:"
echo "  https://github.com/nice010/openclaw-cursor-automation/issues"
echo "=========================================="