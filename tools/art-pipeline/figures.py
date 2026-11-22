# /// script
# requires-python = ">=3.10"
# dependencies = ["pillow>=10", "numpy>=1.26"]
# ///
"""Make the game-size character figures the chapters ask for (TTLUTS-32).

Every hotspot with "npc" and "figure": {"feet": [x, y], "height": h} (layout
units) needs art/figures/<npc>-<2h>.png: the kept cut-out from
art/source/figures/<npc>.png (made by keyout.py), scaled to 2h pixels (art is
2× the layout), reduced to the master palette with the same light dither as
the backgrounds, and given a hard alpha so it stays crisp pixel art.

Usage:
  uv run tools/art-pipeline/figures.py
"""
import json
import sys
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(HERE))
from pixelize import load_palette, reduce  # noqa: E402

PALETTE = load_palette(ROOT / "art/palette/master-64.gpl")


def needed() -> set[tuple[str, int]]:
    out = set()
    for path in sorted((ROOT / "data/chapters").glob("*.json")):
        for loc in json.loads(path.read_text())["locations"].values():
            for h in loc.get("hotspots", []):
                if "npc" in h and "figure" in h:
                    out.add((h["npc"], int(h["figure"]["height"]) * 2))
    return out


def make(npc: str, px: int) -> None:
    src = ROOT / "art/source/figures" / f"{npc}.png"
    if not src.exists():
        print(f"missing {src.relative_to(ROOT)}: run keyout.py first")
        return
    fig = Image.open(src).convert("RGBA")
    fig = fig.resize((max(1, round(fig.width * px / fig.height)), px), Image.LANCZOS)
    alpha = np.asarray(fig)[..., 3]
    rgb = np.asarray(reduce(fig.convert("RGB"), PALETTE, "bayer", 0.4).convert("RGB"))
    out = ROOT / "art/figures" / f"{npc}-{px}.png"
    out.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(np.dstack([rgb, np.where(alpha > 128, 255, 0).astype(np.uint8)]), "RGBA").save(out)
    print(f"{out.relative_to(ROOT)} ({fig.width}x{px})")


if __name__ == "__main__":
    for npc, px in sorted(needed()):
        make(npc, px)
