# /// script
# requires-python = ">=3.10"
# dependencies = ["pillow>=10", "numpy>=1.26"]
# ///
"""Turn a high-resolution generated image into game-ready pixel art.

Steps: crop to the target aspect, downscale to the target size, reduce colours
to a fixed palette (a .gpl/.hex file) or to N adaptive colours, with optional
ordered (Bayer) or Floyd-Steinberg dithering. It also writes an enlarged
preview with nearest-neighbour scaling.

Usage:
  uv run tools/art-pipeline/pixelize.py IN.png --size 96x128 --colors 32 --dither bayer
  uv run tools/art-pipeline/pixelize.py IN.png --size 320x144 --palette master.gpl
"""
import argparse
from pathlib import Path

import numpy as np
from PIL import Image

BAYER4 = (np.array([[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]]) + 0.5) / 16 - 0.5


def load_palette(path: Path) -> np.ndarray:
    colours = []
    for line in path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith(("#", "GIMP", "Name", "Columns")):
            if line.startswith("#") and len(line) in (7, 9):  # "#rrggbb" in a .hex list
                colours.append(tuple(int(line[i:i + 2], 16) for i in (1, 3, 5)))
            continue
        parts = line.split()
        if len(parts) >= 3 and all(p.isdigit() for p in parts[:3]):  # GIMP .gpl row
            colours.append(tuple(int(p) for p in parts[:3]))
        elif len(line) in (6, 7):  # "rrggbb" in a .hex list
            h = line.lstrip("#")
            colours.append(tuple(int(h[i:i + 2], 16) for i in (0, 2, 4)))
    if not colours:
        raise SystemExit(f"No colours found in {path}")
    return np.array(colours, dtype=np.float32)


def adaptive_palette(img: Image.Image, n: int) -> np.ndarray:
    q = img.quantize(colors=n, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    pal = np.array(q.getpalette()[: n * 3], dtype=np.float32).reshape(-1, 3)
    return pal


def nearest(pixels: np.ndarray, pal: np.ndarray) -> np.ndarray:
    d = ((pixels[..., None, :] - pal[None, None, :, :]) ** 2).sum(-1)
    return d.argmin(-1)


def reduce(img: Image.Image, pal: np.ndarray, dither: str, strength: float) -> Image.Image:
    a = np.asarray(img.convert("RGB"), dtype=np.float32)
    h, w, _ = a.shape
    if dither == "bayer":
        # Spread of the threshold scales with the average gap between palette colours.
        spread = strength * 255 / max(2, len(pal) ** (1 / 3))
        t = np.tile(BAYER4, (h // 4 + 1, w // 4 + 1))[:h, :w][..., None]
        idx = nearest(np.clip(a + t * spread, 0, 255), pal)
    elif dither == "fs":
        a = a.copy()
        idx = np.zeros((h, w), dtype=np.int64)
        for y in range(h):
            for x in range(w):
                old = a[y, x]
                i = int(((pal - old) ** 2).sum(1).argmin())
                idx[y, x] = i
                err = (old - pal[i]) * strength
                if x + 1 < w: a[y, x + 1] += err * 7 / 16
                if y + 1 < h:
                    if x > 0: a[y + 1, x - 1] += err * 3 / 16
                    a[y + 1, x] += err * 5 / 16
                    if x + 1 < w: a[y + 1, x + 1] += err * 1 / 16
    else:
        idx = nearest(a, pal)
    return Image.fromarray(pal[idx].astype(np.uint8), "RGB")


def crop_to_aspect(img: Image.Image, tw: int, th: int) -> Image.Image:
    w, h = img.size
    target = tw / th
    if w / h > target:
        nw = round(h * target)
        x = (w - nw) // 2
        return img.crop((x, 0, x + nw, h))
    nh = round(w / target)
    y = (h - nh) // 2
    return img.crop((0, y, w, y + nh))


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("input", type=Path)
    ap.add_argument("--size", default="96x128", help="target WxH in game pixels (default 96x128)")
    src = ap.add_mutually_exclusive_group()
    src.add_argument("--palette", type=Path, help=".gpl or .hex palette file (the master palette)")
    src.add_argument("--colors", type=int, default=32, help="adaptive palette size when no --palette (default 32)")
    ap.add_argument("--dither", choices=["none", "bayer", "fs"], default="bayer")
    ap.add_argument("--strength", type=float, default=0.6, help="dither strength 0..1 (default 0.6)")
    ap.add_argument("--preview-scale", type=int, default=6, help="nearest-neighbour scale of the preview (default 6)")
    ap.add_argument("--out", type=Path, help="output path (default: next to input, *-px.png)")
    args = ap.parse_args()

    tw, th = (int(v) for v in args.size.lower().split("x"))
    img = Image.open(args.input).convert("RGB")
    img = crop_to_aspect(img, tw, th).resize((tw, th), Image.Resampling.LANCZOS)
    pal = load_palette(args.palette) if args.palette else adaptive_palette(img, args.colors)
    px = reduce(img, pal, args.dither, args.strength)

    out = args.out or args.input.with_name(args.input.stem + f"-px{tw}x{th}.png")
    px.save(out)
    preview = out.with_name(out.stem + f"-x{args.preview_scale}.png")
    px.resize((tw * args.preview_scale, th * args.preview_scale), Image.Resampling.NEAREST).save(preview)
    used = len(np.unique(np.asarray(px).reshape(-1, 3), axis=0))
    print(f"{out} ({tw}x{th}, {used} colours used of {len(pal)}), preview {preview}")


if __name__ == "__main__":
    main()
