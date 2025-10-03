#!/bin/bash

# WAN 2.2 Captioning Toolkit - Dataset Packager
# Creates a ZIP archive of processed dataset

echo "📦 Packaging dataset..."

# Check if there are any files to package
if ! ls *.jpg *.jpeg *.png *.txt >/dev/null 2>&1; then
    echo "❌ No image or caption files found in current directory"
    echo "   Make sure you're in the workspace directory with your processed files"
    exit 1
fi

# Create timestamp for unique filename
timestamp=$(date +"%Y%m%d_%H%M%S")
output_file="dataset_${timestamp}.zip"

echo "  Collecting files..."

# Create the ZIP archive
zip -q -r "$output_file" *.jpg *.jpeg *.png *.txt 2>/dev/null

# Check if ZIP was created successfully
if [ -f "$output_file" ]; then
    file_size=$(du -h "$output_file" | cut -f1)
    echo "✅ Created: $output_file ($file_size)"
    echo "🎯 Dataset ready for training!"
else
    echo "❌ Failed to create dataset package"
    exit 1
fi
