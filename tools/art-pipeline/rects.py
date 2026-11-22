# /// script
# requires-python = ">=3.10"
# dependencies = ["pillow>=10"]
# ///
"""Draw a location's hotspots and exits over its art, to line them up by eye.

    uv run tools/art-pipeline/rects.py ch05 ch05_salon out.png
"""
import json
import sys
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent.parent
SCALE = 3


def main() -> None:
    chapter, loc_id, out = sys.argv[1], sys.argv[2], sys.argv[3]
    ch = json.loads((ROOT / f"data/chapters/{chapter}.json").read_text())
    loc = ch["locations"][loc_id]
    bg = ROOT / loc.get("background", "").replace("res://", "")
    img = Image.open(bg).convert("RGB") if bg.is_file() else Image.new("RGB", (320, 144), (10, 20, 36))
    img = img.resize((img.width * SCALE, img.height * SCALE), Image.Resampling.NEAREST)
    d = ImageDraw.Draw(img)
    for kind, colour in (("hotspots", (226, 174, 79)), ("exits", (87, 163, 156))):
        for h in loc.get(kind, []):
            x, y, w, hh = (v * SCALE for v in h["rect"])
            d.rectangle([x, y, x + w - 1, y + hh - 1], outline=colour, width=2)
            d.text((x + 4, y + 3), h["id"], fill=colour)
    # Grid every 20 px (game units) to read coordinates.
    for gx in range(0, 320, 20):
        d.line([gx * SCALE, 0, gx * SCALE, 4], fill=(255, 255, 255))
        d.text((gx * SCALE + 1, 5), str(gx), fill=(200, 200, 200))
    for gy in range(0, 144, 20):
        d.line([0, gy * SCALE, 4, gy * SCALE], fill=(255, 255, 255))
        d.text((6, gy * SCALE + 1), str(gy), fill=(200, 200, 200))
    img.save(out)
    print(out)


if __name__ == "__main__":
    main()
