
#!/usr/bin/env bash
set -euo pipefail
SRC="${1:-.}"; cd "$SRC"
mapfile -t FILES < <(find . -maxdepth 1 -type f   \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' -o -iname '*.txt' \)   -printf '%P
' | sort)
(( ${#FILES[@]} )) || { echo "❌ No image or caption files found in: $(pwd)"; exit 1; }
IMG=$(printf "%s
" "${FILES[@]}" | grep -Ei '\.(png|jpg|jpeg|webp)$' | wc -l || true)
TXT=$(printf "%s
" "${FILES[@]}" | grep -Ei '\.txt$' | wc -l || true)
echo "📦 Packaging from: $(pwd)  Images:${IMG}  Captions:${TXT}"
TS=$(date +%Y%m%d_%H%M%S); ARCHIVE="${2:-dataset_${TS}}.zip"
printf "%s
" "${FILES[@]}" | zip -@ -q "$ARCHIVE"
echo "✅ Done: $ARCHIVE"
