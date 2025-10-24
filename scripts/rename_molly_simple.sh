
#!/usr/bin/env bash
set -euo pipefail
if command -v openssl >/dev/null 2>&1; then rand8(){ openssl rand -hex 4; }
elif command -v uuidgen >/dev/null 2>&1; then rand8(){ uuidgen | tr -d '-' | cut -c1-8; }
else echo "Need openssl or uuidgen" >&2; exit 1; fi
shopt -s nullglob
for p in *.png *.PNG; do base="${p%.*}"; r="tmp_$(rand8)"; while [[ -e "${r}.png" ]]; do r="tmp_$(rand8)"; done; mv -v -- "${base}.png" "${r}.png"; done
pngs=( *.png ); (( ${#pngs[@]} )) || { echo "No PNGs"; exit 1; }
IFS=$'\n' read -r -d '' -a sorted < <(ls -1v *.png && printf '\0')
count=${#sorted[@]}; digits=${#count}; (( digits<2 )) && digits=2
i=1; for p in "${sorted[@]}"; do ob="${p%.*}"; nb=$(printf "molly%0${digits}d" "$i"); while [[ -e "${nb}.png" ]]; do ((i++)); nb=$(printf "molly%0${digits}d" "$i"); done; mv -v -- "${ob}.png" "${nb}.png"; ((i++)); done
echo "Done."
