
#!/usr/bin/env python3
import os, sys, hashlib, shutil, argparse
from pathlib import Path
from PIL import Image, UnidentifiedImageError
import imagehash

IMG_EXTS={".jpg",".jpeg",".png",".webp",".bmp"}

def sha256(p):
    h=hashlib.sha256()
    with open(p,'rb') as f:
        for c in iter(lambda:f.read(1<<20),b''):
            h.update(c)
    return h.hexdigest()

def res(p):
    try:
        with Image.open(p) as im:
            im.draft(im.mode,im.size)
            return im.width or 0, im.height or 0
    except (UnidentifiedImageError,OSError):
        return (0,0)

def phash(p):
    try:
        with Image.open(p) as im:
            return imagehash.phash(im)
    except:
        return None

def pick_best(files):
    scored=[]
    for p in files:
        w,h=res(p); size=Path(p).stat().st_size if Path(p).exists() else 0
        scored.append((w*h,size,p))
    scored.sort(reverse=True)
    keep=scored[0][2]
    dups=[x[2] for x in scored[1:]]
    return keep, dups

def siblings(p, exts=(".txt",".wdcaption",".llmcaption")):
    stem=Path(p).with_suffix("").name; parent=Path(p).parent
    out=[]
    for e in exts:
        cand=parent/f"{stem}{e}"
        if cand.exists(): out.append(cand)
    return out

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("root", nargs="?", default=".")
    ap.add_argument("--threshold", type=int, default=5)
    ap.add_argument("--outdir", default="_duplicates")
    args=ap.parse_args()

    ROOT=Path(args.root).resolve(); OUT=(ROOT/args.outdir).resolve()
    imgs=[str(p) for p in ROOT.rglob("*") if p.suffix.lower() in IMG_EXTS and p.is_file()]
    if not imgs: print("No images found."); return
    print(f"Scanning {len(imgs)} images in: {ROOT}")

    by_sha={}
    for p in imgs:
        by_sha.setdefault(sha256(p), []).append(p)
    exact=[g for g in by_sha.values() if len(g)>1]

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
            if (h1-h2) <= args.threshold:
                group.append(p2)
        if len(group)>1:
            used.update(group)
            near.append(group)

    total=0
    def handle(title, group):
        nonlocal total
        keep, dups = pick_best(group)
        print(f"\n{title}:")
        print(f"  💚 KEEP  → {Path(keep).relative_to(ROOT)}  {res(keep)}")
        for d in dups:
            print(f"  🔴 DUPL  → {Path(d).relative_to(ROOT)}  {res(d)}")
            total += 1
            t=OUT/Path(d).relative_to(ROOT); t.parent.mkdir(parents=True,exist_ok=True)
            shutil.move(d, t)
            for s in siblings(d):
                ts=OUT/Path(s).relative_to(ROOT); ts.parent.mkdir(parents=True,exist_ok=True)
                shutil.move(s, ts)

    for g in exact: handle("[EXACT DUPES]", g)
    for g in near:  handle(f"[NEAR DUPES ≤ {args.threshold}]", g)

    print(f"\nSummary: exact={len(exact)} near={len(near)} dupes={total} mode=APPLY")
    print(f"Moved duplicates to: {OUT}")

if __name__=="__main__":
    main()
