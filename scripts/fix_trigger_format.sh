#!/bin/bash

# WAN 2.2 Captioning Toolkit - Fix Trigger Format
# Removes quotes and fixes spacing in trigger format

echo "🔧 Fixing trigger format in caption files..."

# Counter for processed files
count=0

# Process all .txt files in current directory
for f in *.txt; do
    # Skip if file doesn't exist
    [ -f "$f" ] || continue
    
    echo "  Processing: $f"
    
    # Fix the trigger format
    # Remove quotes around gender and fix spacing
    sed -i 's/^bia "woman"/bia woman/' "$f"
    sed -i 's/^bia "man"/bia man/' "$f"
    
    # Fix any other quote issues
    sed -i 's/^bia "\([^"]*\)"/bia \1/' "$f"
    
    count=$((count + 1))
done

echo ""
echo "✅ Fixed trigger format in $count caption files"
echo "🎯 Format changed from 'bia \"woman\"' to 'bia woman'"
