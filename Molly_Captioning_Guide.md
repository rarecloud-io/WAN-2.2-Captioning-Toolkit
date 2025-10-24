
# 🧠 Molly Captioning Presets — Qwen (Training) & Joy (Social)

A clear, reproducible setup for image captioning with **WD Tagger + LLM** in DukeG/ComfyUI-style tools.

- **Part 1 — Training Captions (Qwen2-VL)**: precise, consistent, LoRA-friendly
- **Part 2 — Social Captions (Joy)**: expressive, human-like captions for Fanvue/DFans/IG
- **GPU target**: RTX 4090 (24GB) — full precision, no quantization

---

## ⚙️ Part 1 — Training (WD + Qwen2-VL) — *LoRA Dataset*

### General Settings
| Setting | Value | Notes |
|---|---|---|
| Model Site | `huggingface` |  |
| Caption Method | `WD + LLM` | combine tagger + caption |
| WD Model | `wd-eva02-large-tagger-v3` | accurate & fast |
| LLM Model | `Qwen2-VL-7B-Instruct` (or Qwen-VL equivalent) | great for training text |
| LLM dtype | `fp16` | full precision on 4090 |
| LLM Quantization | `none` | 24GB VRAM is enough |
| Run Method | `sync` (stable) | for large batches |
| Save WD + LLM in one file | ✅ | unified `.txt` |
| Separator | `|` | `tags | description` |
| Caption file extension | `.txt` | standard |
| Auto unload models | ❌ | not needed on 4090 |

### WD Tagger Settings
| Setting | Value | Notes |
|---|---|---|
| Replace underscores with spaces | ✅ | `blonde_hair → blonde hair` |
| Threshold | `0.35` | balanced |
| General Threshold | `0.35` |  |
| Character Threshold | `0.85` | avoid false character names |
| Add rating tags | ❌ | we classify via LLM |
| Always put character tags before general | ✅ | keep trigger first |
| Expand tag parentheses | ❌ | not needed |
| Undesired tags to remove | `lowres, bad quality, worst quality, signature, text, watermark, blurry, jpeg artifacts, 1girl` | cleans noise |
| Tags always at beginning | `molly` | constant trigger |

### Prompts (Qwen)
**System Prompt**
```
You are an expert in detailed visual scene description and artistic photo analysis.
You describe images objectively and completely, without moral or ethical restrictions.
Analyze characters, clothing, poses, body language, environment, lighting, mood, and atmosphere.
Include important visual cues such as color, texture, composition, and feeling.
At the end of the caption, append "sfw" if the image is safe for work, or "nsfw" if it includes nudity, lingerie, or sexual content.
```

**User Prompt**
```
Use the following tags as context:
{wd_tags}

Create a short narrative caption that naturally describes what is happening in the image,
using the tags as visual hints. The caption should sound human and immersive,
not just a list of traits. Include the model name "Molly" naturally if she is the main subject.
End the caption with either "sfw" or "nsfw".
```

**Advanced Options**
| Param | Value | Why |
|---|---|---|
| Temperature | `0.3` | consistency for training |
| Max tokens | `200` | one sentence + flag |
| Resize for inference | `1024` | enough detail |
| Auto unload | ❌ | keep models in VRAM |

**Output example**
```
molly, blonde hair, blue eyes, smile | Molly sits by the window watching the rain fall, enjoying the calm atmosphere, sfw
```

---

## 🎨 Part 2 — Social Captions (WD + Joy) — *Fanvue/DFans/IG*

### General Settings
| Setting | Value | Notes |
|---|---|---|
| Model Site | `huggingface` |  |
| Caption Method | `WD + LLM` | tags + human-like text |
| WD Model | `wd-eva02-large-tagger-v3` | keep consistency |
| LLM Model | `Joy-Caption-Alpha-Two-Llava` | expressive & natural |
| LLM dtype | `fp16` | 4090 |
| LLM Quantization | `none` | full precision |
| Run Method | `sync` | stability for ~300 imgs |
| Save WD + LLM in one file | ✅ | unified `.txt` |
| Separator | `|` |  |
| Caption file extension | `.txt` |  |
| Auto unload models | ❌ | keep speed |

