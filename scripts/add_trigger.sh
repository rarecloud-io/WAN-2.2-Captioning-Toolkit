#!/bin/bash

# WAN 2.2 Captioning Toolkit - Trigger Manager
# Adds custom triggers to caption files for LoRA training

# Check if trigger is provided
if [ -z "$1" ]; then
    echo "❌ Error: Trigger not provided"
    echo ""
    echo "Usage: bash add_trigger.sh TRIGGER [gender]"
    echo ""
    echo "Examples:"
    echo "  bash add_trigger.sh 'sks' 'man'"
    echo "  bash add_trigger.sh 'xyz' 'woman'"
    echo "  bash add_trigger.sh 'abc'"
    echo ""
    exit 1
fi

TRIGGER="$1"
GENDER="${2:-man}"

echo "🏷️  Adding trigger: '$TRIGGER $GENDER'"
echo ""

# Counter for processed files
count=0

# Process all .txt files in current directory
for f in *.txt; do
    # Skip if file doesn't exist
    [ -f "$f" ] || continue
    
    echo "  Processing: $f"
    
    # Add trigger to the beginning of each caption
    sed -i "1s/^/$TRIGGER $GENDER /" "$f"
    
    count=$((count + 1))
done

echo ""
echo "✅ Successfully added '$TRIGGER $GENDER' to $count caption files"
echo "🎯 Ready for LoRA training!"
