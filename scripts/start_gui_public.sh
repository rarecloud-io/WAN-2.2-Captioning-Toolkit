#!/bin/bash

# WAN 2.2 Captioning Toolkit - GUI Launcher
# Starts the web-based GUI interface with public sharing

echo "🌐 Starting WAN 2.2 Captioning GUI..."
echo "📡 Launching with public sharing enabled..."
echo ""

# Start the GUI with public sharing
wd-llm-caption-gui --share --server_port 7860

echo ""
echo "🔗 GUI is now running!"
echo "📱 Access it from any device using the provided URL"
