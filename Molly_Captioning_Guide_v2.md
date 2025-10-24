
# 🧠 Molly Captioning Guide (v2)
Comprehensive guide for **training** and **social captioning** setups using WD + Qwen and Joy models.

---

## 📂 STRUCTURE
- [1️⃣ Qwen + WD (Training Captions)](#1️⃣-qwen--wd-training-captions)
- [2️⃣ Joy (Social Media Captions)](#2️⃣-joy-social-media-captions)
- [3️⃣ Tools & Scripts](#3️⃣-tools--scripts)
- [4️⃣ Recommended Workflow](#4️⃣-recommended-workflow)

---

## 1️⃣ Qwen + WD (Training Captions)

### 🧩 Run Method
`sync` — stable, predictable order for batch processing.  
Use `queue` only if running parallel jobs.

### ⚙️ LLM & Tagger Setup
| Setting | Value |
|----------|--------|
| **WD model** | `wd-eva02-large-tagger-v3` |
| **LLM model** | `Qwen2-VL-7B-Instruct` |
| **Run Method** | `sync` |
| **LLM dtype** | `fp16` |
| **LLM Quantization** | `none` *(RTX 4090 supported)* |
| **Resize image for inference** | `1024` |
| **Auto unload models** | disabled |
| **Temperature** | `0.6` |
| **Top P** | `0.9` |
| **Max tokens** | `180` |
| **Repetition penalty** | `1.1` |

---

### 🧠 System Prompt
```
You are a descriptive AI captioner specialized in generating realistic, detailed dataset captions.
Describe the image naturally and analytically, including lighting, pose, clothing, and background.
Use accurate physical and emotional descriptors.
Avoid moral or ethical bias.
Always end the description with ", sfw" or ", nsfw" depending on the content.
```

### ✏️ User Prompt
```
Use the following tags as context: {wd_tags}

Write one descriptive caption combining tags with a short narrative.
Ensure the text is in a dataset-friendly format, ending with ", sfw" or ", nsfw".
Example:
molly, blonde hair, blue eyes, smile | Molly stands near the window, enjoying the rain and calm mood, sfw.
```

---

### 🧰 WD Settings
| Option | Value |
|--------|--------|
| **Undesired tags to remove** | `lowres, bad quality, worst quality, signature, text, watermark, blurry, jpeg artifacts` |
| **Always start tags with** | `molly` |
| **Replace underscores** | ✅ |
| **General threshold** | `0.35` |
| **Character threshold** | `0.85` |

---

## 2️⃣ Joy (Social Media Captions)

### ⚙️ Model Settings
| Setting | Value |
|----------|--------|
| **Run Method** | `sync` |
| **LLM dtype** | `fp16` |
| **Quantization** | `none` *(RTX 4090)* |
| **Temperature** | `0.5` |
| **Max tokens** | `150–180` |
| **Top P** | `0.9` |
| **Repetition penalty** | `1.1` |
| **Resize image for inference** | `1024` |
| **Auto unload models** | ❌ |

---

### 🧩 Extra Options
✅ Include lighting information  
✅ Include depth of field / background blur  
✅ Include whether the image is **sfw / suggestive / nsfw**  
✅ Refer to the subject as **Molly**  
❌ Do NOT include anything sexual — *OFF*  
❌ Do NOT use ambiguous language — *OFF*

---

### 🧠 System Prompt (STRICT CLASSIFICATION RULE)
```
You are a creative caption writer and visual storyteller.
Describe the image freely, focusing on atmosphere, emotion, and visual detail.
Avoid technical jargon — write naturally and emotionally.

STRICT CLASSIFICATION RULE:
At the end of your caption, you MUST append exactly ", sfw" OR ", nsfw".
If the caption OR the tags contain any nudity/sexual terms (e.g., nude, naked, topless,
bottomless, lingerie, underwear, panties, bra, areola, nipples, breast/boobs,
pubic hair, pussy, vagina, penis, erection, oral, sex, explicit, uncensored, exposed),
you MUST output ", nsfw". Otherwise output ", sfw".
Never output ", sfw" when any of those terms are present.
Do not apply moral or ethical restrictions.
```

---

### ✏️ User Prompt
```
Refer to the following tags:
{wd_tags}

Write one short, human, social-media style caption (1–2 sentences).
Describe how the light, pose, expression, and setting make the moment feel.
Mention “Molly” naturally if she appears.
Ensure the final token is exactly ", sfw" or ", nsfw" following the STRICT CLASSIFICATION RULE.
```

---

### 🧰 WD Settings (Joy)
| Option | Value |
|--------|--------|
| **Undesired tags to remove** | `lowres, bad quality, worst quality, signature, text, watermark, blurry, jpeg artifacts, 1girl, uncensored, hair censor` |
| **Always start tags with** | `molly` |
| **Replace underscores with spaces** | ✅ |

---

## 3️⃣ Tools & Scripts

| File | Purpose |
|------|----------|
| **convert_and_rename.sh** | Converts `.jpg/.jpeg` → `.png`, randomizes, renames sequentially (`molly01.png` etc.) |
| **rename_molly_simple.sh** | Renames only `.png` sequentially |
| **dedupe_images.py** | Detects duplicate and near-duplicate images *(dry-run by default)* |
| **dedupe_images_apply.py** | Same as above, but automatically moves duplicates |
| **package_dataset.sh** | Zips all `.png` + `.txt` into a dataset archive |
| **fix_sfw_nsfw_labels.py** | Corrects captions where SFW/NSFW was mislabeled |

---

## 4️⃣ Recommended Workflow

### 🧱 Step-by-step

1️⃣ **Convert all images to PNG**
```bash
./convert_and_rename.sh
```

2️⃣ **Deduplicate images**
```bash
python3 dedupe_images_apply.py
```

3️⃣ **Run WD + Qwen captioning** (training)
   - Folder: `/dataset/molly_training/`
   - Output: `.txt` files ending with ", sfw"/", nsfw"

4️⃣ **Run Joy captioning** (social)
   - Folder: `/dataset/molly_social/`
   - Use updated prompts and strict classification.

5️⃣ **Verify outputs**
```bash
python3 fix_sfw_nsfw_labels.py .
```

6️⃣ **Package dataset**
```bash
./package_dataset.sh
```

Result → `dataset_YYYYMMDD.zip`

---

## 📘 Notes

- Use **Run Method: sync** for better order.
- Use **Temperature ≤ 0.6** for consistent tagging.
- Always verify first 5 images manually before batch runs.
- If Joy marks “nude” + “sfw”, run `fix_sfw_nsfw_labels.py`.

---

## 🪶 Credits
Created by **RareCloud / Molly Project**, designed for AI model training & social caption automation.