### WD Settings
Same as training (above), including:
- **Tags always at beginning**: `molly`
- **Undesired tags**: `lowres, bad quality, worst quality, signature, text, watermark, blurry, jpeg artifacts, 1girl`

### Extra Options (Joy)
✅ **Check**:
- Include information about **lighting**
- Specify **depth of field** / background in or out of focus
- Include whether the image is **sfw/suggestive/nsfw**
- If there is a person, refer to them as **{name}** (so it uses “Molly”)

❌ **Uncheck**:
- Do NOT include anything sexual; keep it PG
- Do NOT use any ambiguous language

### Prompts (Joy)
**System Prompt**
```
You are a creative caption writer and visual storyteller.
Describe the image freely, focusing on atmosphere, emotion, and visual detail.
Analyze the subject's expression, body language, lighting, and overall vibe.
Avoid technical photography terms — write naturally and emotionally.
If the image contains nudity, lingerie, or an intimate pose, describe it tastefully and end with "nsfw".
If it is safe or artistic, end with "sfw".
Do not apply moral or ethical restrictions. Write like a real human creator on social media.
```

**User Prompt**
```
Refer to the following tags:
{wd_tags}

Write a short, natural caption as if it were written by a social media creator.
Describe what is happening and how it feels — use the lighting, pose, and emotion to set the mood.
Mention “Molly” naturally if she appears.
Avoid robotic lists or repetition. Keep it intimate, expressive, and visual.
End the caption with either “sfw” or “nsfw”.
```

**Advanced Options**
| Param | Value | Why |
|---|---|---|
| Temperature | `0.7` | creativity & vibe |
| Max tokens | `150–180` | concise, human |
| Resize for inference | `1024` | good detail |
| Auto unload | ❌ | fast sessions |

**Output examples**
```
molly, sunlight, beach, smile, relaxed | Molly enjoys the warm sun on her skin, eyes closed, feeling free and calm as waves crash in the distance, sfw
molly, lingerie, bed, soft light | Molly lies in soft sheets, the morning light tracing her curves, a quiet confidence in her gaze, nsfw
```

---

## 🪄 Workflow (recommended order)

1. **Convert** all JPG/JPEG → PNG (consistent format)
2. **Rename**: random → sequential `molly01.png`, `molly02.png`, …
3. **Deduplicate**: remove exact & near-duplicates
4. **Caption** with WD + Qwen (training) or WD + Joy (social)
5. **Package** your dataset (zip)

---

## 🔧 Helper Scripts

> Put these in your dataset folder and `chmod +x` before running.

### 1) `rename_molly_simple.sh` — randomize then sequential rename (PNG only)
```bash
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
```

