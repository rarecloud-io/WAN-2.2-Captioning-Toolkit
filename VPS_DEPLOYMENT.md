# VPS Deployment Guide

This guide will help you deploy the WAN 2.2 Captioning Toolkit on a VPS for testing and production use.

## 🖥️ VPS Requirements

### Minimum Specifications
- **CPU**: 2+ cores
- **RAM**: 8GB+ (16GB recommended for large datasets)
- **Storage**: 50GB+ SSD
- **GPU**: CUDA-compatible GPU (RTX 3060+ recommended)
- **OS**: Ubuntu 20.04+ or Debian 11+

### Recommended VPS Providers
- **RunPod** - GPU-optimized instances
- **Vast.ai** - Cost-effective GPU rentals
- **Google Cloud Platform** - T4/V100 instances
- **AWS** - EC2 GPU instances
- **Paperspace** - Gradient platform

## 🚀 Quick Deployment

### 1. Connect to Your VPS
```bash
ssh root@YOUR_VPS_IP
# or
ssh ubuntu@YOUR_VPS_IP
```

### 2. Clone and Install
```bash
# Update system
apt update && apt upgrade -y

# Install git if not present
apt install -y git

# Clone the repository
git clone https://github.com/rarecloud-io/WAN-2.2-Captioning-Toolkit.git
cd WAN-2.2-Captioning-Toolkit

# Run the installer
bash install.sh
```

### 3. Start the GUI
```bash
cd workspace
bash ../scripts/start_gui_public.sh
```

### 4. Access the Interface
- The script will provide a public URL (e.g., `https://xxxxx.gradio.live`)
- Use this URL to access the GUI from any device

## 🔧 Advanced Configuration

### Firewall Setup
```bash
# Allow SSH
ufw allow 22

# Allow the GUI port (if not using --share)
ufw allow 7860

# Enable firewall
ufw enable
```

### GPU Verification
```bash
# Check CUDA installation
nvidia-smi

# Test PyTorch CUDA
python3 -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"
```

### Process Management
```bash
# Run in background with nohup
nohup bash ../scripts/start_gui_public.sh > gui.log 2>&1 &

# Check if running
ps aux | grep wd-llm-caption-gui

# Stop the process
pkill -f wd-llm-caption-gui
```

## 🐳 Docker Deployment (Alternative)

If you prefer containerized deployment:

```bash
# Build the Docker image
docker build -t wan-captioning-toolkit .

# Run the container
docker run -d \
  --gpus all \
  -p 7860:7860 \
  -v $(pwd)/workspace:/app/workspace \
  --name wan-captioning \
  wan-captioning-toolkit
```

## 📊 Monitoring

### Check System Resources
```bash
# CPU and Memory usage
htop

# GPU usage
nvidia-smi -l 1

# Disk usage
df -h
```

### Log Monitoring
```bash
# View GUI logs
tail -f gui.log

# Check system logs
journalctl -f
```

## 🔒 Security Considerations

1. **Use SSH keys** instead of password authentication
2. **Configure firewall** to only allow necessary ports
3. **Regular updates** for system packages
4. **Monitor resource usage** to prevent abuse
5. **Backup important data** regularly

## 🧪 Testing Checklist

- [ ] System packages installed correctly
- [ ] Python dependencies installed
- [ ] CUDA/GPU detection working
- [ ] GUI starts without errors
- [ ] Public URL accessible
- [ ] Image upload and processing works
- [ ] Caption generation functions
- [ ] Scripts execute properly

## 🆘 Troubleshooting

### Common Issues

**CUDA not detected:**
```bash
# Reinstall CUDA toolkit
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
dpkg -i cuda-keyring_1.0-1_all.deb
apt update
apt install -y cuda-toolkit
```

**Out of memory errors:**
- Reduce batch size in GUI settings
- Close unnecessary processes
- Consider upgrading VPS RAM

**Port already in use:**
```bash
# Find process using port 7860
lsof -i :7860
# Kill the process
kill -9 PID
```

## 📈 Performance Optimization

1. **Use SSD storage** for faster I/O
2. **Allocate sufficient RAM** (16GB+ recommended)
3. **Enable GPU acceleration** for faster processing
4. **Monitor resource usage** and scale accordingly
5. **Use batch processing** for multiple images

## 🔄 Updates and Maintenance

```bash
# Update the toolkit
cd /path/to/WAN-2.2-Captioning-Toolkit
git pull origin main

# Update dependencies
pip install -r requirements.txt --upgrade

# Restart services
pkill -f wd-llm-caption-gui
bash scripts/start_gui_public.sh
```

---

**Ready to deploy! 🚀** Follow this guide to get your WAN 2.2 Captioning Toolkit running on a VPS.
