# /// script
# requires-python = ">=3.10"
# dependencies = ["pillow>=10", "numpy>=1.26"]
# ///
"""Crop the engraving out of a page scan of the 1871 Hetzel edition and tint
it like printed paper, for the game's book pages.

Source: Wikimedia Commons, "Illustrations de Vingt mille lieues sous les mers
- A. de Neuville, Riou, dess. ; Hildibrand, grav." (BnF, btv1b2200238g),
public domain. See art/engravings/SOURCES.md.

    uv run tools/art-pipeline/engravings.py SCAN_DIR 3 11 20 ...   # page numbers
"""
import sys
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent.parent
OUT = ROOT / "art/engravings"
INK = np.array([52, 38, 28], dtype=np.float32)     # warm dark brown
PAPER = np.array([240, 230, 208], dtype=np.float32)  # book page


def longest_run(mask: np.ndarray) -> tuple[int, int]:
    best, start, cur = (0, 0), None, 0
    for i, v in enumerate(list(mask) + [False]):
        if v and start is None:
            start = i
        elif not v and start is not None:
            if i - start > best[1] - best[0]:
                best = (start, i)
            start = None
    return best


def crop(path: Path) -> Image.Image:
    g = np.asarray(Image.open(path).convert("L"), dtype=np.float32)
    dark = g < 150
    h, w = dark.shape
    k = max(5, h // 80)
    rows = np.convolve(dark[:, w // 5: 4 * w // 5].mean(1), np.ones(k) / k, mode="same")
    y0, y1 = longest_run(rows > 0.22)
    cols = np.convolve(dark[y0:y1].mean(0), np.ones(k) / k, mode="same")
    x0, x1 = longest_run(cols > 0.18)
    pad = 2
    return Image.open(path).convert("L").crop((max(0, x0 - pad), max(0, y0 - pad), min(w, x1 + pad), min(h, y1 + pad)))


def tint(img: Image.Image) -> Image.Image:
    a = np.asarray(img, dtype=np.float32)[..., None] / 255.0
    # Stretch contrast a little: paper to paper colour, ink to ink colour.
    a = np.clip((a - 0.08) / 0.84, 0, 1)
    rgb = INK + (PAPER - INK) * a
    return Image.fromarray(rgb.astype(np.uint8), "RGB")


def main() -> None:
    scans = Path(sys.argv[1])
    OUT.mkdir(parents=True, exist_ok=True)
    for n in sys.argv[2:]:
        src = scans / f"hetzel-{int(n):03d}.jpg"
        img = tint(crop(src))
        if img.width > 640:
            img = img.resize((640, round(img.height * 640 / img.width)), Image.Resampling.LANCZOS)
        dest = OUT / f"hetzel-{int(n):03d}.jpg"
        img.save(dest, quality=88)
        print(dest.relative_to(ROOT), img.size)


if __name__ == "__main__":
    main()