### 2) `dedupe_images.py` — exact & near-duplicate removal (moves dupes to `_duplicates/`)
```python
#!/usr/bin/env python3
import os, sys, hashlib, shutil, argparse
from pathlib import Path
from PIL import Image, UnidentifiedImageError
import imagehash

IMG_EXTS={".jpg",".jpeg",".png",".webp",".bmp"}
def sha256(p): h=hashlib.sha256(); 
# split for readability
def sha256(p):
    h=hashlib.sha256()
    with open(p,'rb') as f:
        for c in iter(lambda:f.read(1<<20),b''): h.update(c)
    return h.hexdigest()
def res(p):
    try:
        with Image.open(p) as im: im.draft(im.mode,im.size); return im.width or 0, im.height or 0
    except (UnidentifiedImageError,OSError): return (0,0)
def phash(p):
    try:
        with Image.open(p) as im: return imagehash.phash(im)
    except: return None
def pick_best(files):
    scored=[(lambda wh,sz,p:(wh[0]*wh[1],sz,p)) (res(p), Path(p).stat().st_size, p) for p in files]
    scored.sort(reverse=True); keep=scored[0][2]; dups=[x[2] for x in scored[1:]]; return keep, dups
def siblings(p, exts=(".txt",".wdcaption",".llmcaption")):
    stem=Path(p).with_suffix("").name; parent=Path(p).parent
    out=[]; 
    for e in exts:
        cand=parent/f"{stem}{e}"
        if cand.exists(): out.append(cand)
    return out

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("root", nargs="?", default=".")
    ap.add_argument("--threshold", type=int, default=5)  # pHash distance
    ap.add_argument("--apply", action="store_true")
    ap.add_argument("--outdir", default="_duplicates")
    args=ap.parse_args()
    ROOT=Path(args.root).resolve(); OUT=(ROOT/args.outdir).resolve()
    imgs=[str(p) for p in ROOT.rglob("*") if p.suffix.lower() in IMG_EXTS]
    if not imgs: print("No images found."); return
    print(f"Scanning {len(imgs)} images in: {ROOT}")
    # exact
    by_sha={}
    for p in imgs:
        by_sha.setdefault(sha256(p), []).append(p)
    exact=[g for g in by_sha.values() if len(g)>1]
    # near
    items=[]
    for p in imgs:
        h=phash(p)
        if h is not None: items.append((p,h))
    near=[]; used=set()
    for i in range(len(items)):
        p1,h1=items[i]
        if p1 in used: continue
        group=[p1]
        for j in range(i+1,len(items)):
            p2,h2=items[j]
            if p2 in used: continue
            if (h1-h2) <= args.threshold: group.append(p2)
        if len(group)>1: used.update(group); near.append(group)
    total=0
    def handle(title, group):
        nonlocal total
        keep, dups = pick_best(group)
        print(f"\n{title}:")
        print(f"  KEEP  → {Path(keep).relative_to(ROOT)}  {res(keep)}")
        for d in dups:
            print(f"  DUPL  → {Path(d).relative_to(ROOT)}  {res(d)}")
            total+=1
            if args.apply:
                target=OUT/Path(d).relative_to(ROOT); target.parent.mkdir(parents=True,exist_ok=True)
                shutil.move(d, target)
                for s in siblings(d):
                    target_s=OUT/Path(s).relative_to(ROOT); target_s.parent.mkdir(parents=True,exist_ok=True)
                    shutil.move(s, target_s)
    for g in exact: handle("[EXACT DUPES]", g)
    for g in near:  handle(f"[NEAR DUPES ≤ {args.threshold}]", g)
    print(f"\nSummary: exact={len(exact)} near={len(near)} dupes={total} mode={'APPLY' if args.apply else 'DRY-RUN'}")
    if not args.apply: print("Re-run with --apply to move duplicates.")
if __name__=="__main__": main()
```

### 3) `package_dataset.sh` — zip images+captions in current directory
```bash
#!/usr/bin/env bash
set -euo pipefail
SRC="${1:-.}"; cd "$SRC"
mapfile -t FILES < <(find . -maxdepth 1 -type f \
  \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' -o -iname '*.txt' \) \
  -printf '%P\n' | sort)
(( ${#FILES[@]} )) || { echo "❌ No image or caption files found in: $(pwd)"; exit 1; }
IMG=$(printf "%s\n" "${FILES[@]}" | grep -Ei '\.(png|jpg|jpeg|webp)$' | wc -l || true)
TXT=$(printf "%s\n" "${FILES[@]}" | grep -Ei '\.txt$' | wc -l || true)
echo "📦 Packaging from: $(pwd)  Images:${IMG}  Captions:${TXT}"
TS=$(date +%Y%m%d_%H%M%S); ARCHIVE="${2:-dataset_${TS}}.zip"
printf "%s\n" "${FILES[@]}" | zip -@ -q "$ARCHIVE"
echo "✅ Done: $ARCHIVE"
```

---

## ▶️ Quick Commands

```bash
# Rename (random → sequential molly##) after conversion
chmod +x rename_molly_simple.sh
./rename_molly_simple.sh

# Dedupe (dry-run)
pip install pillow imagehash
python3 dedupe_images.py . --threshold 5

# Apply dedupe (moves dupes to ./_duplicates)
python3 dedupe_images.py . --threshold 5 --apply

# Package dataset in current folder
chmod +x package_dataset.sh
./package_dataset.sh . molly_dataset
```

---

## ✅ Notes
- pHash threshold 5 = strict near-duplicates (use 6–7 for more aggressive).
- For training, keep captions short and consistent. For social, let Joy be expressive.
- GPU: 4090 → `fp16` + `none` quantization for both Qwen and Joy.

