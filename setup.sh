#!/bin/bash

mkdir -p scripts workspace

# Main installer
cat > install.sh << 'EOF'
#!/bin/bash
set -e
echo "🚀 Installing WAN 2.2 Captioning Toolkit..."
apt-get update -qq && apt-get install -y git wget unzip curl > /dev/null 2>&1
echo "✓ System packages"
pip install -q torch torchvision --index-url https://download.pytorch.org/whl/cu121
echo "✓ PyTorch"
pip install -q wd-llm-caption onnxruntime-gpu
echo "✓ Captioning tools"
chmod +x scripts/*.sh
echo "✅ Done!"
echo ""
echo "Next: cd workspace && bash ../scripts/start_gui_public.sh"
EOF

# GUI launcher
cat > scripts/start_gui_public.sh << 'EOF'
#!/bin/bash
echo "🌐 Starting GUI..."
wd-llm-caption-gui --share --server_port 7860
EOF

# Cleanup
cat > scripts/clean_captions.sh << 'EOF'
#!/bin/bash
echo "🧹 Cleaning..."
for f in *.txt; do
  [ -f "$f" ] || continue
  sed -i 's/\bblue eyes\b//gi' "$f"
  sed -i 's/\bbrown eyes\b//gi' "$f"
  sed -i 's/\boval face\b//gi' "$f"
  sed -i 's/  */ /g' "$f"
done
echo "✓ Done"
EOF

# Add trigger
cat > scripts/add_trigger.sh << 'EOF'
#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: bash add_trigger.sh TRIGGER [gender]"
  exit 1
fi
TRIGGER="$1"
GENDER="${2:-man}"
for f in *.txt; do
  [ -f "$f" ] || continue
  sed -i "1s/^/$TRIGGER $GENDER /" "$f"
done
echo "✓ Added: $TRIGGER $GENDER"
EOF

# Package
cat > scripts/package_dataset.sh << 'EOF'
#!/bin/bash
echo "📦 Packaging..."
zip -q -r dataset.zip *.{jpg,jpeg,png,txt} 2>/dev/null
echo "✓ Created dataset.zip"
EOF

# README
cat > README.md << 'EOF'
# WAN 2.2 Captioning Toolkit

GUI tool for captioning images.

## Install
```bash
git clone https://github.com/YOUR_USERNAME/wan-captioning-toolkit.git
cd wan-captioning-toolkit
bash install.sh