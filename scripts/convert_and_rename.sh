
#!/usr/bin/env bash
set -euo pipefail

# convert_and_rename.sh
# 1) Convert all JPG/JPEG -> PNG in-place (requires ImageMagick `convert`)
# 2) Randomize all PNG names to avoid collisions (openssl/uuidgen)
# 3) Sequentially rename to molly01.png, molly02.png, ... (images only)
#
# Usage:
#   chmod +x convert_and_rename.sh
#   ./convert_and_rename.sh         # run inside your images folder
#
# Notes:
# - If ImageMagick is missing: apt update && apt install -y imagemagick

# --- deps ---
command -v convert >/dev/null 2>&1 || { echo "❌ ImageMagick 'convert' not found."; exit 1; }
if command -v openssl >/dev/null 2>&1; then rand8(){ openssl rand -hex 4; }
elif command -v uuidgen >/dev/null 2>&1; then rand8(){ uuidgen | tr -d '-' | cut -c1-8; }
else echo "❌ Need 'openssl' or 'uuidgen' for random names." >&2; exit 1; fi

shopt -s nullglob

echo "🔄 Converting JPG/JPEG -> PNG (in-place)..."
for f in *.jpg *.JPG *.jpeg *.JPEG; do
  [ -f "$f" ] || continue
  base="${f%.*}"
  out="${base}.png"
  if [[ -e "$out" ]]; then
    # avoid overwrite if a PNG with the same base already exists
    r="conv_$(rand8)"
    out="${base}_${r}.png"
  fi
  convert "$f" "$out"
  rm -f -- "$f"
  echo "  ✅ $f → ${out##*/}"
done
echo "✅ Conversion step done."

# Make sure we have PNGs now
pngs=( *.png *.PNG )
(( ${#pngs[@]} > 0 )) || { echo "❌ No PNG files found."; exit 1; }

echo "🎲 Randomizing PNG filenames to avoid collisions..."
for p in "${pngs[@]}"; do
  base="${p%.*}"
  r="tmp_$(rand8)"
  while [[ -e "${r}.png" ]]; do r="tmp_$(rand8)"; done
  mv -v -- "${base}.png" "${r}.png" || true
done
echo "✅ Randomization step done."

echo "🔢 Sequential rename to mollyNN.png ..."
# natural sort
IFS=$'\n' read -r -d '' -a sorted < <(ls -1v *.png && printf '\0')
count=${#sorted[@]}
digits=${#count}; (( digits < 2 )) && digits=2

i=1
for p in "${sorted[@]}"; do
  newbase=$(printf "molly%0${digits}d" "$i")
  while [[ -e "${newbase}.png" ]]; do
    ((i++))
    newbase=$(printf "molly%0${digits}d" "$i")
  done
  mv -v -- "$p" "${newbase}.png"
  ((i++))
done
echo "✅ Done. Images are now molly01.png, molly02.png, ..."
