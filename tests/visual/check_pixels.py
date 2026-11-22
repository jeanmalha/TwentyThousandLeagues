"""Check that a screenshot from capture.gd is made only of uniform N×N blocks.

Usage: uv run --no-project --with pillow python tests/visual/check_pixels.py shot.png [...]
Exits 1 if any block of the 640×360 frame has mixed colours (blur, uneven scaling).
"""
import sys

from PIL import Image

BASE_W, BASE_H = 640, 360  # art detail is 2× the 320×180 layout
failed = False
for path in sys.argv[1:]:
    im = Image.open(path).convert("RGB")
    w, h = im.size
    px = im.load()
    s = min(w // BASE_W, h // BASE_H)
    ox, oy = (w - BASE_W * s) // 2, (h - BASE_H * s) // 2
    bad = 0
    for by in range(BASE_H):
        for bx in range(BASE_W):
            x0, y0 = ox + bx * s, oy + by * s
            c = px[x0, y0]
            bad += sum(px[x0 + dx, y0 + dy] != c for dy in range(s) for dx in range(s))
    print(f"{path}: {w}x{h}, x{s}, mixed pixels: {bad}")
    failed |= bad > 0
sys.exit(1 if failed else 0)
