# /// script
# requires-python = ">=3.10"
# dependencies = ["pillow>=10", "numpy>=1.26"]
# ///
"""Cut a character figure out of a green-screen render (TTLUTS-32).

Steps:
1. Measure the key colour from the image border, so it works even when the
   model's "green screen" isn't pure #00FF00.
2. Build an alpha matte from how strongly green dominates each pixel,
   relative to the key, with a soft edge.
3. Despill: pull leftover green out of the edge pixels.
4. Trim to the figure and save the full-resolution cut-out, which is kept
   like the other originals, so nothing has to be regenerated.

figures.py then makes the game-size versions the chapters ask for.

Usage:
  uv run tools/art-pipeline/keyout.py out/figurenemo-flux-1-f8b0.png nemo
"""
import argparse
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]


def key_colour(rgb: np.ndarray) -> np.ndarray:
    border = np.concatenate([rgb[:8].reshape(-1, 3), rgb[-8:].reshape(-1, 3),
                             rgb[:, :8].reshape(-1, 3), rgb[:, -8:].reshape(-1, 3)])
    greenish = border[(border[:, 1] > border[:, 0] + 30) & (border[:, 1] > border[:, 2] + 30)]
    return np.median(greenish if len(greenish) else border, axis=0)


def matte(rgb: np.ndarray, key: np.ndarray, low: float, high: float) -> np.ndarray:
    # Greenness: how much G exceeds both R and B, as a fraction of the key's
    # own. Unlike a plain colour distance, this also keys out the darker,
    # shaded green near the figure's feet.
    r, g, b = rgb[..., 0], rgb[..., 1], rgb[..., 2]
    dom = (g - np.maximum(r, b)) / max(1.0, key[1] - max(key[0], key[2]))
    # Opaque below `low` greenness, transparent above `high`, soft between.
    return np.clip((high - dom) / (high - low), 0, 1)


def despill(rgb: np.ndarray) -> np.ndarray:
    out = rgb.copy()
    limit = np.maximum(out[..., 0], out[..., 2])
    out[..., 1] = np.minimum(out[..., 1], limit)
    return out


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("input", type=Path)
    ap.add_argument("name", help="character id, e.g. nemo: writes art/source/figures/<name>.png")
    ap.add_argument("--low", type=float, default=0.25, help="greenness kept fully opaque (fraction of the key)")
    ap.add_argument("--high", type=float, default=0.5, help="greenness made fully transparent")
    ap.add_argument("--debug", type=Path, help="also write the matte here, for checking")
    args = ap.parse_args()

    rgb = np.asarray(Image.open(args.input).convert("RGB")).astype(np.float32)
    key = key_colour(rgb)
    alpha = matte(rgb, key, args.low, args.high)
    rgb = despill(rgb)
    if args.debug:
        Image.fromarray((alpha * 255).astype(np.uint8)).save(args.debug)
    ys, xs = np.where(alpha > 0.5)
    if len(ys) == 0:
        raise SystemExit("No figure found: the matte is empty")
    y0, y1, x0, x1 = ys.min(), ys.max() + 1, xs.min(), xs.max() + 1
    rgba = np.dstack([rgb, alpha * 255])[y0:y1, x0:x1].clip(0, 255).astype(np.uint8)
    out = ROOT / "art/source/figures" / f"{args.name}.png"
    out.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(rgba, "RGBA").save(out)
    print(f"key {key.astype(int).tolist()} → {out.relative_to(ROOT)} ({x1 - x0}x{y1 - y0}); now run figures.py")


if __name__ == "__main__":
    main()
