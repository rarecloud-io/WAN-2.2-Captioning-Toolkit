#!/bin/bash

# WAN 2.2 Captioning Toolkit - Caption Cleaner
# Removes common descriptors and cleans up caption files

echo "🧹 Cleaning caption files..."

# Counter for processed files
count=0

# Process all .txt files in current directory
for f in *.txt; do
    # Skip if file doesn't exist
    [ -f "$f" ] || continue
    
    echo "  Processing: $f"
    
    # Remove common descriptors
    sed -i 's/\bblue eyes\b//gi' "$f"
    sed -i 's/\bbrown eyes\b//gi' "$f"
    sed -i 's/\bgreen eyes\b//gi' "$f"
    sed -i 's/\bhazel eyes\b//gi' "$f"
    sed -i 's/\boval face\b//gi' "$f"
    sed -i 's/\bround face\b//gi' "$f"
    sed -i 's/\bsquare face\b//gi' "$f"
    
    # Clean up extra whitespace
    sed -i 's/  */ /g' "$f"
    sed -i 's/^ *//' "$f"
    sed -i 's/ *$//' "$f"
    
    # Remove empty lines
    sed -i '/^$/d' "$f"
    
    count=$((count + 1))
done

echo "✓ Cleaned $count caption files"
echo "🎯 Removed common descriptors and cleaned formatting"
