# WAN 2.2 Captioning Toolkit

A comprehensive GUI toolkit for automated image captioning using advanced AI models. This toolkit provides an easy-to-use interface for generating high-quality captions for your image datasets, with built-in cleaning and processing utilities.

## ✨ Features

- **GUI Interface**: Web-based interface accessible from any device
- **Advanced AI Models**: Powered by wd-llm-caption for high-quality caption generation
- **Batch Processing**: Process multiple images simultaneously
- **Smart Cleaning**: Automatic removal of common descriptors (eye color, face shape, etc.)
- **Trigger Management**: Add custom triggers to captions for LoRA training
- **Dataset Packaging**: Easy export of processed datasets
- **GPU Acceleration**: Optimized for CUDA-enabled systems

## 🚀 Quick Start

### Prerequisites

- Python 3.8+
- CUDA-compatible GPU (recommended)
- Ubuntu/Debian-based system (for automatic package installation)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/wan-captioning-toolkit.git
   cd wan-captioning-toolkit
   ```

2. **Run the installer:**
   ```bash
   bash install.sh
   ```

3. **Start the GUI:**
   ```bash
   cd workspace
   bash ../scripts/start_gui_public.sh
   ```

4. **Access the interface:**
   - Open your browser and go to the provided URL (usually `http://localhost:7860`)
   - The interface will be accessible publicly if using `--share` flag

## 📁 Project Structure

```
wan-captioning-toolkit/
├── install.sh                 # Main installation script
├── scripts/
│   ├── start_gui_public.sh    # GUI launcher
│   ├── clean_captions.sh      # Caption cleaning utility
│   ├── add_trigger.sh         # Trigger management
│   └── package_dataset.sh     # Dataset packaging
├── workspace/                 # Working directory for images and captions
├── requirements.txt           # Python dependencies
└── README.md                  # This file
```

## 🛠️ Usage

### Basic Workflow

1. **Prepare your images**: Place your images in the `workspace/` directory
2. **Start the GUI**: Run the GUI launcher script
3. **Generate captions**: Use the web interface to process your images
4. **Clean captions**: Use the cleaning script to remove unwanted descriptors
5. **Add triggers**: Add custom triggers for LoRA training
6. **Package dataset**: Export your processed dataset

### Scripts Overview

#### `scripts/start_gui_public.sh`
Launches the web-based GUI interface with public sharing enabled.

#### `scripts/clean_captions.sh`
Removes common descriptors from caption files:
- Eye color descriptions (blue eyes, brown eyes)
- Face shape descriptions (oval face)
- Extra whitespace

#### `scripts/add_trigger.sh`
Adds custom triggers to caption files for LoRA training:
```bash
bash add_trigger.sh "your_trigger" "man"  # Adds "your_trigger man" to all captions
```

#### `scripts/package_dataset.sh`
Creates a ZIP archive of your processed dataset containing images and caption files.

## 🔧 Configuration

### GPU Requirements
The toolkit automatically installs PyTorch with CUDA 12.1 support. For optimal performance:
- Use a CUDA-compatible GPU with at least 8GB VRAM
- Ensure CUDA drivers are properly installed

### Customization
You can modify the cleaning patterns in `scripts/clean_captions.sh` to remove or add specific descriptors based on your needs.

## 📦 Dependencies

- **PyTorch**: Deep learning framework with CUDA support
- **wd-llm-caption**: Advanced captioning model
- **onnxruntime-gpu**: GPU-accelerated inference
- **Gradio**: Web interface framework

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [wd-llm-caption](https://github.com/your-repo/wd-llm-caption) for the advanced captioning capabilities
- PyTorch team for the excellent deep learning framework
- The open-source community for inspiration and support

## 📞 Support

If you encounter any issues or have questions:
1. Check the [Issues](https://github.com/YOUR_USERNAME/wan-captioning-toolkit/issues) page
2. Create a new issue with detailed information about your problem
3. Include system specifications and error messages

---

**Happy Captioning! 🎨✨**
