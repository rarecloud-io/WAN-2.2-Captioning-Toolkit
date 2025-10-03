#!/bin/bash

# WAN 2.2 Captioning Toolkit Installer
# This script sets up the complete environment for the captioning toolkit

set -e

echo "🚀 Installing WAN 2.2 Captioning Toolkit..."

# Create necessary directories
mkdir -p scripts workspace

# Update system packages (Ubuntu/Debian)
if command -v apt-get &> /dev/null; then
    echo "📦 Updating system packages..."
    apt-get update -qq && apt-get install -y git wget unzip curl > /dev/null 2>&1
    echo "✓ System packages installed"
fi

# Install Python dependencies
echo "🐍 Installing Python dependencies..."
pip install -q torch torchvision --index-url https://download.pytorch.org/whl/cu121
echo "✓ PyTorch with CUDA 12.1 support"

pip install -q wd-llm-caption onnxruntime-gpu
echo "✓ Captioning tools installed"

# Make scripts executable
chmod +x scripts/*.sh 2>/dev/null || true

echo ""
echo "✅ Installation complete!"
echo ""
echo "📋 Next steps:"
echo "1. cd workspace"
echo "2. Place your images in the workspace directory"
echo "3. Run: bash ../scripts/start_gui_public.sh"
echo "4. Open the provided URL in your browser"
echo ""
echo "🎨 Happy captioning!"
